define [
    "backbone"
    "marionette"
    "meld"
    "underscore.string"
], (Backbone, Marionette, Meld, _Str) -> 

    NoItemsView = Marionette.ItemView.extend
        template: 'No options'                

    class SwitchControlView extends Marionette.CompositeView

        template: "<ul>${loc_test}</ul>"

        className: (res) ->
            # @defaultClassName("switchControl")
            return "switchControl"

        # @injected
        itemView: undefined

        emptyView: NoItemsView

        onUp: ->
            console.log "------ON UP!!!"

        initialize: ->

            @model = new Backbone.Model
                name: Marionette.getOption @, "name"

            @collection = new Backbone.Collection()

            @on "itemview:checked", @onItemClick
            @on "itemview:infocus", @onInFocus
            @on "itemview:inblur", @onInBlur

            @inFocus = false

        # @connect with app
        show: (target) ->
            console.log "show after init", target
            return target

        # createMethods: ->
        #     @_removers = []
        #     for evt in @keyEvents
        #         methodName = @_getMethodName evt

        #         if !@[methodName]
        #             @[methodName] = (e) =>
        #                 # blank funcion

        #         console.log "createMethods::::", methodName
        #         remover = Meld.after @, methodName, "afterKeyPressed"
        #         @_removers.push remover # remember all aspects here to remove in "beforeClose" view method

        onBeforeRender: -> 
            modIndex = 0

            for option in @inputOptions
                optionModel = new Backbone.Model(
                        name: option
                        index: modIndex++
                    )
                @collection.add optionModel

            if @collection.length
                @currentIndex = 0

        onRender: -> 
            @hideInputs() unless @_showInputs

            # _.each @keyEvents, (evt) => 
            #     console.log "EVENT::::---->", evt      
            #     @keyOn evt, @_bindKeyEventToMethod(@_getMethodName evt)

            if _.isNumber @_startIndex
                @chooseItem @_startIndex

        onHtmlClick: (e) ->
            if $.contains @el, e.target
                @onInsideClick()                 
            else
                @onOutClick()

        hideInputs: ->
            @children.each (item) =>
                    # input must participate in bypassing form by "tab" key pressing
                    # do not disactivate input if index = 0 - add class with "opacity", "0"
                    if item.model.get("index") == 0
                        item.input.addClass "switchItemInput__hidden"
                    else
                        # .hide means disactivation - disactivate input
                        item.input.hide()
        
        # inFocus value manipulations
        onInFocus: (index) ->
            @inFocus = true
            
        onInBlur: ->
            @inFocus = false

        onInsideClick: ->
            @inFocus = true

        onOutClick: ->
            @inFocus = false

        onItemClick: (itemview) ->
            @inFocus = true
            @currentIndex = itemview.model.get "index"            

            @chooseItem @currentIndex

        # works as after-aspect with all key handlers (see bindKeyMethods)
        afterKeyPressed: (key) ->
            console.log "KEY PRESSED", key
            if !@inFocus
                return

            if key is "space"
                @chooseItem @currentIndex

            if key is "left" or key is "up" 
                @choosePrevious()

            if key is "down" or key is "right"
                @chooseNext()

        choosePrevious: ->
            if @currentIndex > 0
                @chooseItem --@currentIndex

        chooseNext: ->
            if @currentIndex < @collection.length - 1
                @chooseItem ++@currentIndex 

        chooseItem: (index) ->
            if _.isNumber @checkedItemIndex
                @children.findByIndex(@checkedItemIndex).unCheck()

            item = @children.findByIndex index
            item.check()

            @checkedItemIndex = index

            @model.set "name", @model.get "name"
            @model.set "data", _.keys(item.model.get("name"))[0]

            return item

        onClose: ->
            _.each @keyEvents, (evt) =>
                @keyOff evt

        # _getMethodName: (string) ->
        #     return "on" + _Str.classify.call(@, string)

        # _bindKeyEventToMethod: (methodName) ->
        #     return @[methodName]
