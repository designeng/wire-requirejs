# routerMainSpec
define
    $plugins: [
        "wire/debug"
        "core/plugin/bbRouter"
    ]

    appRouter:
        bbRouter: 
            routes:
                "main"  : "childSpec"
                "new"   : "sampleAppSpec"
                "else"  : "modelToViewInjectionSpec"
        # ready:
        #     'connectApp': "test"