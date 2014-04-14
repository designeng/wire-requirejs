((define) ->
    define (require) ->
        'use strict'
        
        # Note: browser loaders and builders require that we don't "meta-program"
        # the require() calls:
        compose = undefined
        base = undefined
        syncAfterJoin = undefined
        syncModel = undefined
        validate = undefined
        changeEvent = undefined
        compose = require('./compose')
        base = require('./base')
        syncAfterJoin = require('./syncAfterJoin')
        syncModel = require('./syncModel')
        validate = require('./validate')
        changeEvent = require('./changeEvent')
        
        ###
        This is a composition of the strategies that Brian and I think
        make sense. :)
        
        @param options {Object} a conglomeration of all of the options for the
        strategies used.
        @param options.targetFirstItem {Boolean} if truthy, the strategy
        will automatically target the first item that is added to the network.
        If falsey, it will not automatically target.
        @param options.validator {Function} if provided, will be used
        to validate data items on add and update events
        
        @return {Function} a composite network strategy function
        ###
        (options) ->
            
            # compose them
            compose [
                
                # Validate should be early so it can cancel other events
                # when validation fails
                validate(options)
                
                # Change event support should be earlier than sync events
                # so that it can translate them
                changeEvent(options)
                syncAfterJoin(options)
                syncModel(options)
                base(options)
            ]

    return
) (if typeof define is 'function' and define.amd then define else (factory) ->
    module.exports = factory(require)
    return
)