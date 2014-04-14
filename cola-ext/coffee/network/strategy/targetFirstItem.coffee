((define) ->
    define ->
        'use strict'
        
        ###
        Targets the first item added after a sync.
        @param [options] {Object} not currently used.
        @return {Function} a network strategy function.
        ###
        configure = (options) ->
            first = true
            targetFirstItem = (source, dest, data, type, api) ->
                
                # check to send "target" event before it gets on the network
                # since sync strategies may squelch network events
                if api.isBefore()
                    if first and 'add' is type
                        api.queueEvent source, data, 'target'
                        first = false
                    else first = true    if 'sync' is type
                return

    return
) (if typeof define is 'function' and define.amd then define else (factory) ->
    module.exports = factory()
    return
)