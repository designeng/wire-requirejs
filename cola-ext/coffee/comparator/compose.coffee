###
@license MIT License (c) copyright B Cavalier & J Hann
###

###
Licensed under the MIT License at:
http://www.opensource.org/licenses/mit-license.php
###
((define) ->
    define ->
        'use strict'
        compose = (comparators) -> #...
            throw new Error('comparator/compose: No comparators provided')    unless arguments_.length
            comparators = arguments_
            (a, b) ->
                result = undefined
                len = undefined
                i = undefined
                i = 0
                len = comparators.length
                loop
                    result = comparators[i](a, b)
                    break unless result is 0 and ++i < len
                result

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory()
    return
)