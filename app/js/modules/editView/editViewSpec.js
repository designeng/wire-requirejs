define({
  $plugins: ['wire/dom', 'wire/dom/render', 'wire/on', "core/plugin/renderAsPage", 'wire/debug'],
  editView: {
    render: {
      template: {
        module: 'text!sample-app/edit/template.html'
      },
      css: {
        module: 'css!sample-app/edit/structure.css'
      }
    },
    renderAsPage: true
  }
});
