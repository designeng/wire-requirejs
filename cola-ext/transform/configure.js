/*
MIT License (c) copyright B Cavalier & J Hann
*/

(function(define) {
  define(function() {
    'use strict';
    return function(transform, options) {
      var configured, configuredArgs, inverse;
      configured = function() {
        var args;
        args = Array.prototype.slice.call(arguments_);
        return transform.apply(this, args.concat(configuredArgs));
      };
      configuredArgs = void 0;
      configuredArgs = Array.prototype.slice.call(arguments_, 1);
      inverse = transform.inverse;
      if (typeof inverse === 'function') {
        configured.inverse = function() {
          var args;
          args = Array.prototype.slice.call(arguments_);
          return inverse.apply(this, args.concat(configuredArgs));
        };
        configured.inverse.inverse = configured;
      }
      return configured;
    };
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory();
}));
