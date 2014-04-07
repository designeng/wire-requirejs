define({
  $plugins: ["wire/debug", "wire/connect", "listenTo"],
  globalEvents: {
    create: {
      module: "mixins/globalEvents"
    }
  },
  targetToMixin: {
    create: {
      module: "controls/testmixins/targetToMixin"
    },
    listenTo: {
      globalEvents: {
        "html:click": "onHtmlClick"
      }
    }
  }
});
