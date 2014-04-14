###
MIT License (c) copyright B Cavalier & J Hann
###
((define) ->
    define (require) ->
        
        ###
        Adapter that handles a plain object or a promise for a plain object
        @constructor
        @param obj {Object|Promise}
        @param options {Object}
        ###
        ObjectAdapter = (obj, options) ->
            options = {}    unless options
            @_obj = obj
            @_options = options
            @provide = options.provide    if 'provide' of options
            return
        'use strict'
        when_ = require('when')
        ObjectAdapter:: =
            provide: true
            update: (item) ->
                self = this
                when_ @_obj, (obj) ->
                    updateSynchronously = (item) ->
                        
                        # don't replace item in case we got a partial object
                        for p of item
                            obj[p] = item[p]
                        return
                    self.update = updateSynchronously
                    updateSynchronously item


            properties: (lambda) ->
                self = this
                when_ @_obj, (obj) ->
                    properties = (l) ->
                        l obj
                        return
                    self.properties = properties
                    properties lambda


            getOptions: ->
                @_options

        
        ###
        Tests whether the given object is a candidate to be handled by
        this adapter.  Returns true if the object is of type 'object'.
        @param obj
        @returns {Boolean}
        ###
        ObjectAdapter.canHandle = (obj) ->
            
            # this seems close enough to ensure that instanceof works.
            # a RegExp will pass as a valid prototype, but I am not sure
            # this is a bad thing even if it is unusual.
            # IMPORTANT: since promises *are* objects, the check for isPromise
            # must come first in the OR
            obj and (when_.isPromise(obj) or Object::toString.call(obj) is '[object Object]')

        ObjectAdapter

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)