console.time("startApp")
require [
    "wire"
    "wire!bootstrapSpec"
    # "clientDataSpec"
    # "childSpec"
    # "listenToSpec"
    # "extenderPluginSpec"
    # "sampleAppSpec"
    "modelToViewInjectionSpec"
    "overridden"
# ], (wire, bootstrapCTX, clientDataSpec, childSpec, listenToSpec, extenderPluginSpec, sampleAppSpec) ->
], (wire, bootstrapCTX, childSpec) ->
    bootstrapCTX.wire(
            childSpec
    ).then (childContext) ->
        console.timeEnd("startApp")
        console.log "resultCTX::::", childContext