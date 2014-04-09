require [
    "wire"
    "wire!bootstrapSpec"
    "childSpec"
    "listenToSpec"
    "extenderPluginSpec"
    "clientDataSpec"
    "overridden"
], (wire, bootstrapCTX, childSpec, listenToSpec, extenderPluginSpec, clientDataSpec) ->

    bootstrapCTX.wire(
            clientDataSpec
            # listenToSpec
            # extenderPluginSpec
    ).then (childContext) ->
        console.log "resultCTX:", childContext