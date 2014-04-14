###
MIT License (c) copyright B Cavalier & J Hann
###
((define) ->
    define ->
        'use strict'
        (a, b) ->
            (if a is b then 0 else (if a < b then -1 else 1))

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory()
    return
)