###
MIT License (c) copyright B Cavalier & J Hann
###
((define) ->
    define ->
        identity = (it) ->
            it
        
        ###
        Creates a transform function by composing the supplied transform
        functions.  If all the supplied transform functions have an inverse,
        the returned function will also have an inverse created by composing
        the inverses.
        
        @param transforms... {Array|Function} Array of functions, or varargs
        list of functions.
        
        @returns {Function} composed function, with composed inverse if
        all supplied transforms also have an inverse
        ###
        
        # Flatten arguments list to a single dimensional array
        
        # If all transforms have inverses, we can also compose
        # an inverse transform
        
        ###
        Collects all .inverses of the supplied transforms.
        @param transforms {Array} array of transforms, either *all* or *none* of
        which must have .inverse functions.
        ###
        collectInverses = (transforms) ->
            inverse = undefined
            inverses = undefined
            inverses = []
            i = 0
            len = transforms.length

            while i < len
                inverse = transforms[i].inverse
                inverses.push inverse    if typeof inverse is 'function'
                i++
            throw new Error('Either all or none of the supplied transforms must provide an inverse')    if inverses.length > 0 and inverses.length isnt transforms.length
            inverses
        'use strict'
        concat = undefined
        slice = undefined
        undef = undefined
        concat = Array::concat
        slice = Array::slice
        identity.inverse = identity
        identity.inverse.inverse = identity
        return (transforms) ->
            composed = undefined
            txList = undefined
            inverses = undefined
            return identity    if arguments_.length is 0
            txList = concat.apply([], slice.call(arguments_))
            composed = ->
                args = slice.call(arguments_)
                i = 0
                len = txList.length

                while i < len
                    args[0] = txList[i].apply(undef, args)
                    i++
                args[0]

            inverses = collectInverses(txList)
            if inverses.length
                composed.inverse = ->
                    args = slice.call(arguments_)
                    i = inverses.length - 1

                    while i >= 0
                        args[0] = inverses[i].apply(undef, args)
                        --i
                    args[0]

                composed.inverse.inverse = composed
            composed

        return

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory()
    return
)