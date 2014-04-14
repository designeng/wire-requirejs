/*
@license MIT License (c) copyright B Cavalier & J Hann
*/

(function(define) {
  define(function() {
    /*
    Creates a composite validator from the supplied array of validators.
    The composite validator will run each validator and merge the validation
    results into a final, composite validation results object.
    
    @param validators {Array} array of validator functions
    
    @return {Object} composite validation results
    */

    /*
    Merge validation results from a single validator into composite results
    @param merged {Object} composite validation results so far
    @param results {Object} validation results from one validator
    */

    var composeValidators, mergeResults;
    mergeResults = function(merged, results) {
      if (results) {
        merged.valid = merged.valid && results.valid;
        if (results.errors) {
          merged.errors = (merged.errors || []).concat(results.errors);
        }
      }
    };
    'use strict';
    return composeValidators = function(validators) {
      var compositeValidator;
      return compositeValidator = function(object) {
        var compositeResults, i, validator;
        validator = void 0;
        i = void 0;
        compositeResults = void 0;
        i = 0;
        compositeResults = {
          valid: true
        };
        while (validator = validators[i++]) {
          mergeResults(compositeResults, validator(object));
        }
        return compositeResults;
      };
    };
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory();
}));
