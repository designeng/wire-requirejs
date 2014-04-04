define(["marionette"], function(Marionette) {
  return function(options) {
    var bindToCollection, createRouter, currentContext, routeBinding;
    currentContext = null;
    createRouter = function(componentDefinition, wire) {
      return When.promise(function(resolve) {
        var tempRouter;
        if (componentDefinition.options.routerModule) {
          return wire.loadModule(componentDefinition.options.routerModule).then(function(Module) {
            var tempRouter;
            tempRouter = new Module;
            return resolve(tempRouter);
          }, function(error) {
            return console.error(error);
          });
        } else {
          tempRouter = new Backbone.Router();
          return resolve(tempRouter);
        }
      });
    };
    routeBinding = function(tempRouter, componentDefinition, wire) {
      var route, routeFn, spec, _ref, _results;
      _ref = componentDefinition.options.routes;
      _results = [];
      for (route in _ref) {
        spec = _ref[route];
        routeFn = (function(spec) {
          var index, key, keys, vars, _i, _len;
          vars = {};
          if (arguments.length > 1) {
            keys = route.split(':').slice(1);
            for (index = _i = 0, _len = keys.length; _i < _len; index = ++_i) {
              key = keys[index];
              vars[key.replace('/', '')] = arguments[index + 1];
            }
          }
          return wire.loadModule(spec).then(function(specObj) {
            if (currentContext != null) {
              currentContext.destroy();
            }
            specObj.vars = vars;
            return wire.createChild(specObj).then(function(ctx) {
              currentContext = ctx;
              return window.ctx = ctx;
            }, function(error) {
              return console.error(error.stack);
            });
          });
        }).bind(null, spec);
        _results.push(tempRouter.route(route, route, routeFn));
      }
      return _results;
    };
    bindToCollection = function(resolver, componentDefinition, wire) {
      console.log(">>>>>>>>>>>>>>>>>", resolver, componentDefinition, wire);
      return resolver.resolve(tempRouter);
    };
    return {
      context: {
        ready: function(resolver, wire) {
          console.log("plugin READY -----");
          return resolver.resolve();
        }
      },
      destroy: {},
      facets: {
        bind: bindToCollection
      }
    };
  };
});
