define [
    "marionette"
], (Marionette) ->
	class TableControl extends Marionette.CompositeView

		template: "<table><tr><td>table</td></tr></table>"

		initialize: ->
			console.log "TableControl inited"

		show: (target) ->
			console.log "show after init", target
			return target


		onRender: ->
			console.log "rendered"