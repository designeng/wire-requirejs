/*
MIT License (c) copyright B Cavalier & J Hann
*/

(function(define) {
  define(function(require) {
    'use strict';
    var makeJoined, methodsToReplace, when_;
    when_ = void 0;
    methodsToReplace = void 0;
    when_ = require('when');
    methodsToReplace = {
      add: 1,
      update: 1,
      remove: 1,
      clear: 1
    };
    /*
    Decorates the supplied primary adapter so that it will provide
    data that is joined from a secondary source specified in options.joinWith
    using the join strategy specified in options.strategy
    
    @param primary {Object} primary adapter
    @param options.joinWith {Object} secondary adapter
    @param options.strategy {Function} join strategy to use in joining
    data from the primary and secondary adapters
    */

    return makeJoined = function(primary, options) {
      var forEachOrig, joinStrategy, joined, methodName, primaryProxy, replaceMethod, secondary;
      replaceMethod = function(adapter, methodName) {
        var orig;
        orig = adapter[methodName];
        adapter[methodName] = function() {
          var joined;
          joined = null;
          return orig.apply(adapter, arguments_);
        };
      };
      if (!(options && options.joinWith && options.strategy)) {
        throw new Error('options.joinWith and options.strategy are required');
      }
      forEachOrig = void 0;
      joined = void 0;
      methodName = void 0;
      secondary = void 0;
      joinStrategy = void 0;
      primaryProxy = void 0;
      secondary = options.joinWith;
      joinStrategy = options.strategy;
      for (methodName in methodsToReplace) {
        replaceMethod(primary, methodName);
      }
      forEachOrig = primary.forEach;
      primaryProxy = {
        forEach: function() {
          return forEachOrig.apply(primary, arguments_);
        }
      };
      primary.forEach = function(lambda) {
        if (!joined) {
          joined = joinStrategy(primaryProxy, secondary);
        }
        return when_(joined, function(joined) {
          var i, len;
          i = 0;
          len = joined.length;
          while (i < len) {
            lambda(joined[i]);
            i++;
          }
        });
      };
      return primary;
    };
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory(require);
}));
