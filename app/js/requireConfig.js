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
      name: "listenTo",
      main: "listenTo",
      location: "../../bower_components/listenTo"
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
    "domReady": "../../bower_components/domReady/domReady",
    "bootstrapSpec": "specs/bootstrapSpec",
    "childSpec": "specs/childSpec",
    "listenToSpec": "specs/listenToSpec",
    "extenderPluginSpec": "specs/extenderPluginSpec",
    "clientDataSpec": "modules/clientdata/clientDataSpec",
    "mediator": "boot/mediator",
    "context/main": "withwire/context/main",
    "oneComponent": "withwire/components/oneComponent"
  }
});
