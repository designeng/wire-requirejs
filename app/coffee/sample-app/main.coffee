define # Wire spec

    $plugins: [
        'wire/dom'
        'wire/dom/render'
        'wire/on'
        'wire/connect'
        'cola'
        "core/plugin/renderAsPage"
        'wire/debug'
    ]

    contactsCollection:
        wire: 'sample-app/collection/spec'

    # test formModel binding
    formModel:
        wire: 'sample-app/test-model/spec'

    controller:
        create: 'sample-app/controller'
        properties:
            _form:
                $ref: 'editView'

            _updateForm:
                $ref: 'form.setValues'

        connect:
            'contactsCollection.onEdit': 'editContact'

    editView:
        render:
            template:
                module: 'text!sample-app/edit/template.html'
            css: 
                module: 'css!sample-app/edit/structure.css'

        on:
            submit: 'form.getValues | contactsCollection.update'

        connect:
            'contactsCollection.onChange': 'reset'

        insert:
            after: 'listView'

        renderAsColumn: true

    listView:
        render:
            template:
                module: 'text!sample-app/list/template.html'
            css:
                module: 'css!sample-app/list/structure.css'

        on:
            'click:.contact': 'contactsCollection.edit'
            'click:.remove': 'contactsCollection.remove'

        bind:
            to:
                $ref: 'contactsCollection'
                # $ref: 'formModel'

            comparator:
                module: 'sample-app/list/compareByLastFirst'

            bindings:
                firstName: '.first-name'
                lastName: '.last-name'

        renderAsPage: true

    form:
        module: 'cola/dom/form'