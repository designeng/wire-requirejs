require [
    "wire"
    "wire!bootstrapSpec"
    "childSpec"
    "listenToSpec"
    "extenderPluginSpec"
    "overridden"
], (wire, bootstrapCTX, childSpec, listenToSpec, extenderPluginSpec) ->

    bootstrapCTX.wire(
            listenToSpec
            # extenderPluginSpec
    ).then (childContext) ->
        console.log "resultCTX:", childContext