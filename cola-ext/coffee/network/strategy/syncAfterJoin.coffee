((define) ->
    define ->
        
        ###
        Returns a strategy function that fires a "sync" function after
        an adapter joins the network.  If the adapter has a truthy `provide`
        option set, a "sync from" event is fired. Otherwise, a "sync to me"
        request is sent.
        @param [options] {Object} options.
        @param [options.isProvider] {Function} function (adapter) { return bool; }
        returns true for adapters that should be considered to be data
        providers.  If not supplied, the default isProvider looks for a
        truthy property on the adapters options called "provide".  If that
        doesn't exist, it checks for data by calling the adapter's forEach.
        If the adapter has data, it is considered to be a provider.
        @return {Function} a network strategy function
        ###
        
        # process this strategy after sending to network
        
        # request to sync *from* source (provide)
        
        # request to sync *to* source (consume)
        defaultIsProvider = (adapter) ->
            adapter.provide
        return (options) ->
            isProvider = undefined
            options = {}    unless options
            isProvider = options.isProvider or defaultIsProvider
            syncAfterJoin = (source, dest, data, type, api) ->
                if 'join' is type and api.isAfter()
                    if isProvider(source)
                        api.queueEvent source, true, 'sync'
                    else
                        api.queueEvent source, false, 'sync'
                return

        return

    return
) (if typeof define is 'function' and define.amd then define else (factory) ->
    module.exports = factory()
    return
)