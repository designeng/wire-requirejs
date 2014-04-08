define(["underscore", "keysviewmixin", "when", "underscore.string"], function(_, keysViewMixin, When, _Str) {
  var bindKeyEventToMethod, getMethodName;
  bindKeyEventToMethod = function(methodName) {
    return this[methodName];
  };
  getMethodName = function(str) {
    return "on" + _Str.classify.call(this, str);
  };
  return function(options) {
    var addKeyBehavior, injectKeysBehaviorFacet;
    addKeyBehavior = function(facet, options, wire) {
      var target;
      target = facet.target;
      return When(wire({
        options: facet.options
      }), function(options) {
        return wire.loadModule(keysViewMixin).then(function(Module) {
          var evt, keys, methodName, _i, _len,
            _this = this;
          _.extend(target, Module);
          keys = facet.options;
          if (!_.isEmpty(keys)) {
            target.keys = {};
          }
          for (_i = 0, _len = keys.length; _i < _len; _i++) {
            evt = keys[_i];
            methodName = getMethodName(evt);
            if (!target[methodName]) {
              target[methodName] = function(e) {
                return console.log("EVENT:::", e);
              };
            }
          }
          return target;
        });
      });
    };
    injectKeysBehaviorFacet = function(resolver, facet, wire) {
      return resolver.resolve(addKeyBehavior(facet, options, wire));
    };
    return {
      context: {
        "create:after": function(resolver, wire) {
          return resolver.resolve();
        }
      },
      facets: {
        keys: {
          "create:before": injectKeysBehaviorFacet
        }
      }
    };
  };
});
