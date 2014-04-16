define(["core/bootApp"], function(app) {
  return function(options) {
    var doRender, renderFacet;
    doRender = function(facet, options, wire) {
      var currentPageView;
      currentPageView = facet.target;
      return app.renderAsPage(currentPageView);
    };
    renderFacet = function(resolver, facet, wire) {
      return resolver.resolve(doRender(facet, options, wire));
    };
    return {
      facets: {
        renderAsPage: {
          ready: renderFacet
        }
      }
    };
  };
});
