((define) ->
    define ->
        'use strict'
        
        ###
        Finds an adapter for the given object and the role.
        This is overly simplistic for now. We can replace this
        resolver later.
        @param object {Object}
        @description Loops through all Adapters registered with
        AdapterResolver.register, calling each Adapter's canHandle
        method. Adapters added later are found first.
        ###
        resolve: (object) ->
            adapters = undefined
            i = undefined
            Adapter = undefined
            adapters = @adapters
            if adapters
                i = adapters.length
                return Adapter    if Adapter.canHandle(object)    while (Adapter = adapters[--i])
            return

        register: (Adapter) ->
            adapters = @adapters
            adapters.push Adapter    if adapters.indexOf(Adapter) is -1
            return

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory()
    return
)