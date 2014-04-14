###
MIT License (c) copyright B Cavalier & J Hann
###

# TODO: Evaluate whether ArrayAdapter should use SortedMap internally to
# store items in sorted order based on its comparator
((define) ->
    define (require) ->
        
        ###
        Manages a collection of objects taken from the supplied dataArray
        @param dataArray {Array} array of data objects to use as the initial
        population
        @param options.identifier {Function} function that returns a key/id for
        a data item.
        @param options.comparator {Function} comparator function that will
        be propagated to other adapters as needed
        ###
        ArrayAdapter = (dataArray, options) ->
            options = {}    unless options
            @_options = options
            
            # Use the default comparator if none provided.
            # The consequences of this are that the default comparator will
            # be propagated to downstream adapters *instead of* an upstream
            # adapter's comparator
            @comparator = options.comparator or @_defaultComparator
            @identifier = options.identifier or defaultIdentifier
            @provide = options.provide    if 'provide' of options
            @_array = dataArray
            @clear()
            self = this
            when_ dataArray, (array) ->
                mixin self, methods
                self._init array
                return

            return
        
        ###
        Default comparator that uses an item's position in the array
        to order the items.  This is important when an input array is already
        in sorted order, so the user doesn't have to specify a comparator,
        and so the order can be propagated to other adapters.
        @param a
        @param b
        @return {Number} -1 if a is before b in the input array
        1 if a is after b in the input array
        0 iff a and b have the same symbol as returned by the configured identifier
        ###
        
        # just stubs for now
        
        # TODO: Should we catch exceptions here?
        
        # Rebuild index
        
        ###
        @param to
        @param from
        @param [transform]
        ###
        mixin = (to, from, transform) ->
            name = undefined
            func = undefined
            for name of from
                if from.hasOwnProperty(name)
                    func = from[name]
                    to[name] = (if transform then transform(func) else func)
            to
        
        ###
        Returns a new function that will delay execution of the supplied
        function until this._resultSetPromise has resolved.
        
        @param func {Function} original function
        @return {Promise}
        ###
        makePromiseAware = (func) ->
            promiseAware = ->
                self = undefined
                args = undefined
                self = this
                args = Array::slice.call(arguments_)
                when_ @_array, ->
                    func.apply self, args

        defaultIdentifier = (item) ->
            (if typeof item is 'object' then item.id else item)
        
        ###
        Adds all the items, starting at the supplied start index,
        to the supplied adapter.
        @param adapter
        @param items
        ###
        addAll = (adapter, items) ->
            i = 0
            len = items.length

            while i < len
                adapter.add items[i]
                i++
            return
        buildIndex = (items, keyFunc) ->
            index = undefined
            i = undefined
            len = undefined
            index = {}
            i = 0
            len = items.length

            while i < len
                index[keyFunc(items[i])] = i
                i++
            index
        'use strict'
        when_ = undefined
        methods = undefined
        undef = undefined
        when_ = require('when')
        ArrayAdapter:: =
            provide: true
            _init: (dataArray) ->
                addAll this, dataArray    if dataArray and dataArray.length
                return

            _defaultComparator: (a, b) ->
                aIndex = undefined
                bIndex = undefined
                aIndex = @_index(@identifier(a))
                bIndex = @_index(@identifier(b))
                aIndex - bIndex

            comparator: undef
            identifier: undef
            getOptions: ->
                @_options

            forEach: (lambda) ->
                @_forEach lambda

            add: (item) ->
                @_add item

            remove: (item) ->
                @_remove item

            update: (item) ->
                @_update item

            clear: ->
                @_clear()

        methods =
            _forEach: (lambda) ->
                i = undefined
                data = undefined
                len = undefined
                i = 0
                data = @_data
                len = data.length
                while i < len
                    lambda data[i]
                    i++
                return

            _add: (item) ->
                key = undefined
                index = undefined
                key = @identifier(item)
                index = @_index
                return null    if key of index
                index[key] = @_data.push(item) - 1
                index[key]

            _remove: (itemOrId) ->
                key = undefined
                at = undefined
                index = undefined
                data = undefined
                key = @identifier(itemOrId)
                index = @_index
                return null    unless key of index
                data = @_data
                at = index[key]
                data.splice at, 1
                @_index = buildIndex(data, @identifier)
                at

            _update: (item) ->
                key = undefined
                at = undefined
                index = undefined
                key = @identifier(item)
                index = @_index
                at = index[key]
                if at >= 0
                    @_data[at] = item
                else
                    index[key] = @_data.push(item) - 1
                at

            _clear: ->
                @_data = []
                @_index = {}
                return

        mixin ArrayAdapter::, methods, makePromiseAware
        ArrayAdapter.canHandle = (it) ->
            it and (when_.isPromise(it) or Object::toString.call(it) is '[object Array]')

        ArrayAdapter

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)