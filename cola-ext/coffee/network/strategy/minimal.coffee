((define) ->
    define (require) ->
        'use strict'
        compose = require('./compose')
        base = require('./base')
        targetFirstItem = require('./targetFirstItem')
        syncAfterJoin = require('./syncAfterJoin')
        syncDataDirectly = require('./syncDataDirectly')
        
        ###
        This is a composition of the minimal strategies to actually do something
        meaningful with cola.
        
        @param options {Object} a conglomeration of all of the options for the
        strategies used.
        @param options.targetFirstItem {Boolean} if truthy, the strategy
        will automatically target the first item that is added to the network.
        If falsey, it will not automatically target.
        
        @return {Function} a composite network strategy function
        ###
        (options) ->
            strategies = undefined
            
            # configure strategies
            strategies = [
                syncAfterJoin(options)
                syncDataDirectly(options)
            ]
            strategies.push targetFirstItem(options)    if options and options.targetFirstItem
            strategies.push base(options)
            
            # compose them
            compose strategies

    return
) (if typeof define is 'function' and define.amd then define else (factory) ->
    module.exports = factory(require)
    return
)