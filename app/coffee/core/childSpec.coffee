define
    $plugins: [
        "wire/debug"
        "wire/connect"
        "core/plugin/colBind"
        # "core/plugin/colToColBind"
    ]

    $exports:
        tableModule: {$ref: 'controller'}

    controller:
        create:
            module: "modules/stats/tableResultController"

    collection:
        create:
            module: "controls/testcontrol/collection/tableBodyCollection"

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
        bind:
            to: {$ref: 'collection'}
            bindings:
                selector: ".tbody"
        # bind:
        #     to: {$ref: 'collection'}

    headerView:
        create:
            module: "controls/testcontrol/tableHeaderControl"

    bodyView:
        create:
            module: "controls/testcontrol/tableBodyControl"

