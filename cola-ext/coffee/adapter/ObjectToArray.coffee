###
MIT License (c) copyright B Cavalier & J Hann
###
((define) ->
    define (require) ->
        
        ###
        Manages a collection of objects created by transforming the input Object
        (or Promise for an Object) into a collection using the supplied
        options.transform
        @constructor
        @param object {Object|Promise} Object or Promise for an Object
        @param options.identifier {Function} function that returns a key/id for
        a data item.
        @param options.comparator {Function} comparator function that will
        be propagated to other adapters as needed
        @param options.transform {Function} transform function that will
        transform the input object into a collection
        ###
        WidenAdapter = (object, options) ->
            throw new Error('options.transform must be provided')    unless options and options.transform
            @_transform = options.transform
            delete options.transform

            ArrayAdapter.call this, object, options
            return
        'use strict'
        ArrayAdapter = undefined
        ObjectAdapter = undefined
        when_ = undefined
        ArrayAdapter = require('./Array')
        ObjectAdapter = require('./Object')
        when_ = require('when')
        WidenAdapter:: = new ArrayAdapter()
        WidenAdapter::_init = (object) ->
            ArrayAdapter::_init.call this, @_transform(object)
            return

        
        ###
        Tests whether the given object is a candidate to be handled by
        this adapter.  Returns true if the object is a promise or
        ArrayAdapter.canHandle returns true;
        
        WARNING: Testing for a promise is NOT sufficient, since the promise
        may result to something that this adapter cannot handle.
        
        @param it
        @return {Boolean}
        ###
        WidenAdapter.canHandle = (it) ->
            when_.isPromise(it) or ObjectAdapter.canHandle(it)

        WidenAdapter

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)