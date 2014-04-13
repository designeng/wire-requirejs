require [
    "wire"
    "wire!bootstrapSpec"
    "childSpec"
    "listenToSpec"
    "extenderPluginSpec"
    "clientDataSpec"
    "sampleAppSpec"
    "overridden"
], (wire, bootstrapCTX, childSpec, listenToSpec, extenderPluginSpec, clientDataSpec, sampleAppSpec) ->

    bootstrapCTX.wire(
            sampleAppSpec
            # clientDataSpec
            # listenToSpec
            # extenderPluginSpec
    ).then (childContext) ->
        console.log "resultCTX::::", childContext