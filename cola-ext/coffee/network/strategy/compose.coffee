((define) ->
    define (require) ->
        
        ###
        Returns a network strategy that is a composition of two or more
        other strategies.  The strategies are executed in the order
        in which they're provided.  If any strategy cancels, the remaining
        strategies are never executed and the cancel is sent back to the Hub.
        
        @param strategies {Array} collection of network strategies.
        @return {Function} a composite network strategy function
        ###
        propagateSuccess = (x) ->
            x
        'use strict'
        when_ = require('when')
        return composeStrategies = (strategies) ->
            (source, dest, data, type, api) ->
                when_.reduce(strategies, (result, strategy) ->
                    strategyResult = strategy(source, dest, data, type, api)
                    (if api.isCanceled() then when_.reject(strategyResult) else strategyResult)
                , data).then propagateSuccess, propagateSuccess

        return

    return
) (if typeof define is 'function' and define.amd then define else (factory) ->
    module.exports = factory(require)
    return
)