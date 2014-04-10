define
    $plugins: [
        "wire/debug"
        "wire/dom/render"
        "wire/on"
        "wire/connect"
        "wire/aop"
        "cola"
        "core/plugin/localizer"
    ]

    clientFormTpl:
        module: 'text!/app/templates/clientdata/template.html'

    clientEditView:
        create:
            module: "modules/clientdata/clientEditView"

        properties:
            template: {$ref: 'clientFormTpl'}
            formSelector: ".edit-client-data-view"
            _form: {$ref: 'form'}

        localize: "template"

        # just a rendering in bootApp... hack, must be redesigned - way must be improved
        ready:
            "show": {$ref:'clientEditView'}
            "log" : "_form"
            "getValues": {}
        connect:
            'show': 'bootApp.showView'

    # herpers
    form: 
        module: 'cola/dom/form'