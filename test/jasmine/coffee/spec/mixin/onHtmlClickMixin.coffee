define [
    "wire"
    "marionette"
], (wire, Marionette) ->

    # ------------- global events --------------------------
    define "globalEvents", [
        "jquery"
        "underscore"
        "backbone"
    ], ($, _, Backbone) ->

        class GlobalEvents

            htmlEvents: ['html:click']
            windowsEvents: ['window:resize']

            constructor: ->
                @bindGlobalEvents()

            bindGlobalEvents: ->
                $(window).on 'resize', =>                               # window resize event
                    sEvents = @joinEvent('windowsEvents')
                    @trigger sEvents, {
                        width: $(window).width()
                        height: $(window).height()
                    }

                $("html").on 'click', (e) =>                            # html click event
                    sEvents = @joinEvent('htmlEvents')
                    @trigger(sEvents, e)

            addHtmlEvent: (eventName) ->                                # for add custom events
                @htmlEvents.push(eventName)

            removeHtmlEvent: (eventName) ->                             # for remove custom events
                @htmlEvents = _.without(@htmlEvents, eventName)

            joinEvent: (eventGroup) ->
                return @[eventGroup].join(' ')

        GlobalEvents = _.extend GlobalEvents, Backbone.Events

        return globalEvents = new GlobalEvents() unless globalEvents?   # should be singleton


    # ------------- target layout --------------------------
    define "targetToMixin", [
        "marionette"
    ], (Marionette) ->
        class TargetToMixin extends Marionette.Controller
            template: ""

            initialize: ->
                console.log "targetToMixin"
                @onHtmlClick()

            onHtmlClick: ->
                console.log "onHtmlClick----"


    # ------------- rootSpec --------------------------
    rootSpec = 
        globalEvents:          
            module: "globalEvents"
        targetToMixin:
            create: 
                module: "targetToMixin"
            listenTo:
                globalEvents:
                    "html:click": "onHtmlClick"

            # mixin: [
            #     { $ref: 'globalEvents' }
            # ]

        $plugins:[
            "wire/debug"
            "listenTo"
        ]


    # ------------- test suites --------------------------
    describe "After wire rootSpec context created", ->

        beforeEach (done) ->
            wire(rootSpec).then (@ctx) =>
                done()
            .otherwise (err) ->
                console.log "ERROR", err

        it "targetToMixin", (done) ->

            expect(@ctx.targetToMixin).toBeDefined()
            done()
        # it "filter", (done) ->
        #     console.log @ctx.filter
        #     # expect(@ctx.filter.bindKeysOn).toBeDefined()
        #     done()
        # it "table", (done) ->
        #     expect(@ctx.table).toBeDefined()
        #     done()




