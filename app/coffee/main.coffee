console.time("startApp")
require [
    "when"
    "wire"
    "wire!bootstrapSpec"
    "routerMainSpec"
    # "clientDataSpec"
    # "childSpec"
    # "listenToSpec"
    # "extenderPluginSpec"
    # "sampleAppSpec"
    "modelToViewInjectionSpec"
    "overridden"
], (When, wire, bootstrapCTX, routerMainSpec, childSpec) ->
    app = bootstrapCTX.bootApp

    bootstrapCTX.wire(
            routerMainSpec
    ).then (childContext) ->
        console.timeEnd("startApp")
        console.log "resultCTX::::", childContext