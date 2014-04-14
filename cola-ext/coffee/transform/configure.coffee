###
MIT License (c) copyright B Cavalier & J Hann
###
((define) ->
    define ->
        'use strict'
        (transform, options) ->
            configured = ->
                args = Array::slice.call(arguments_)
                transform.apply this, args.concat(configuredArgs)
            configuredArgs = undefined
            configuredArgs = Array::slice.call(arguments_, 1)
            inverse = transform.inverse
            if typeof inverse is 'function'
                configured.inverse = ->
                    args = Array::slice.call(arguments_)
                    inverse.apply this, args.concat(configuredArgs)

                configured.inverse.inverse = configured
            configured

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory()
    return
)