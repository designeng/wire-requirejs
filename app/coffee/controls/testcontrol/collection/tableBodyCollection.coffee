define [
    "backbone"
], (Backbone) ->
	class TableBodyCollection extends Backbone.Collection

		initialize: ->
			items = [
				{one: "ONE", two: "TWO"}
				{one: "ONE1", two: "TWO1"}
				{one: "ONE2", two: "TWO2"}
			]
			@.add(items)

