###
MIT License (c) copyright B Cavalier & J Hann
###
((define) ->
    define (require) ->
        
        ###
        Perform a left outer join on the supplied left and right iterables, returning
        a promise, which will resolve to an Array for the joined result.
        
        @param left {Iterable} anything with forEach. May be asynchronous
        @param leftKeyFunc {Function} function to generate a hash join key for left items
        @param right {Iterable} anything with forEach. May be asynchronous
        @param rightKeyFunc {Function} function to generate a hash join key for right items
        @param projectionFunc {Function} function to create a projected result from two joined items
        @param multiProjection {Boolean} by default (multiProjection is falsey), each left-right join pair will be passed
        to projectionFunc.  Thus, the projectionFunc may be invoked with the same left item
        many times.  if truthy, however, the left item and *all* its matching right items, as
        an Array, will be passed to projectionFunc.  Thus, the projectionFunc will be invoked
        only once per left item.
        @return {Promise} promise for the Array of joined results.
        ###
        leftOuterJoin = (left, leftKeyFunc, right, rightKeyFunc, projectionFunc, multiProjection) ->
            projectJoinResults = (if multiProjection then projectMulti else projectEach)
            when_ buildJoinMap(right, rightKeyFunc), (joinMap) ->
                doJoin left, leftKeyFunc, joinMap, projectJoinResults, projectionFunc

        buildJoinMap = (items, keyFunc) ->
            joinMap = {}
            
            # Use joinMap as a multi-map, i.e. key -> array of values
            when_(items.forEach((item) ->
                addToMap = (rightKey, item) ->
                    rightItems = joinMap[rightKey]
                    unless rightItems
                        rightItems = []
                        joinMap[rightKey] = rightItems
                    rightItems.push item
                    return
                rightKey = undefined
                rightKey = keyFunc(item)
                if isArray(rightKey)
                    forEach rightKey, (rightKey) ->
                        addToMap rightKey, item
                        return

                else
                    addToMap rightKey, item
                return
            )).then ->
                joinMap

        doJoin = (items, keyFunc, joinMap, projectJoinResults, projectionFunc) ->
            joined = []
            when_(items.forEach((item) ->
                join = (joinKey, item, map) ->
                    joinMatches = map[joinKey]
                    projectJoinResults item, joinMatches, joinKey, projectionFunc, joined
                    return
                joinKey = undefined
                joinKey = keyFunc(item)
                if isArray(joinKey)
                    forEach joinKey, (joinKey) ->
                        join joinKey, item, joinMap
                        return

                else
                    join joinKey, item, joinMap
                return
            )).then ->
                joined

        isArray = (it) ->
            Object::toString.call(it) is '[object Array]'
        projectMulti = (leftItem, rightMatches, joinKey, projectionFunc, results) ->
            items = projectionFunc(leftItem, rightMatches, joinKey)
            results.splice results.length, 0, items
            return
        projectEach = (leftItem, rightMatches, joinKey, projectionFunc, results) ->
            project = (left, right, key) ->
                items = projectionFunc(left, right, key)
                results.push items
                return
            if rightMatches
                rightMatches.forEach (rightItem) ->
                    project leftItem, rightItem, joinKey
                    return

            else
                project leftItem, undef, joinKey
            return
        forEach = (arr, lambda) ->
            i = 0
            len = arr.length

            while i < len
                lambda arr[i], i, arr
                i++
            return
        'use strict'
        when_ = undefined
        undef = undefined
        when_ = require('when')
        return leftOuterJoin: leftOuterJoin
        return

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)