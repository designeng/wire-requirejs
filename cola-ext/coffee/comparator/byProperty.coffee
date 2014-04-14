###
MIT License (c) copyright B Cavalier & J Hann
###
((define) ->
    define (require) ->
        'use strict'
        naturalOrder = require('./naturalOrder')
        (propName, comparator) ->
            comparator = naturalOrder    unless comparator
            (a, b) ->
                comparator a[propName], b[propName]

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)