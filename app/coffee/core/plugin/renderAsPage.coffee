# renderAsPage plugin

# render target in application page region

define [
    "core/bootApp"
], (app) ->

    return (options) ->

        doRender = (facet, options, wire) ->
            currentPageView = facet.target
            app.renderAsPage currentPageView

        renderFacet = (resolver, facet, wire) ->
            resolver.resolve(doRender(facet, options, wire))

        facets: 
            renderAsPage:
                ready: renderFacet