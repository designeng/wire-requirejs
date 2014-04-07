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
  },
  switchItemView: {
    module: "controls/switch/item/switchItemView"
  },
  switcher: {
    create: {
      module: "controls/switch/switchControl",
      args: {
        name: "switch"
      }
    },
    properties: {
      itemView: {
        $ref: 'switchItemView'
      },
      keyEvents: ["up", "down", "left", "right", "space", "tab"],
      inputOptions: ["loc_One", "loc_Two", "loc_Three"],
      itemFocusedClass: "switchItem__focused",
      itemSelectedClass: "switchItem__selected",
      showInputs: true
    },
    init: {
      createMethods: {}
    },
    listenTo: {
      globalEvents: {
        "html:click": "onHtmlClick"
      }
    },
    connect: {
      "show": 'bootApp.showView'
    },
    ready: {
      "show": {
        $ref: 'switcher'
      }
    },
    destroy: {
      triggerMethod: "close"
    }
  }
});
