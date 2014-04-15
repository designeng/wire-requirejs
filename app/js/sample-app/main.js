define({
  root: {
    $ref: 'dom.first!#sample-app'
  },
  contactsCollection: {
    wire: 'sample-app/collection/spec'
  },
  formModel: {
    wire: 'sample-app/test-model/spec'
  },
  controller: {
    create: 'sample-app/controller',
    properties: {
      _form: {
        $ref: 'editView'
      },
      _updateForm: {
        $ref: 'form.setValues'
      }
    },
    connect: {
      'contactsCollection.onEdit': 'editContact'
    }
  },
  editView: {
    render: {
      template: {
        module: 'text!sample-app/edit/template.html'
      },
      css: {
        module: 'css!sample-app/edit/structure.css'
      }
    },
    insert: {
      after: 'listView'
    },
    on: {
      submit: 'form.getValues | contactsCollection.update'
    },
    connect: {
      'contactsCollection.onChange': 'reset'
    }
  },
  listView: {
    render: {
      template: {
        module: 'text!sample-app/list/template.html'
      },
      css: {
        module: 'css!sample-app/list/structure.css'
      }
    },
    insert: {
      first: {
        $ref: 'dom.first!.contacts-view-container',
        at: 'root'
      }
    },
    on: {
      'click:.contact': 'contactsCollection.edit',
      'click:.remove': 'contactsCollection.remove'
    },
    bind: {
      to: {
        $ref: 'contactsCollection'
      },
      comparator: {
        module: 'sample-app/list/compareByLastFirst'
      },
      bindings: {
        firstName: '.first-name',
        lastName: '.last-name'
      }
    }
  },
  form: {
    module: 'cola/dom/form'
  },
  $plugins: ['wire/dom', 'wire/dom/render', 'wire/on', 'wire/connect', 'cola']
});
