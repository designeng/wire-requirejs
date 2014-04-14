(function(define) {
  define(function(require) {
    /*
    Returns a network strategy that is a composition of two or more
    other strategies.  The strategies are executed in the order
    in which they're provided.  If any strategy cancels, the remaining
    strategies are never executed and the cancel is sent back to the Hub.
    
    @param strategies {Array} collection of network strategies.
    @return {Function} a composite network strategy function
    */

    var composeStrategies, propagateSuccess, when_;
    propagateSuccess = function(x) {
      return x;
    };
    'use strict';
    when_ = require('when');
    return composeStrategies = function(strategies) {
      return function(source, dest, data, type, api) {
        return when_.reduce(strategies, function(result, strategy) {
          var strategyResult;
          strategyResult = strategy(source, dest, data, type, api);
          if (api.isCanceled()) {
            return when_.reject(strategyResult);
          } else {
            return strategyResult;
          }
        }, data).then(propagateSuccess, propagateSuccess);
      };
    };
  });
})((typeof define === 'function' && define.amd ? define : function(factory) {
  module.exports = factory(require);
}));
