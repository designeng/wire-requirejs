((define) ->
    define ->
        'use strict'
        
        ###
        Creates a strategy to push all data from a source into the consumers
        in the network directly (rather than as a sequence of 'add' events
        in the network) when a sync event happens.
        
        @description This strategy helps eliminate loops and complexities
        when data providers and consumers are added at unpredictable times.
        During a sync, all 'add' events are squelched while providers push
        all items to all consumers.
        
        @param [options.providersAreConsumers] {Boolean} if truthy, providers
        are also treated as consumers and receive items from other providers.
        @return {Function} a network strategy function
        ###
        (options) ->
            
            # TODO: consider putting these on the api object so they can be shared across strategies
            # a list of all known providers and consumers
            # these lists tend to be very small
            
            # the adapter currently being synced
            
            # this strategy stops sync events before going on the network
            
            # provide data onto consumers in network
            
            # keep track of providers
            
            # also add to consumers list, if specified
            
            # push data to all consumers
            
            # keep track of consumers
            
            # provide data onto consumers in network
            
            # consume data from all providers
            
            # the sync event never gets onto the network:
            
            # stop 'add' events between adapters while sync'ing, but allow
            # strategies interested in the event to see it before
            
            # keep track of adapters that leave
            
            # these just end up being noops if the source isn't in the list
            add = (list, adapter) ->
                list.push adapter
                return
            remove = (list, adapter) ->
                forEach list, (provider, i, providers) ->
                    providers.splice i, 1    if provider is adapter
                    return

                return
            forEach = (list, lambda) ->
                i = undefined
                obj = undefined
                i = list.length
                lambda obj, i, list    while (obj = list[--i])
                return
            synced = undefined
            providers = undefined
            consumers = undefined
            undef = undefined
            options = {}    unless options
            providers = []
            consumers = []
            synced = undef
            return syncDataDirectly = (source, dest, provide, type, api) ->
                if 'sync' is type and api.isBefore()
                    synced = source
                    try
                        if provide
                            throw new Error('syncDataDirectly: provider doesn\'t have `forEach()`.')    unless typeof source.forEach is 'function'
                            add providers, synced
                            add consumers, synced    if options.providersAreConsumers
                            forEach consumers, (consumer) ->
                                source.forEach (item) ->
                                    consumer.add item
                                    return

                                return

                        else
                            add consumers, synced
                            if typeof source.add is 'function'
                                forEach providers, (provider) ->
                                    provider.forEach (item) ->
                                        synced.add item
                                        return

                                    return

                        api.cancel()
                    finally
                        synced = undef
                else if 'add' is type and synced and not api.isBefore()
                    api.cancel()
                else if 'leave' is type and api.isAfter()
                    remove providers, source
                    remove consumers, source
                return

            return

    return
) (if typeof define is 'function' and define.amd then define else (factory) ->
    module.exports = factory()
    return
)