define
    $plugins: [
        "wire/debug"
        "wire/connect"
        "core/plugin/renderAsPage"
    ]

    injModel:
        create: "modules/modelToViewInjection/injModel"

    targetView:
        create:
            module: "modules/modelToViewInjection/targetView"

        properties:
            model: {$ref: 'injModel'}

        renderAsPage: true