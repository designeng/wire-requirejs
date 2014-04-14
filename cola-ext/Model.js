/*
Model
@author: brian
*/

(function(define) {
  define(function(require) {
    var Base, Model, defaultModelStrategy, resolver;
    Model = function(options) {
      Base.call(this, options);
      if (!options) {
        options = {};
      }
      this.strategy = options.strategy;
      if (!this.strategy) {
        this.strategy = defaultModelStrategy(options.strategyOptions);
      }
    };
    Base = void 0;
    resolver = void 0;
    defaultModelStrategy = void 0;
    Base = require('./hub/Base');
    resolver = require('./objectAdapterResolver');
    defaultModelStrategy = require('./network/strategy/defaultModel');
    Model.prototype = Object.create(Base.prototype, {
      resolver: {
        value: resolver
      }
    });
    return Model;
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory(require);
}));
