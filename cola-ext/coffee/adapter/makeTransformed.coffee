###
MIT License (c) copyright B Cavalier & J Hann
###
((define) ->
    define (require) ->
        
        ###
        Returns a view of the supplied collection adapter, such that the view
        appears to contain transformed items, and delegates to the supplied
        adapter.  If an inverse transform is supplied, either via the
        inverse param, or via transform.inverse, it will be used when items
        are added or removed
        @param adapter {Object} the adapter for which to create a transformed view
        @param transform {Function} the transform to apply to items. It may return
        a promise
        @param [inverse] {Function} inverse transform, can be provided explicitly
        if transform doesn't have an inverse property (transform.inverse). It may
        return a promise
        ###
        transformCollection = (adapter, transform, inverse) ->
            throw new Error('No transform supplied')    unless transform
            inverse = inverse or transform.inverse
            comparator: adapter.comparator
            identifier: adapter.identifier
            forEach: (lambda) ->
                
                # Ensure that these happen sequentially, even when
                # the transform function is async
                transformedLambda = (item) ->
                    inflight = when_(inflight, ->
                        when_ transform(item), lambda
                    )
                    inflight
                inflight = undefined
                when_ adapter.forEach(transformedLambda), ->
                    inflight


            add: makeTransformedAndPromiseAware(adapter, 'add', inverse)
            remove: makeTransformedAndPromiseAware(adapter, 'remove', inverse)
            update: makeTransformedAndPromiseAware(adapter, 'update', inverse)
            clear: ->
                
                # return the original clear result since it may be a promise
                adapter.clear()

            getOptions: ->
                adapter.getOptions()
        
        ###
        Creates a promise-aware version of the adapter method that supports
        transform functions that may return a promise
        @param adapter {Object} original adapter
        @param method {String} name of adapter method to make promise-aware
        @param transform {Function} transform function to apply to items
        before passing them to the original adapter method
        @return {Function} if transform is provided, returns a new function
        that applies the (possibly async) supplied transform and invokes
        the original adapter method with the transform result.  If transform
        is falsey, a no-op function will be returned
        ###
        makeTransformedAndPromiseAware = (adapter, method, transform) ->
            (if transform then (item) ->
                when_ transform(item), (transformed) ->
                    adapter[method] transformed

             else noop)
        noop = ->
        when_ = undefined
        when_ = require('when')
        return transformCollection
        return

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)