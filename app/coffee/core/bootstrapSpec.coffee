define
    $plugins: [
        # "wire/debug"
    ]

    bootApp:
        module: "core/bootApp"
        ready: 
            start: {regionSelector: "#application"}




    # appRegion:
    #     create: "core/appRegion"

    # routeMap:
    #     module: "core/modules/root/routeMap"

    # routeProcessor:
    #     create: 
    #         module: "core/modules/root/routeProcessor"
    #         properties:
    #             routeMap: {$ref: 'routeMap'}