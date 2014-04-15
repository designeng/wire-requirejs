define({
  $plugins: ["wire/debug", "wire/connect"],
  injModel: {
    create: "modules/modelToViewInjection/injModel"
  },
  targetView: {
    create: {
      module: "modules/modelToViewInjection/targetView"
    },
    properties: {
      model: {
        $ref: 'injModel'
      }
    },
    ready: {
      "show": {
        $ref: 'targetView'
      }
    },
    connect: {
      'show': 'bootApp.showView'
    }
  }
});
