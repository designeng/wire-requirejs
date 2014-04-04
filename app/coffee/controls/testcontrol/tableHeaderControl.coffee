define [
    "marionette"
], (Marionette) ->
	class TableHeaderControl extends Marionette.CompositeView

		template: "tableHeaderControl"

		initialize: ->
			console.log "tableHeaderControl inited"

		setHeader: (opt) ->
			console.log "setHeader", opt

		onRender: ->
			console.log "rendered"