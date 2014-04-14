###
MIT License (c) copyright B Cavalier & J Hann
###
((define) ->
    define (require) ->
        'use strict'
        property = require('./property')
        property 'id'

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)