(function(define) {
  define(function() {
    /*
    Returns a strategy function that fires a "sync" function after
    an adapter joins the network.  If the adapter has a truthy `provide`
    option set, a "sync from" event is fired. Otherwise, a "sync to me"
    request is sent.
    @param [options] {Object} options.
    @param [options.isProvider] {Function} function (adapter) { return bool; }
    returns true for adapters that should be considered to be data
    providers.  If not supplied, the default isProvider looks for a
    truthy property on the adapters options called "provide".  If that
    doesn't exist, it checks for data by calling the adapter's forEach.
    If the adapter has data, it is considered to be a provider.
    @return {Function} a network strategy function
    */

    var defaultIsProvider;
    defaultIsProvider = function(adapter) {
      return adapter.provide;
    };
    return function(options) {
      var isProvider, syncAfterJoin;
      isProvider = void 0;
      if (!options) {
        options = {};
      }
      isProvider = options.isProvider || defaultIsProvider;
      return syncAfterJoin = function(source, dest, data, type, api) {
        if ('join' === type && api.isAfter()) {
          if (isProvider(source)) {
            api.queueEvent(source, true, 'sync');
          } else {
            api.queueEvent(source, false, 'sync');
          }
        }
      };
    };
  });
})((typeof define === 'function' && define.amd ? define : function(factory) {
  module.exports = factory();
}));
