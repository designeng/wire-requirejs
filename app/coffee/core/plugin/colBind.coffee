define [
    "marionette"
    "when"
    "backbone.collectionbinder"
], (Marionette, When) ->

    return (options) ->

        # bindToCollection = (resolver, componentDefinition, wire) ->
        #     createRouter(componentDefinition, wire).then (tempRouter) ->
        #         routeBinding tempRouter, componentDefinition, wire
        #         resolver.resolve(tempRouter)
        #     , (error) ->
        #         console.error error.stack

        doBind = (facet, options, wire) ->
            target = facet.target

            # it was
            # return When(wire(initBindOptions(facet.options, options, wire.resolver)),

            # resolver.isRef: https://github.com/cujojs/wire/blob/master/lib/resolver.js

            return When(wire({options: facet.options}),
                    (options) ->
                        # to = options.to
                        # throw new Error('wire/cola: "to" must be specified') unless !to

                        # addSource must be collection method
                        # to.addSource(target, copyOwnProps(options));

                        # options.options.to must be refactored (look at cola!)

                        to = options.options.to
                        bindings = options.options.bindings

                        throw new Error('plugin/colBind: "to" must be specified') unless to
                        throw new Error('plugin/colBind: "bindings" must be specified') unless bindings

                        console.log "TARGET", target, options.options.to
                        console.log "bindings", options.options.bindings

                        rowHtml = "<tr><td data-name='one'></td><td data-name='two'></td></tr>"
                        elManagerFactory = new Backbone.CollectionBinder.ElManagerFactory(rowHtml, "data-name")
                        collectionBinder = new Backbone.CollectionBinder(elManagerFactory, {autoSort: true})
                        
                        selector = bindings.selector
                        element = target.$el.find(selector)

                        collectionBinder.bind(to, element)

                        console.log ">>>>>", target.$el.find(".tbody")
                        
                        return target
                )

        bindFacet = (resolver, facet, wire) ->
            resolver.resolve(doBind(facet, options, wire))

        # bindToCollection = (resolver, proxy, wire) ->
        #     # console.log ">>>>>>>>>>>>>>>>>", resolver.isRef proxy
        #     console.log ">>>>>>>>>>>>>>>>>", resolver
        #     resolver.resolve()

        context:
            ready: (resolver, wire) ->
                console.log "plugin READY -----"
                resolver.resolve()

        # TODO: We need to decide what to do with a route is detroyed
        destroy: {}

        facets: 
            bind: 
                ready: bindFacet
