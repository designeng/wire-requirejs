###
Model
@author: brian
###
((define) ->
    define (require) ->
        Model = (options) ->
            Base.call this, options
            options = {}    unless options
            @strategy = options.strategy
            @strategy = defaultModelStrategy(options.strategyOptions)    unless @strategy
            return
        Base = undefined
        resolver = undefined
        defaultModelStrategy = undefined
        Base = require('./hub/Base')
        resolver = require('./objectAdapterResolver')
        defaultModelStrategy = require('./network/strategy/defaultModel')
        Model:: = Object.create(Base::,
            resolver:
                value: resolver
        )
        Model

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)