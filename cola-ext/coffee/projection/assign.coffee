###
MIT License (c) copyright B Cavalier & J Hann
###
((define) ->
    define ->
        'use strict'
        
        ###
        Creates a projection function that will assign obj2 to a property
        of obj1.  For example, if propName is "foo", then this returns a
        projection function that will behave like
        
        function(obj1, obj2) { obj1['foo'] = obj2; }
        
        @param propName {String} name of obj1 property to which to assign obj2
        @return obj1
        ###
        (propName) ->
            (obj1, obj2) ->
                obj1[propName] = obj2    if obj1
                obj1

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory()
    return
)