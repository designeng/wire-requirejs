/*
base
@author: brian
*/

(function(define) {
  define(function(require) {
    /*
    Signal that event has not yet been pushed onto the network.
    Return false to prevent the event from being pushed.
    */

    /*
    Signal that event is currently being propagated to adapters.
    */

    /*
    Signal that an event has already been pushed onto the network.
    Return value is ignored since the event has already propagated.
    */

    /*
    Signal that an event was canceled and not pushed onto the network.
    Return value is ignored since the event has already propagated.
    */

    var BaseHub, afterPhase, baseEvents, beforePhase, callOriginalMethod, canceledPhase, createStrategyApi, defaultIdentifier, eventProcessor, findAdapterForSource, observeMethod, propagatingPhase, simpleStrategy, undef, when_;
    BaseHub = function(options) {
      var eventTypes, t;
      eventTypes = void 0;
      t = void 0;
      this.adapters = [];
      if (!options) {
        options = {};
      }
      this.identifier = options.identifier || defaultIdentifier;
      this.eventProcessor = Object.create(eventProcessor, {
        queue: {
          value: []
        },
        eventProcessor: {
          value: this.processEvent.bind(this)
        }
      });
      eventTypes = this.eventTypes;
      for (t in eventTypes) {
        this.addApi(t);
      }
    };
    createStrategyApi = function(context, eventProcessor) {
      var isPhase;
      isPhase = function(phase) {
        return context.phase === phase;
      };
      return {
        queueEvent: function(source, data, type) {
          return eventProcessor.queueEvent(source, data, type);
        },
        cancel: function() {
          context.canceled = true;
        },
        isCanceled: function() {
          return !!context.canceled;
        },
        handle: function() {
          context.handled = true;
        },
        isHandled: function() {
          return !!context.handled;
        },
        isBefore: function() {
          return isPhase(beforePhase);
        },
        isAfter: function() {
          return isPhase(afterPhase);
        },
        isAfterCanceled: function() {
          return isPhase(canceledPhase);
        },
        isPropagating: function() {
          return isPhase(propagatingPhase);
        }
      };
    };
    callOriginalMethod = function(adapter, orig) {
      return function() {
        return orig.apply(adapter, arguments_);
      };
    };
    observeMethod = function(queue, adapter, type, origMethod) {
      return adapter[type] = function(data) {
        queue.queueEvent(adapter, data, type);
        return origMethod.call(adapter, data);
      };
    };
    findAdapterForSource = function(source, adapters) {
      var adapter, found, i;
      i = void 0;
      adapter = void 0;
      found = void 0;
      i = 0;
      if ((function() {
        var _results;
        _results = [];
        while (!found && (adapter = adapters[i++])) {
          _results.push(adapter.origSource === source);
        }
        return _results;
      })()) {
        found = adapter;
      }
      return found;
    };
    when_ = void 0;
    baseEvents = void 0;
    eventProcessor = void 0;
    simpleStrategy = void 0;
    defaultIdentifier = void 0;
    beforePhase = void 0;
    propagatingPhase = void 0;
    afterPhase = void 0;
    canceledPhase = void 0;
    undef = void 0;
    when_ = require('when');
    eventProcessor = require('./eventProcessor');
    simpleStrategy = require('../network/strategy/default');
    defaultIdentifier = require('../identifier/default');
    baseEvents = {
      update: 1,
      change: 1,
      validate: 1,
      abort: 1,
      submit: 1,
      edit: 1,
      join: 1,
      sync: 1,
      leave: 1
    };
    beforePhase = {};
    propagatingPhase = {};
    afterPhase = {};
    canceledPhase = {};
    BaseHub.prototype = {
      eventTypes: baseEvents,
      dispatchEvent: function(name, data) {
        var ex;
        try {
          return this[name](data);
        } catch (_error) {
          ex = _error;
          return false;
        }
      },
      createAdapter: function(source, options) {
        var Adapter;
        Adapter = this.resolver.resolve(source);
        if (Adapter) {
          return new Adapter(source, options);
        } else {
          return source;
        }
      },
      addSource: function(source, options) {
        var adapter, proxy;
        adapter = void 0;
        proxy = void 0;
        if (!options) {
          options = {};
        }
        if (!options.identifier) {
          options.identifier = this.identifier;
        }
        adapter = this.createAdapter(source, options);
        proxy = this._createAdapterProxy(adapter, options);
        proxy.origSource = source;
        this.adapters.push(proxy);
        this.eventProcessor.processEvent(proxy, null, 'join');
        return adapter;
      },
      processEvent: function(source, data, type) {
        var adapters, context, self, strategy, strategyApi;
        context = void 0;
        strategyApi = void 0;
        self = void 0;
        strategy = void 0;
        adapters = void 0;
        context = {};
        self = this;
        strategy = this.strategy;
        adapters = this.adapters;
        return when_(self.dispatchEvent(eventProcessor.makeBeforeEventName(type), data)).then(function(result) {
          context.canceled = result === false;
          if (context.canceled) {
            return when_.reject(context);
          }
          context.phase = beforePhase;
          strategyApi = createStrategyApi(context, self.eventProcessor);
          return strategy(source, undef, data, type, strategyApi);
        }).then(function() {
          context.phase = propagatingPhase;
          return when_.map(adapters, function(adapter) {
            if (source !== adapter) {
              return strategy(source, adapter, data, type, strategyApi);
            }
          });
        }).then(function() {
          context.phase = (context.canceled ? canceledPhase : afterPhase);
          return strategy(source, undef, data, type, strategyApi);
        }).then(function(result) {
          context.canceled = result === false;
          if (context.canceled) {
            return when_.reject(context);
          }
          return self.dispatchEvent(eventProcessor.makeEventName(type), data);
        }).then(function() {
          return context;
        });
      },
      destroy: function() {
        var adapter, adapters;
        adapters = void 0;
        adapter = void 0;
        adapters = this.adapters;
        if ((function() {
          var _results;
          _results = [];
          while ((adapter = adapters.pop())) {
            _results.push(typeof adapter.destroy === 'function');
          }
          return _results;
        })()) {
          adapter.destroy();
        }
      },
      addApi: function(name) {
        this._addApiMethod(name);
        this._addApiEvent(name);
      },
      _createAdapterProxy: function(adapter, options) {
        var eventFinder, method, name, proxy;
        eventFinder = void 0;
        name = void 0;
        method = void 0;
        proxy = void 0;
        proxy = Object.create(adapter);
        if ('provide' in options) {
          proxy.provide = options.provide;
        }
        eventFinder = this.configureEventFinder(options.eventNames);
        for (name in adapter) {
          method = adapter[name];
          if (typeof method === 'function' && eventFinder(name)) {
            proxy[name] = callOriginalMethod(adapter, method);
            observeMethod(this.eventProcessor, adapter, name, method);
            this.addApi(name);
          }
        }
        return proxy;
      },
      configureEventFinder: function(option) {
        var eventTypes;
        eventTypes = this.eventTypes;
        if (typeof option === 'function') {
          return option;
        } else {
          return function(name) {
            return name in eventTypes;
          };
        }
      },
      _addApiMethod: function(name) {
        var adapters, self;
        adapters = void 0;
        self = void 0;
        eventProcessor = void 0;
        adapters = this.adapters;
        eventProcessor = this.eventProcessor;
        self = this;
        if (!this[name]) {
          this[name] = function(anything) {
            var sourceInfo;
            sourceInfo = void 0;
            sourceInfo = self._findItemFor(anything);
            if (!sourceInfo) {
              sourceInfo = {
                item: anything,
                source: findAdapterForSource(arguments_[1], adapters)
              };
            }
            return eventProcessor.queueEvent(sourceInfo.source, sourceInfo.item, name);
          };
        }
      },
      _addApiEvent: function(name) {
        var eventName;
        eventName = this.eventProcessor.makeEventName(name);
        if (!this[eventName]) {
          this[eventName] = function(data) {};
        }
        eventName = this.eventProcessor.makeBeforeEventName(name);
        if (!this[eventName]) {
          this[eventName] = function(data) {};
        }
      },
      _findItemFor: function(anything) {
        var adapter, adapters, i, item;
        item = void 0;
        i = void 0;
        adapters = void 0;
        adapter = void 0;
        adapters = this.adapters;
        i = 0;
        if ((function() {
          var _results;
          _results = [];
          while (!item && (adapter = adapters[i++])) {
            _results.push(adapter.findItem);
          }
          return _results;
        })()) {
          item = adapter.findItem(anything);
        }
        return item && {
          item: item
        };
      }
    };
    return BaseHub;
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory(require);
}));
