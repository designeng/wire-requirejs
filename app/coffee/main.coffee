require [
    "wire"
    "wire!bootstrapSpec"
    "childSpec"
    "listenToSpec"
    "overridden"
], (wire, bootstrapCTX, childSpec, listenToSpec) ->

    bootstrapCTX.wire(
            listenToSpec
    ).then (childContext) ->
        console.log "resultCTX:", childContext