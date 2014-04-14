((define) ->
    define ->
        
        ###
        Executes a configured validator and issues a validation event
        with the results in response to an add or update event.
        Cancels* the add or update if validation fails
        @param [options.validator] {Function} validator function
        @return {Function} a network strategy function.
        ###
        
        # Run validator on items before add or update
        defaultValidator = (item) ->
            valid: item?
        'use strict'
        return configure = (options) ->
            validator = (options and options.validator) or defaultValidator
            validate = (source, dest, data, type, api) ->
                result = undefined
                if api.isBefore() and ('add' is type or 'update' is type)
                    result = validator(data)
                    api.cancel()    unless result.valid
                    api.queueEvent source, result, 'validate'
                return

        return

    return
) (if typeof define is 'function' and define.amd then define else (factory) ->
    module.exports = factory()
    return
)