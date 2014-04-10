define [
    "marionette"
    "when"
    "Bacon"
], (Marionette, When, Bacon) ->

    init = (Bacon, $) ->
        nonEmpty = (x) -> x.length > 0
        assertArrayOrJQueryObject = (x) ->
            unless x instanceof jQuery or x instanceof Array
                throw new Error('Value must be either a jQuery object or an Array of jQuery objects')
        asJQueryObject = (x) ->
            if x instanceof jQuery then x
            else
                obj = $()
                obj = obj.add(element) for element in x when element instanceof jQuery
                obj
        _ = {
        indexOf: if Array::indexOf
            (xs, x) -> xs.indexOf(x)
        else
            (xs, x) ->
                for y, i in xs
                    return i if x == y
                -1
        }


        $.fn.asEventStream = Bacon.$.asEventStream

        # Input element bindings
        Bacon.$.textFieldValue = (element, initValue) ->
            get = -> element.val() || ""
            autofillPoller = ->
                Bacon.interval(50).take(10).map(get).filter(nonEmpty).take 1
            events = element.asEventStream("keyup input")
                .merge(element.asEventStream("cut paste").delay(1))
                .merge(autofillPoller())

            Bacon.Binding {
                initValue,
                get,
                events,
                set: (value) -> element.val(value)
            }

        Bacon.$.checkBoxValue = (element, initValue) ->
            Bacon.Binding {
                initValue,
                get: -> element.prop("checked")||false,
                events: element.asEventStream("change"),
                set: (value) -> element.prop "checked", value
            }

        Bacon.$.selectValue = (element, initValue) ->
            Bacon.Binding {
                initValue,
                get: -> element.val(),
                events: element.asEventStream("change"),
                set: (value) -> element.val value
            }

        Bacon.$.radioGroupValue = (radios, initValue) ->
            assertArrayOrJQueryObject(radios)
            radios = asJQueryObject(radios)
            Bacon.Binding {
                initValue,
                get: -> radios.filter(":checked").first().val(),
                events: radios.asEventStream("change"),
                set: (value) ->
                    radios.each (i, elem) ->
                        $(elem).prop "checked", elem.value is value
            }

        Bacon.$.checkBoxGroupValue = (checkBoxes, initValue) ->
            assertArrayOrJQueryObject(checkBoxes)
            checkBoxes = asJQueryObject(checkBoxes)
            Bacon.Binding {
                initValue,
                get: ->
                    checkBoxes.filter(":checked").map((i, elem) -> $(elem).val()).toArray()
                events: checkBoxes.asEventStream("change"),
                set: (value) ->
                    checkBoxes.each (i, elem) ->
                        $(elem).prop "checked", _.indexOf(value, $(elem).val()) >= 0
            }

        # AJAX
        Bacon.$.ajax = (params, abort) -> Bacon.fromPromise $.ajax(params), abort
        Bacon.$.ajaxGet = (url, data, dataType, abort) -> Bacon.$.ajax({url, dataType, data}, abort)
        Bacon.$.ajaxGetJSON = (url, data, abort) -> Bacon.$.ajax({url, dataType: "json", data}, abort)
        Bacon.$.ajaxPost = (url, data, dataType, abort) -> Bacon.$.ajax({url, dataType, data, type: "POST"}, abort)
        Bacon.$.ajaxGetScript = (url, abort) -> Bacon.$.ajax({url, dataType: "script"}, abort)
        Bacon.$.lazyAjax = (params) -> Bacon.once(params).flatMap(Bacon.$.ajax)
        Bacon.Observable::ajax = -> @flatMapLatest Bacon.$.ajax

        # jQuery Deferred
        Bacon.Observable::toDeferred = ->
            value = undefined
            dfd = $.Deferred()
            @take(1).endOnError().subscribe((evt) ->
                if evt.hasValue()
                    value = evt.value()
                    dfd.notify(value)
                else if evt.isError()
                    dfd.reject(evt.error)
                else if evt.isEnd()
                    dfd.resolve(value)
                )
            dfd

        # jQuery DOM Events

        eventNames = [
            "keydown", "keyup", "keypress",
            "click", "dblclick", "mousedown", "mouseup",
            "mouseenter", "mouseleave", "mousemove", "mouseout", "mouseover",
            "resize", "scroll", "select", "change",
            "submit",
            "blur", "focus", "focusin", "focusout",
            "load", "unload" ]
        events = {}

        for e in eventNames 
            do (e) ->
                events[e + 'E'] = (args...) -> @asEventStream e, args...

        $.fn.extend events

        # jQuery Effects

        effectNames = [
            "animate", "show", "hide", "toggle",
            "fadeIn", "fadeOut", "fadeTo", "fadeToggle",
            "slideDown", "slideUp", "slideToggle" ]
        effects = {}

        for e in effectNames 
            do (e) ->
                effects[e + 'E'] = (args...) -> Bacon.fromPromise @[e](args...).promise()

        $.fn.extend effects

        Bacon.$

    if module?
        Bacon = require("baconjs")
        $ = require("jquery")
        module.exports = init(Bacon, BaconModel, $)
    else
        if typeof define == "function" and define.amd
            define ["bacon", "jquery"], init
        else
            init(this.Bacon, this.$)

    # end Backon.jquery

    return (options) ->

        doBind = (facet, options, wire) ->
            target = facet.target

            # resolver.isRef: https://github.com/cujojs/wire/blob/master/lib/resolver.js

            return When(wire({options: facet.options}),
                    (options) ->
                        # options.options.to must be refactored (look at cola!)

                        to = options.options.to
                        bindings = options.options.bindings
                        selector = options.options.selector

                        throw new Error('plugin/colBind: "to" must be specified') unless to
                        throw new Error('plugin/colBind: "bindings" must be specified') unless bindings
                         
                        element = target.$el.find(selector)
                        element.asEventStream()

                        collectionBinder.bind(to, element)
                        
                        return target
                )

        bindFacet = (resolver, facet, wire) ->
            resolver.resolve(doBind(facet, options, wire))

        context:
            ready: (resolver, wire) ->
                resolver.resolve()

        destroy: {}

        facets: 
            bind: 
                "ready:before" : bindFacet
