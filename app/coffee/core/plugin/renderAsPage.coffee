# renderAsPage plugin

# render target in application page region

define [
    "when"
    "marionette"
    "underscore"
    "core/bootApp"
], (When, Marionette, _, app) ->

    count = 0

    class Normalized extends Marionette.Layout
        template: "<div/>"
        onRender: ->
            @$el.append(Marionette.getOption @, "node")

    return (options) ->

        pageViewDeferred = When.defer()

        # TODO: it must be adapted for other browsers
        normalizeView = (view) ->
            if !view.render and view instanceof HTMLElement
                view = new Normalized({node: view})
            return view

        doRenderAsPage = (facet, options, wire) ->
            view = facet.target

            view = normalizeView view

            app.renderAsPage view
            pageViewDeferred.resolve(view)

        doRenderAsColumn = (facet, options, wire) ->
            columnView = facet.target

            columnView = normalizeView columnView

            return When(pageViewDeferred.promise).then(
                (pageView) ->
                    # not ideal, but works
                    $("<div class='column#{count}'></div>").appendTo(pageView.el)
                    pageView.addRegion "column#{count}Region", ".column#{count}"
                    pageView["column#{count}Region"].show columnView
                    count++
            ).otherwise(
                # does not work as error throw
                (error) ->
                    throw "pageView does not resolved, did you assigned renderAsPage component?"
            )

        renderAsPageFacet = (resolver, facet, wire) ->
            resolver.resolve(doRenderAsPage(facet, options, wire))

        renderAsColumnFacet = (resolver, facet, wire) ->
            resolver.resolve(doRenderAsColumn(facet, options, wire))

        facets: 
            renderAsPage:
                ready: renderAsPageFacet
            renderAsColumn:
                ready: renderAsColumnFacet