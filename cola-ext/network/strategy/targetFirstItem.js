(function(define) {
  define(function() {
    'use strict';
    /*
    Targets the first item added after a sync.
    @param [options] {Object} not currently used.
    @return {Function} a network strategy function.
    */

    var configure;
    return configure = function(options) {
      var first, targetFirstItem;
      first = true;
      return targetFirstItem = function(source, dest, data, type, api) {
        if (api.isBefore()) {
          if (first && 'add' === type) {
            api.queueEvent(source, data, 'target');
            first = false;
          } else {
            if ('sync' === type) {
              first = true;
            }
          }
        }
      };
    };
  });
})((typeof define === 'function' && define.amd ? define : function(factory) {
  module.exports = factory();
}));
