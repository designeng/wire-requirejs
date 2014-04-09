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

    # clientFormContainer: 

    clientFormTpl:
        module: 'text!/app/templates/clientdata/template.html'

    clientEditView:
        create:
            module: "modules/clientdata/clientEditView"

        properties:
            template: {$ref: 'clientFormTpl'}

        localize: "template"

        # rendering way must be improved
        ready:
            "show": {$ref:'clientEditView'}
        connect:
            'show': 'bootApp.showView'

    # clientEditView:
    #     render:
    #         template: { module: 'text!/app/templates/clientdata/template.html' }
    #     on:
    #         submit: 'form.getValues'
    #     insert: 
    #         first: 'clientFormContainer'
        # connect: {
        #     'contactsCollection.onChange': 'reset'
        # }

    # herpers
    form: 
        module: 'cola/dom/form'