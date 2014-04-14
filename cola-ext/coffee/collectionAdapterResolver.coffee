###
collectionAdapterResolver
@author: brian
###
((define) ->
    define (require) ->
        adapterResolver = require('./adapterResolver')
        Object.create adapterResolver,
            adapters:
                value: [
                    require('./adapter/Array')
                    require('./dom/adapter/NodeList')
                    require('./adapter/Query')
                ]


    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)