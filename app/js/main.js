require(["wire", "wire!bootstrapSpec", "childSpec", "listenToSpec", "extenderPluginSpec", "clientDataSpec", "overridden"], function(wire, bootstrapCTX, childSpec, listenToSpec, extenderPluginSpec, clientDataSpec) {
  return bootstrapCTX.wire(clientDataSpec).then(function(childContext) {
    return console.log("resultCTX:", childContext);
  });
});
