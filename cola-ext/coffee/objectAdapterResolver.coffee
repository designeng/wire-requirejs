###
objectAdapterResolver
@author: brian
###
((define) ->
    define (require) ->
        adapterResolver = require('./adapterResolver')
        Object.create adapterResolver,
            adapters:
                value: [
                    require('./dom/adapter/Node')
                    require('./adapter/Object')
                ]


    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)