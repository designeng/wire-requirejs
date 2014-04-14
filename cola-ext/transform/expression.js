/*
MIT License (c) copyright B Cavalier & J Hann
*/

(function(define, globalEval) {
  define(function() {
    'use strict';
    /*
    Transforms the supplied property value using the supplied expression
    @param value anything - the value to transform
    @param propName {String} the name of the property being transformed
    @param expression {String} the expression to execute.  It will have
    access to variables named "value" and "propName".
    @returns transformed value
    */

    var expressionTransform;
    return expressionTransform = function(value, propName, item, expression) {
      var ex;
      try {
        return globalEval.call(expression, value, propName, item);
      } catch (_error) {
        ex = _error;
        return ex.message;
      }
    };
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory();
}), function(value, propName, item) {
  var document, window;
  window = void 0;
  document = void 0;
  return eval_('' + this);
});
