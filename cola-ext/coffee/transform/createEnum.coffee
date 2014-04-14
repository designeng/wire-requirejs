###
MIT License (c) copyright B Cavalier & J Hann
###
((define) ->
    define ->
        'use strict'
        cleanPrototype = {}
        
        ###
        Creates a set of functions that will use the supplied options to
        transform (and reverse-transform) a string or array of strings into
        an object whose properties are the same as the properties in
        options.enumSet and whose values are true or false, depending
        on whether the supplied value matches property names on the
        enumSet.  The supplied value may be a string or an array of strings.
        If enumSet is an object and it's values are strings, it is also
        used as a map to transform the property names of the returned object.
        
        @param options {Object} a hashmap of options for the transform
        @param options.enumSet {Object} or {Array}
        @param options.multi {Boolean} optional. Set to true to allow multiple
        values to be returned from reverse().  Typically, you don't need to
        set this option unless reverse() may be called before transform().
        If transform() is called with an array, multi is auto-set to true.
        @returns {Function} function (value) { returns newValue; }
        
        @description Given the following binding, the data will be converted
        as follows.
        permissions: {
        node: 'myview',
        prop: 'classList',
        enumSet: {
        modify: 'can-edit-data',
        create: 'can-add-data',
        remove: 'can-delete-data'
        }
        }
        transform(['modify', 'create']) ==>
        {
        "can-edit-data": true,
        "can-add-data": true,
        "can-delete-data": false
        }
        reverse({ "can-add-data": true }) ==> ['create']
        ###
        createEnumTransform = (enumSet, options) ->
            
            # TODO: don't waste cpu using maps if the dev gave an array
            enumTransform = (value) ->
                set = undefined
                values = undefined
                i = undefined
                len = undefined
                
                # set multiValues for next reverse call
                multiValued = isArrayLike(value)
                set = beget(emptySet)
                values = [].concat(value)
                len = values.length
                i = 0
                while i < len
                    set[map[values[i]]] = true    if values[i] of map
                    i++
                set
            enumReverse = (set) ->
                values = undefined
                p = undefined
                values = []
                for p of set
                    values.push unmap[p]    if set[p] and p of unmap
                (if multiValued is false then values[0] else values)
            createMap = (obj) ->
                map = undefined
                i = undefined
                len = undefined
                if isArrayLike(obj)
                    map = {}
                    len = obj.length
                    i = 0
                    while i < len
                        map[obj[i]] = obj[i]
                        i++
                else
                    map = beget(obj)
                map
            createReverseMap = (map) ->
                unmap = undefined
                p = undefined
                unmap = {}
                for p of map
                    unmap[map[p]] = p
                unmap
            createEmptySet = (map) ->
                set = undefined
                p = undefined
                set = {}
                for p of map
                    set[p] = false
                set
            toString = (o) ->
                Object::toString.apply o
            isString = (obj) ->
                toString(obj) is '[object String]'
            isArrayLike = (obj) ->
                
                # IE doesn't have string[index]
                obj and obj.length and not isString(obj)
            Begetter = ->
            beget = (obj) ->
                newObj = undefined
                Begetter:: = obj
                newObj = new Begetter()
                Begetter:: = cleanPrototype
                newObj
            map = undefined
            unmap = undefined
            emptySet = undefined
            multiValued = undefined
            map = createMap(enumSet)
            unmap = createReverseMap(map)
            emptySet = createEmptySet(unmap)
            multiValued = options and options.multi
            enumTransform.inverse = enumReverse
            enumReverse.inverse = enumTransform
            return enumTransform
            return

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory()
    return
)