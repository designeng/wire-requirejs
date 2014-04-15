console.time("startApp");

require(["when", "wire", "wire!bootstrapSpec", "routerMainSpec", "modelToViewInjectionSpec", "overridden"], function(When, wire, bootstrapCTX, routerMainSpec, childSpec) {
  var app;
  app = bootstrapCTX.bootApp;
  return bootstrapCTX.wire(routerMainSpec).then(function(childContext) {
    console.timeEnd("startApp");
    return console.log("resultCTX::::", childContext);
  });
});
