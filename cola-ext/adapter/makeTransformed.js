/*
MIT License (c) copyright B Cavalier & J Hann
*/

(function(define) {
  define(function(require) {
    /*
    Returns a view of the supplied collection adapter, such that the view
    appears to contain transformed items, and delegates to the supplied
    adapter.  If an inverse transform is supplied, either via the
    inverse param, or via transform.inverse, it will be used when items
    are added or removed
    @param adapter {Object} the adapter for which to create a transformed view
    @param transform {Function} the transform to apply to items. It may return
    a promise
    @param [inverse] {Function} inverse transform, can be provided explicitly
    if transform doesn't have an inverse property (transform.inverse). It may
    return a promise
    */

    var makeTransformedAndPromiseAware, noop, transformCollection, when_;
    transformCollection = function(adapter, transform, inverse) {
      if (!transform) {
        throw new Error('No transform supplied');
      }
      inverse = inverse || transform.inverse;
      return {
        comparator: adapter.comparator,
        identifier: adapter.identifier,
        forEach: function(lambda) {
          var inflight, transformedLambda;
          transformedLambda = function(item) {
            var inflight;
            inflight = when_(inflight, function() {
              return when_(transform(item), lambda);
            });
            return inflight;
          };
          inflight = void 0;
          return when_(adapter.forEach(transformedLambda), function() {
            return inflight;
          });
        },
        add: makeTransformedAndPromiseAware(adapter, 'add', inverse),
        remove: makeTransformedAndPromiseAware(adapter, 'remove', inverse),
        update: makeTransformedAndPromiseAware(adapter, 'update', inverse),
        clear: function() {
          return adapter.clear();
        },
        getOptions: function() {
          return adapter.getOptions();
        }
      };
    };
    /*
    Creates a promise-aware version of the adapter method that supports
    transform functions that may return a promise
    @param adapter {Object} original adapter
    @param method {String} name of adapter method to make promise-aware
    @param transform {Function} transform function to apply to items
    before passing them to the original adapter method
    @return {Function} if transform is provided, returns a new function
    that applies the (possibly async) supplied transform and invokes
    the original adapter method with the transform result.  If transform
    is falsey, a no-op function will be returned
    */

    makeTransformedAndPromiseAware = function(adapter, method, transform) {
      if (transform) {
        return function(item) {
          return when_(transform(item), function(transformed) {
            return adapter[method](transformed);
          });
        };
      } else {
        return noop;
      }
    };
    noop = function() {};
    when_ = void 0;
    when_ = require('when');
    return transformCollection;
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory(require);
}));
