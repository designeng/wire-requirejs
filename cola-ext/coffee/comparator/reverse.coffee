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
        
        ###
        Creates a comparator function that compares items in the reverse
        order of the supplied comparator.
        
        @param comparator {Function} original comparator function to reverse
        ###
        reverse = (comparator) ->
            throw new Error('comparator/reverse: input comparator must be provided')    unless typeof comparator is 'function'
            (a, b) ->
                comparator b, a

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory()
    return
)