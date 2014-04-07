require(["wire", "wire!bootstrapSpec", "childSpec", "listenToSpec", "extenderPluginSpec", "overridden"], function(wire, bootstrapCTX, childSpec, listenToSpec, extenderPluginSpec) {
  return bootstrapCTX.wire(extenderPluginSpec).then(function(childContext) {
    return console.log("resultCTX:", childContext);
  });
});
