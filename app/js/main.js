console.time("startApp");

require(["wire", "wire!bootstrapSpec", "modelToViewInjectionSpec", "overridden"], function(wire, bootstrapCTX, childSpec) {
  return bootstrapCTX.wire(childSpec).then(function(childContext) {
    console.timeEnd("startApp");
    return console.log("resultCTX::::", childContext);
  });
});
