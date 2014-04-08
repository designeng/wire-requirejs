define [
	"underscore"
    "when"
], (_, When) ->

    return (options) ->

        doLocalize = (facet, options, wire) ->
            target = facet.target
            parseTemplateRx = /\$\{([^}]*)\}/g

            return When(wire({options: facet.options}),
                    (options) ->
                        whatToLocalize = _.result target, facet.options
                        res = whatToLocalize.replace(parseTemplateRx, "localized!")

                        target[facet.options] = res
                        return target
                )

        localizeFacet = (resolver, facet, wire) ->
            resolver.resolve(doLocalize(facet, options, wire))

        context:
            "ready:before": (resolver, wire) ->
                resolver.resolve()

        facets: 
            localize: 
                "ready:before": localizeFacet
