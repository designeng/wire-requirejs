###
MIT License (c) copyright B Cavalier & J Hann
###
((define) ->
    define (require) ->
        
        ###
        Decorator that applies transforms to properties flowing in
        and out of an ObjectAdapter (or similar).
        @param adapter {Object}
        @param transforms {Object}
        ###
        addPropertyTransforms = (adapter, transforms) ->
            origGet = undefined
            origAdd = undefined
            origUpdate = undefined
            origForEach = undefined
            transformedItemMap = undefined
            
            # only override if transforms has properties
            if transforms and hasProperties(transforms)
                origGet = adapter.get
                origAdd = adapter.add
                origUpdate = adapter.update
                origForEach = adapter.forEach
                transformedItemMap = new SortedMap(adapter.identifier, adapter.comparator)
                if origGet
                    adapter.get = transformedGet = (id) ->
                        untransformItem origGet.call(adapter, id), transforms, transformedItemMap
                if origAdd
                    adapter.add = transformedAdd = (item) ->
                        origAdd.call adapter, transformItem(item, transforms, transformedItemMap)
                if origUpdate
                    adapter.update = transformedUpdate = (item) ->
                        origUpdate.call adapter, transformItem(item, transforms, transformedItemMap)
                if origForEach
                    adapter.forEach = transformedForEach = (lambda) ->
                        
                        # Note: potential performance improvement if we cache the
                        # transformed lambdas in a hashmap.
                        transformedLambda = (item, key) ->
                            inverted = untransformItem(item, transforms, transformedItemMap)
                            lambda inverted, key
                        origForEach.call adapter, transformedLambda
            adapter
        identity = (val) ->
            val
        hasProperties = (obj) ->
            for p of obj
                continue
            return
        transformItem = (item, transforms, map) ->
            transformed = undefined
            name = undefined
            transform = undefined
            transformed = {}
            
            # direct transforms
            for name of item
                transform = transforms[name] or identity
                transformed[name] = transform(item[name], name, item)
            
            # derived transforms
            for name of transforms
                transformed[name] = transforms[name](null, name, item)    unless name of item
            
            # remove should be a noop if we don't already have it
            map.remove transformed
            map.add transformed, item
            transformed
        untransformItem = (transformed, transforms, map) ->
            origItem = undefined
            name = undefined
            transform = undefined
            
            # get original item
            origItem = map.get(transformed)
            for name of origItem
                transform = transforms[name] and transforms[name].inverse
                origItem[name] = transform(transformed[name], name, transformed)    if transform
            origItem
        'use strict'
        SortedMap = require('./../SortedMap')
        return addPropertyTransforms
        return

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)