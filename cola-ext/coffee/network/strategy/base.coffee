((define) ->
    define ->
        
        ###
        Creates a base strategy function.  If no earlier strategy cancels
        the event, this strategy will apply it to the destination adapter.
        @param options {Object} not currently used
        @return {Function} a network strategy function
        ###
        (options) ->
            baseStrategy = (source, dest, data, type, api) ->
                if api.isPropagating() and type of dest
                    return    if api.isHandled()
                    throw new Error('baseStrategy: ' + type + ' is not a function.')    unless typeof dest[type] is 'function'
                    dest[type] data

    return
) (if typeof define is 'function' and define.amd then define else (factory) ->
    module.exports = factory()
    return
)