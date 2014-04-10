define [
    "marionette"
], (Marionette) ->
    class ClientEditView extends Marionette.Layout

        # @injected
        template: undefined

        # @injected
        formSelector: undefined

        events:
            "click .save": "onClick"       

        initialize: ->
            console.log "ClientEditView inited"

        # hack, must be redesigned
        show: (target) ->
            return target

        log: (prop) ->
            console.log "PROP:", @[prop]

        onClick: (e) ->
            @getValues()
            return false

        getValues: ->
            form = @$el.find(@formSelector)[0]
            res = @_form.getValues(form)
            console.log "RESULT:::", res