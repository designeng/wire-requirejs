define
    $plugins: [
        "wire/debug"
        "wire/connect"
        "core/plugin/extender"
    ]

    switchItemView:
        extend:
            originalModule: "controls/switch/item/switchItemView"
            fields:
                itemSelectedClass: "one123"
                itemFocusedClass: "two123"

    anotherItemView:
        create: 
            module: "controls/switch/item/switchItemView"
        ready:
            logProp: {}


