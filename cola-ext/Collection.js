/*
Collection
*/

(function(define) {
  define(function(require) {
    var Base, Collection, eventTypes, extend, forEach, resolver, simpleStrategy;
    Collection = function(options) {
      Base.call(this, options);
      if (!options) {
        options = {};
      }
      this.strategy = options.strategy;
      if (!this.strategy) {
        this.strategy = simpleStrategy(options.strategyOptions);
      }
    };
    extend = function(base, mixin) {
      var extended, p;
      extended = Object.create(base);
      for (p in mixin) {
        extended[p] = mixin[p];
      }
      return extended;
    };
    Base = void 0;
    resolver = void 0;
    eventTypes = void 0;
    simpleStrategy = void 0;
    Base = require('./hub/Base');
    resolver = require('./collectionAdapterResolver');
    simpleStrategy = require('./network/strategy/default');
    eventTypes = extend(Base.prototype.eventTypes, {
      add: 1,
      remove: 1,
      target: 1,
      select: 1,
      unselect: 1,
      collect: 1,
      deliver: 1
    });
    Collection.prototype = Object.create(Base.prototype, {
      eventTypes: {
        value: eventTypes
      },
      resolver: {
        value: resolver
      },
      forEach: {
        value: forEach = function(lambda) {
          var provider;
          provider = this.getProvider();
          return provider && provider.forEach(lambda);
        }
      },
      findItem: {
        value: function(anything) {
          var info;
          info = this._findItemFor(anything);
          return info && info.item;
        }
      },
      findNode: {
        value: function(anything) {
          var info;
          info = this._findNodeFor(anything);
          return info && info.node;
        }
      },
      getProvider: {
        value: function() {
          var a, i;
          a = void 0;
          i = this.adapters.length;
          if ((function() {
            var _results;
            _results = [];
            while (a = this.adapters[--i]) {
              _results.push(a.provide);
            }
            return _results;
          }).call(this)) {
            return a;
          }
        }
      },
      _findNodeFor: {
        value: function(anything) {
          var adapter, adapters, i, node;
          node = void 0;
          i = void 0;
          adapters = void 0;
          adapter = void 0;
          adapters = this.adapters;
          i = 0;
          if ((function() {
            var _results;
            _results = [];
            while (!node && (adapter = adapters[i++])) {
              _results.push(adapter.findNode);
            }
            return _results;
          })()) {
            node = adapter.findNode(anything);
          }
          return node && {
            node: node
          };
        }
      }
    });
    return Collection;
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory(require);
}));
