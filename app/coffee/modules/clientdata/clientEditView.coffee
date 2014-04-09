define [
    "marionette"
], (Marionette) ->
    class ClientEditView extends Marionette.Layout

        # @injected
        template: null

        initialize: ->
            console.log "ClientEditView inited"

        show: (target) ->
            console.log "TEMPLATE", @template
            return target