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
      location: "../../cola"
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
      name: "underscore.string",
      main: "underscore.string",
      location: "../../bower_components/underscore.string/lib"
    }, {
      name: "marionette",
      main: "backbone.marionette",
      location: "../../bower_components/marionette/lib"
    }, {
      name: "backbone.modelbinder",
      main: "Backbone.ModelBinder",
      location: "../../bower_components/Backbone.ModelBinder"
    }, {
      name: "backbone.collectionbinder",
      main: "Backbone.CollectionBinder",
      location: "../../bower_components/Backbone.ModelBinder"
    }, {
      name: "mousetrap",
      main: "mousetrap",
      location: "../../bower_components/mousetrap"
    }, {
      name: "jquery",
      main: "jquery",
      location: "../../bower_components/jquery/dist"
    }, {
      name: "text",
      main: "text",
      location: "../../bower_components/text"
    }, {
      name: "i18n",
      main: "i18n",
      location: "../../bower_components/requirejs-i18n"
    }, {
      name: "listenTo",
      main: "listenTo",
      location: "../../bower_components/listenTo"
    }, {
      name: "css",
      main: "css",
      location: "../../bower_components/require-css"
    }, {
      name: "domReady",
      main: "domReady",
      location: "../../bower_components/requirejs-domready"
    }
  ],
  shim: {
    "marionette": {
      deps: ["backbone"],
      exports: "Marionette"
    },
    "backbone.collectionbinder": {
      deps: ["backbone.modelbinder"]
    },
    backbone: {
      deps: ["underscore", "jquery"]
    },
    "underscore.string": {
      deps: ["underscore"]
    }
  },
  paths: {
    "bootstrapSpec": "specs/bootstrapSpec",
    "childSpec": "specs/childSpec",
    "listenToSpec": "specs/listenToSpec",
    "extenderPluginSpec": "specs/extenderPluginSpec",
    "clientDataSpec": "modules/clientdata/clientDataSpec",
    "sampleAppSpec": "sample-app/main",
    "mediator": "boot/mediator",
    "context/main": "withwire/context/main",
    "oneComponent": "withwire/components/oneComponent"
  },
  locale: "ru"
});

require(["wire", "wire!bootstrapSpec", "childSpec", "listenToSpec", "extenderPluginSpec", "clientDataSpec", "sampleAppSpec", "overridden"], function(wire, bootstrapCTX, childSpec, listenToSpec, extenderPluginSpec, clientDataSpec, sampleAppSpec) {
  return bootstrapCTX.wire(sampleAppSpec).then(function(childContext) {
    return console.log("resultCTX::::", childContext);
  });
});
