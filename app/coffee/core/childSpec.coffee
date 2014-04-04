define
    $plugins: [
        "wire/debug"
        "wire/connect"
        "core/plugin/colBind"
    ]

    bindignView:
        create:
            module: "controls/testcontrol/tableControl"
        ready:
            "show": {$ref:'bindignView'}
        connect: 
            'show': 'bootApp.showView | bootApp.onTableReady | bootApp.log'

    headerView:
        create:
            module: "controls/testcontrol/tableHeaderControl"

