define [
    "marionette"
], (Marionette) ->
	class TableBodyControl extends Marionette.Layout

		template: "<tr><td>TABLE BODY</td></tr>"

		initialize: ->
			console.log "tableBodyControl inited"

		onRender: ->
			console.log " tableBodyControl rendered"