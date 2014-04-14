(function(define) {
  define(function() {
    /*
    Executes a configured validator and issues a validation event
    with the results in response to an add or update event.
    Cancels* the add or update if validation fails
    @param [options.validator] {Function} validator function
    @return {Function} a network strategy function.
    */

    var configure, defaultValidator;
    defaultValidator = function(item) {
      return {
        valid: item != null
      };
    };
    'use strict';
    return configure = function(options) {
      var validate, validator;
      validator = (options && options.validator) || defaultValidator;
      return validate = function(source, dest, data, type, api) {
        var result;
        result = void 0;
        if (api.isBefore() && ('add' === type || 'update' === type)) {
          result = validator(data);
          if (!result.valid) {
            api.cancel();
          }
          api.queueEvent(source, result, 'validate');
        }
      };
    };
  });
})((typeof define === 'function' && define.amd ? define : function(factory) {
  module.exports = factory();
}));
