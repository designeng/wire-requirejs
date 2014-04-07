require(["wire", "wire!bootstrapSpec", "childSpec", "listenToSpec", "overridden"], function(wire, bootstrapCTX, childSpec, listenToSpec) {
  return bootstrapCTX.wire(listenToSpec).then(function(childContext) {
    return console.log("resultCTX:", childContext);
  });
});
