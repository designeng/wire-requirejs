define
    $plugins: [
        "wire/debug"
        "wire/connect"
        "core/plugin/colBind"
    ]

    tableView:
        create:
            module: "controls/testcontrol/tableControl"
        properties:
            header: {$ref: 'headerView'}
            body: {$ref: 'bodyView'}
        ready:
            "show": {$ref:'tableView'}
        connect: 
            'show': 'bootApp.showView'

    headerView:
        create:
            module: "controls/testcontrol/tableHeaderControl"
    bodyView:
        create:
            module: "controls/testcontrol/tableBodyControl"

