require(["wire", "wire!bootstrapSpec", "childSpec", "listenToSpec", "extenderPluginSpec", "clientDataSpec", "sampleAppSpec", "overridden"], function(wire, bootstrapCTX, childSpec, listenToSpec, extenderPluginSpec, clientDataSpec, sampleAppSpec) {
  return bootstrapCTX.wire(sampleAppSpec).then(function(childContext) {
    return console.log("resultCTX::::", childContext);
  });
});
