require(["wire", "wire!bootstrapSpec", "childSpec", "overridden"], function(wire, bootstrapCTX, childSpec) {
  return bootstrapCTX.wire(childSpec).then(function(childContext) {
    return console.log("resultCTX:", childContext);
  });
});
