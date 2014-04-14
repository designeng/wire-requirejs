###
MIT License (c) copyright B Cavalier & J Hann
###
((define) ->
    define ->
        'use strict'
        
        ###
        Returns an identifier function that uses the supplied
        propName as the item's identifier.
        ###
        (propName) ->
            (item) ->
                item and item[propName]

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory()
    return
)