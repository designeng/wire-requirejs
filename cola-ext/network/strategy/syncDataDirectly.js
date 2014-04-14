(function(define) {
  define(function() {
    'use strict';
    /*
    Creates a strategy to push all data from a source into the consumers
    in the network directly (rather than as a sequence of 'add' events
    in the network) when a sync event happens.
    
    @description This strategy helps eliminate loops and complexities
    when data providers and consumers are added at unpredictable times.
    During a sync, all 'add' events are squelched while providers push
    all items to all consumers.
    
    @param [options.providersAreConsumers] {Boolean} if truthy, providers
    are also treated as consumers and receive items from other providers.
    @return {Function} a network strategy function
    */

    return function(options) {
      var add, consumers, forEach, providers, remove, syncDataDirectly, synced, undef;
      add = function(list, adapter) {
        list.push(adapter);
      };
      remove = function(list, adapter) {
        forEach(list, function(provider, i, providers) {
          if (provider === adapter) {
            providers.splice(i, 1);
          }
        });
      };
      forEach = function(list, lambda) {
        var i, obj;
        i = void 0;
        obj = void 0;
        i = list.length;
        while ((obj = list[--i])) {
          lambda(obj, i, list);
        }
      };
      synced = void 0;
      providers = void 0;
      consumers = void 0;
      undef = void 0;
      if (!options) {
        options = {};
      }
      providers = [];
      consumers = [];
      synced = undef;
      return syncDataDirectly = function(source, dest, provide, type, api) {
        if ('sync' === type && api.isBefore()) {
          synced = source;
          try {
            if (provide) {
              if (typeof source.forEach !== 'function') {
                throw new Error('syncDataDirectly: provider doesn\'t have `forEach()`.');
              }
              add(providers, synced);
              if (options.providersAreConsumers) {
                add(consumers, synced);
              }
              forEach(consumers, function(consumer) {
                source.forEach(function(item) {
                  consumer.add(item);
                });
              });
            } else {
              add(consumers, synced);
              if (typeof source.add === 'function') {
                forEach(providers, function(provider) {
                  provider.forEach(function(item) {
                    synced.add(item);
                  });
                });
              }
            }
            api.cancel();
          } finally {
            synced = undef;
          }
        } else if ('add' === type && synced && !api.isBefore()) {
          api.cancel();
        } else if ('leave' === type && api.isAfter()) {
          remove(providers, source);
          remove(consumers, source);
        }
      };
    };
  });
})((typeof define === 'function' && define.amd ? define : function(factory) {
  module.exports = factory();
}));
