require [
    "wire"
    "wire!bootstrapSpec"
    "childSpec"
    "overridden"
], (wire, bootstrapCTX, childSpec) ->

    bootstrapCTX.wire(
            childSpec
    ).then (childContext) ->
        console.log "resultCTX:", childContext