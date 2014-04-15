define
    $plugins: [
        "wire/debug"
        "wire/connect"
    ]

    injModel:
        create: "modules/modelToViewInjection/injModel"

    targetView:
        create:
            module: "modules/modelToViewInjection/targetView"

        properties:
            model: {$ref: 'injModel'}

        # just a rendering in bootApp... hack, must be redesigned - way must be improved
        ready:
            "show": {$ref:'targetView'}
        connect:
            'show': 'bootApp.showView'