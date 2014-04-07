define
    $plugins: [
        "wire/debug"
        "wire/connect"
        "listenTo"
    ]

    globalEvents:
        create:
            module: "mixins/globalEvents"

    targetToMixin:
        create: 
            module: "controls/testmixins/targetToMixin"
        listenTo:
            globalEvents:
                "html:click": "onHtmlClick"

    switchItemView:
        module: "controls/switch/item/switchItemView"
            
        # ready:
        #     "log": "test"


    switcher:
        create: 
            module: "controls/switch/switchControl"
            args:
                name: "switch"
        properties:
            # defaultClassName: "mixins/defaultClassName"
            itemView: {$ref: 'switchItemView'}
            keyEvents: ["up", "down", "left", "right", "space", "tab"]
            inputOptions: ["loc_One", "loc_Two", "loc_Three"]  # @prepareLocalized(@_inputOptions, "object") - must be in outer service - prepare template before injecting

            itemFocusedClass: "switchItem__focused"
            itemSelectedClass: "switchItem__selected"
            
            showInputs: true
            # startIndex:

        # mixin: [
        #     {$ref: "mixins/defaultClassName"}
        # ]

        init:
            createMethods: {}

        listenTo:
            globalEvents:
                "html:click": "onHtmlClick"

        connect: 
            "show": 'bootApp.showView'

        ready:
            "show": {$ref:'switcher'}

        destroy:
            triggerMethod: "close"


