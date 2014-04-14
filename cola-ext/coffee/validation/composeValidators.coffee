###
@license MIT License (c) copyright B Cavalier & J Hann
###
((define) ->
    define ->
        
        ###
        Creates a composite validator from the supplied array of validators.
        The composite validator will run each validator and merge the validation
        results into a final, composite validation results object.
        
        @param validators {Array} array of validator functions
        
        @return {Object} composite validation results
        ###
        
        ###
        Merge validation results from a single validator into composite results
        @param merged {Object} composite validation results so far
        @param results {Object} validation results from one validator
        ###
        mergeResults = (merged, results) ->
            if results
                merged.valid = merged.valid and results.valid
                merged.errors = (merged.errors or []).concat(results.errors)    if results.errors
            return
        'use strict'
        return composeValidators = (validators) ->
            compositeValidator = (object) ->
                validator = undefined
                i = undefined
                compositeResults = undefined
                i = 0
                compositeResults = valid: true
                mergeResults compositeResults, validator(object)    while validator = validators[i++]
                compositeResults

        return

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory()
    return
)