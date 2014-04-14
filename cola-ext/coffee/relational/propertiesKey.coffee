###
MIT License (c) copyright B Cavalier & J Hann
###
((define) ->
    define ->
        'use strict'
        defaultSeparator = undefined
        undef = undefined
        defaultSeparator = '|'
        
        ###
        Creates a transform whose input is an object and whose output
        is the value of object[propName] if propName is a String, or
        if propName is an Array, the Array.prototype.join()ed values
        of all the property names in the Array.
        @param propName {String|Array} name(s) of the property(ies) on the input object to return
        @return {Function} transform function(object) returns any
        ###
        (propName, separator) ->
            if typeof propName is 'string'
                (object) ->
                    object and object[propName]
            else
                separator = defaultSeparator    if arguments_.length is 1
                (object) ->
                    return undef    unless object
                    values = undefined
                    i = undefined
                    len = undefined
                    val = undefined
                    values = []
                    i = 0
                    len = propName.length

                    while i < len
                        val = object[propName[i]]
                        values.push val    if val?
                        i++
                    values.join separator

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory()
    return
)