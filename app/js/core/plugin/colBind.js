define(["marionette", "when", "backbone.collectionbinder"], function(Marionette, When) {
  return function(options) {
    var bindFacet, doBind;
    doBind = function(facet, options, wire) {
      var target;
      target = facet.target;
      return When(wire({
        options: facet.options
      }), function(options) {
        var to;
        to = options.to;
        if (!!to) {
          throw new Error('wire/cola: "to" must be specified');
        }
        console.log("TARGET", target, options.options.to);
        return target;
      });
    };
    bindFacet = function(resolver, facet, wire) {
      return resolver.resolve(doBind(facet, options, wire));
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
        bind: {
          ready: bindFacet
        }
      }
    };
  };
});
