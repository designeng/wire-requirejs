define(["marionette", "when", "backbone.collectionbinder"], function(Marionette, When) {
  return function(options) {
    var bindFacet, doBind;
    doBind = function(facet, options, wire) {
      var target;
      target = facet.target;
      return When(wire({
        options: facet.options
      }), function(options) {
        var bindings, collectionBinder, elManagerFactory, element, rowHtml, selector, to;
        to = options.options.to;
        bindings = options.options.bindings;
        if (!to) {
          throw new Error('plugin/colBind: "to" must be specified');
        }
        if (!bindings) {
          throw new Error('plugin/colBind: "bindings" must be specified');
        }
        rowHtml = "<tr><td data-name='one'></td><td data-name='two'></td></tr>";
        elManagerFactory = new Backbone.CollectionBinder.ElManagerFactory(rowHtml, "data-name");
        collectionBinder = new Backbone.CollectionBinder(elManagerFactory, {
          autoSort: true
        });
        selector = bindings.selector;
        element = target.$el.find(selector);
        collectionBinder.bind(to, element);
        return target;
      });
    };
    bindFacet = function(resolver, facet, wire) {
      return resolver.resolve(doBind(facet, options, wire));
    };
    return {
      context: {
        ready: function(resolver, wire) {
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
