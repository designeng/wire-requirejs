((define) ->
    define ->
        'use strict'
        beforeEvents = undefined
        afterEvents = undefined
        beforeEvents = sync: 1
        afterEvents =
            add: 1
            update: 1
            remove: 1

        
        ###
        Trigger a change event as a result of other events.
        @return {Function} a network strategy function.
        ###
        configure = ->
            queueChange = (source, dest, data, type, api) ->
                api.queueEvent source, data, 'change'    if api.isBefore() and beforeEvents[type] or api.isAfter() and afterEvents[type]
                return

    return
) (if typeof define is 'function' and define.amd then define else (factory) ->
    module.exports = factory()
    return
)