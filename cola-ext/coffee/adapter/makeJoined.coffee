###
MIT License (c) copyright B Cavalier & J Hann
###

# TODO:
# 1. Incrementally recompute the join for items added to or removed from the
#    primary adapter.  This requires precomputing and hanging onto the joinMap
# 2. Recompute the join when items are added to or removed from the supplimental
((define) ->
    define (require) ->
        'use strict'
        when_ = undefined
        methodsToReplace = undefined
        when_ = require('when')
        methodsToReplace =
            add: 1
            update: 1
            remove: 1
            clear: 1

        
        ###
        Decorates the supplied primary adapter so that it will provide
        data that is joined from a secondary source specified in options.joinWith
        using the join strategy specified in options.strategy
        
        @param primary {Object} primary adapter
        @param options.joinWith {Object} secondary adapter
        @param options.strategy {Function} join strategy to use in joining
        data from the primary and secondary adapters
        ###
        makeJoined = (primary, options) ->
            replaceMethod = (adapter, methodName) ->
                orig = adapter[methodName]
                adapter[methodName] = ->
                    
                    # Force the join to be recomputed when data changes
                    # This is way too aggressive, but also very safe.
                    # We can optimize to incrementally recompute if it
                    # becomes a problem.
                    joined = null
                    orig.apply adapter, arguments_

                return
            throw new Error('options.joinWith and options.strategy are required')    unless options and options.joinWith and options.strategy
            forEachOrig = undefined
            joined = undefined
            methodName = undefined
            secondary = undefined
            joinStrategy = undefined
            primaryProxy = undefined
            secondary = options.joinWith
            joinStrategy = options.strategy
            
            # Replace the primary adapters cola event methods
            for methodName of methodsToReplace
                replaceMethod primary, methodName
            
            # Create a proxy adapter that has a forEach that provides
            # access to the primary adapter's *original* data.  We must
            # send this to the join strategy since we're *replacing* the
            # primary adapter's forEach with one that calls the joinStrategy.
            # That would lead to an infinite call cycle.
            forEachOrig = primary.forEach
            primaryProxy = forEach: ->
                forEachOrig.apply primary, arguments_

            primary.forEach = (lambda) ->
                joined = joinStrategy(primaryProxy, secondary)    unless joined
                when_ joined, (joined) ->
                    i = 0
                    len = joined.length

                    while i < len
                        lambda joined[i]
                        i++
                    return


            primary

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)