###
MIT License (c) copyright B Cavalier & J Hann
###
((define) ->
    define (require) ->
        
        #	"use strict";
        
        ###
        Manages a collection of objects taken a queryable data source, which
        must provide query, add, and remove methods
        @constructor
        @param datasource {Object} queryable data source with query, add, put, remove methods
        @param [options.comparator] {Function} comparator function that will
        be propagated to other adapters as needed.  Note that QueryAdapter does not
        use this comparator internally.
        ###
        QueryAdapter = (datasource, options) ->
            identifier = undefined
            dsQuery = undefined
            self = undefined
            throw new Error('cola/QueryAdapter: datasource must be provided')    unless datasource
            @_datasource = datasource
            options = {}    unless options
            @_options = options
            @provide = options.provide    if 'provide' of options
            
            # Always use the datasource's identity as the identifier
            identifier = @identifier = (item) ->
                
                # TODO: remove dojo-specific behavior
                datasource.getIdentity item

            
            # If no comparator provided, generate one that uses
            # the object identity
            @comparator = @_options.comparator or (a, b) ->
                aKey = undefined
                bKey = undefined
                aKey = identifier(a)
                bKey = identifier(b)
                (if aKey is bKey then 0 else (if aKey < bKey then -1 else 1))

            @_items = new SortedMap(identifier, @comparator)
            
            # override the store's query
            dsQuery = datasource.query
            self = this
            datasource.query = (query) ->
                self._queue ->
                    when_ dsQuery.call(datasource, arguments_), (results) ->
                        self._items = new SortedMap(self.identifier, self.comparator)
                        self._initResultSet results
                        results



            return
        
        ###
        Adds op to the internal queue of async tasks to ensure that
        it will run in the order added and not overlap with other async tasks
        @param op {Function} async task (function that returns a promise) to add
        to the internal queue
        @return {Promise} promise that will resolver/reject when op has completed
        @private
        ###
        
        ###
        Initialized the internal map of items
        @param results {Array} array of result items
        @private
        ###
        
        # This is optimistic, maybe overly so.  It notifies listeners
        # that the item is added, even though there may be an inflight
        # async store.add().  If the add fails, it tries to revert
        # by removing the item from the local map, notifying listeners
        # that it is removed, and "rethrowing" the failure.
        # When we move all data to a central SortedMap, we can handle
        # this behavior with a strategy.
        
        # TODO: allow an item or an id to be provided
        
        # TODO: remove dojo-specific behavior
        
        # Similar to add() above, this should be replaced with a
        # central SortedMap and strategy.
        # If all goes according to plan, great, nothing to do
        
        # Similar to add() above, this should be replaced with a
        # central SortedMap and strategy.
        hasProperties = (o) ->
            return false    unless o
            for p of o
                continue
            return
        when_ = undefined
        SortedMap = undefined
        undef = undefined
        when_ = require('when')
        SortedMap = require('./../SortedMap')
        QueryAdapter:: =
            provide: true
            comparator: undef
            identifier: undef
            query: (query) ->
                @_datasource.query.apply @_datasource, arguments_

            _queue: (op) ->
                @_inflight = when_(@_inflight, ->
                    op()
                )
                @_inflight

            _initResultSet: (results) ->
                map = undefined
                i = undefined
                len = undefined
                item = undefined
                self = undefined
                map = @_items
                map.clear()
                self = this
                i = 0
                len = results.length

                while i < len
                    item = results[i]
                    map.add item, item
                    self.add item
                    i++
                return

            getOptions: ->
                @_options

            forEach: (lambda) ->
                self = this
                @_queue ->
                    self._items.forEach lambda


            add: (item) ->
                items = undefined
                added = undefined
                self = undefined
                items = @_items
                added = items.add(item, item)
                if added >= 0 and not @_dontCallDatasource
                    self = this
                    when_ @_datasource.add(item), ((returned) ->
                        self._execMethodWithoutCallingDatasource 'update', returned    if self._itemWasUpdatedByDatasource(returned)
                        return
                    ), (err) ->
                        self._execMethodWithoutCallingDatasource 'remove', item
                        throw errreturn


            remove: (item) ->
                removed = undefined
                items = undefined
                items = @_items
                removed = items.remove(item)
                if removed >= 0 and not @_dontCallDatasource
                    id = @_datasource.getIdentity(item)
                    when_ @_datasource.remove(id), null, (err) ->
                        self._execMethodWithoutCallingDatasource 'add', item
                        throw errreturn


            update: (item) ->
                orig = undefined
                items = undefined
                self = undefined
                items = @_items
                orig = items.get(item)
                if orig
                    @_replace orig, item
                    unless @_dontCallDatasource
                        self = this
                        when_ @_datasource.put(item), ((returned) ->
                            self._execMethodWithoutCallingDatasource 'update', returned    if self._itemWasUpdatedByDatasource(returned)
                            return
                        ), (err) ->
                            self._execMethodWithoutCallingDatasource 'update', orig
                            throw errreturn


            _replace: (oldItem, newItem) ->
                @_items.remove oldItem
                @_items.add newItem, newItem
                return

            _itemWasUpdatedByDatasource: (item) ->
                hasProperties item

            _execMethodWithoutCallingDatasource: (method, item) ->
                @_dontCallDatasource = true
                try
                    return this[method](item)
                finally
                    @_dontCallDatasource = false
                return

            clear: ->
                @_initResultSet []
                return

        QueryAdapter.canHandle = (it) ->
            it and typeof it.query is 'function' and (it not instanceof QueryAdapter)

        return QueryAdapter
        return

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)