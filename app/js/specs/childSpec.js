define({
  $plugins: ["wire/debug", "wire/connect", "core/plugin/colBind", "core/plugin/renderAsPage"],
  $exports: {
    tableModule: {
      $ref: 'controller'
    }
  },
  controller: {
    create: {
      module: "modules/stats/tableResultController"
    }
  },
  collection: {
    create: {
      module: "controls/testcontrol/collection/tableBodyCollection"
    }
  },
  tableView: {
    create: {
      module: "controls/testcontrol/tableControl"
    },
    properties: {
      header: {
        $ref: 'headerView'
      },
      body: {
        $ref: 'bodyView'
      }
    },
    bind: {
      to: {
        $ref: 'collection'
      },
      bindings: {
        selector: ".tbody"
      }
    },
    renderAsPage: true
  },
  headerView: {
    create: {
      module: "controls/testcontrol/tableHeaderControl"
    }
  },
  bodyView: {
    create: {
      module: "controls/testcontrol/tableBodyControl"
    }
  }
});
