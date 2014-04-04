require.config({
  baseUrl: "/app/js",
  packages: [
    {
      name: "wire",
      main: "wire",
      location: "../../bower_components/wire"
    }, {
      name: "when",
      main: "when",
      location: "../../bower_components/when"
    }, {
      name: "meld",
      main: "meld",
      location: "../../bower_components/meld"
    }, {
      name: "cola",
      main: "cola",
      location: "../../bower_components/cola"
    }, {
      name: "rest",
      main: "rest",
      location: "../../bower_components/rest"
    }, {
      name: "backbone",
      main: "backbone",
      location: "../../bower_components/backbone"
    }, {
      name: "underscore",
      main: "underscore",
      location: "../../bower_components/underscore"
    }, {
      name: "marionette",
      main: "backbone.marionette",
      location: "../../bower_components/marionette/lib"
    }, {
      name: "jquery",
      main: "jquery",
      location: "../../bower_components/jquery/dist"
    }, {
      name: "text",
      main: "text",
      location: "../../bower_components/text"
    }
  ],
  shim: {
    "marionette": {
      deps: ["backbone"],
      exports: "Marionette"
    }
  },
  paths: {
    "domReady": "../../bower_components/domReady/domReady",
    "bootstrapSpec": "core/bootstrapSpec",
    "childSpec": "core/childSpec",
    "mediator": "boot/mediator",
    "context/main": "withwire/context/main",
    "withwire": "withwire/withwire",
    "oneComponent": "withwire/components/oneComponent"
  }
});

require(["wire!bootstrapSpec", "childSpec"], function(bootstrapCTX, childSpec) {
  return bootstrapCTX.wire(childSpec).then(function(childContext) {
    return console.log("resultCTX:", childContext);
  });
});
