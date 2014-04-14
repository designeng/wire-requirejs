(function(define) {
  define(function() {
    'use strict';
    return {
      /*
      Finds an adapter for the given object and the role.
      This is overly simplistic for now. We can replace this
      resolver later.
      @param object {Object}
      @description Loops through all Adapters registered with
      AdapterResolver.register, calling each Adapter's canHandle
      method. Adapters added later are found first.
      */

      resolve: function(object) {
        var Adapter, adapters, i;
        adapters = void 0;
        i = void 0;
        Adapter = void 0;
        adapters = this.adapters;
        if (adapters) {
          i = adapters.length;
          if ((function() {
            var _results;
            _results = [];
            while ((Adapter = adapters[--i])) {
              _results.push(Adapter.canHandle(object));
            }
            return _results;
          })()) {
            return Adapter;
          }
        }
      },
      register: function(Adapter) {
        var adapters;
        adapters = this.adapters;
        if (adapters.indexOf(Adapter) === -1) {
          adapters.push(Adapter);
        }
      }
    };
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory();
}));
