###
MIT License (c) copyright B Cavalier & J Hann
###
((global, define) ->
    define (require) ->
        LocalStorageAdapter = (namespace, options) ->
            throw new Error('cola/LocalStorageAdapter: must provide a storage namespace')    unless namespace
            @_namespace = namespace
            options = {}    unless options
            @provide = options.provide    if 'provide' of options
            @_storage = options.localStorage or global.localStorage
            throw new Error('cola/LocalStorageAdapter: localStorage not available, must be supplied in options')    unless @_storage
            @identifier = options.identifier or defaultIdentifier
            data = @_storage.getItem(namespace)
            @_data = (if data then JSON.parse(data) else {})
            return
        'use strict'
        when_ = undefined
        defaultIdentifier = undefined
        undef = undefined
        defaultIdentifier = require('./../identifier/default')
        when_ = require('when')
        LocalStorageAdapter:: =
            provide: true
            identifier: undef
            getOptions: ->
                {}

            forEach: (lambda) ->
                data = @_data
                for key of data
                    lambda data[key]
                return

            add: (item) ->
                id = @identifier(item)
                return null    if id of @_data
                @_data[id] = item
                @_sync()
                id

            remove: (item) ->
                id = @identifier(item)
                return null    unless id of @_data
                delete @_data[id]

                @_sync()
                item

            update: (item) ->
                id = @identifier(item)
                return null    unless id of @_data
                @_data[id] = item
                @_sync()
                item

            clear: ->
                @_storage.removeItem @_namespace
                return

            _sync: ->
                @_storage.setItem @_namespace, JSON.stringify(@_data)
                return

        LocalStorageAdapter

    return
) @window or global, (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)