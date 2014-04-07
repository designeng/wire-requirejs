define [
    "appinstance"
    "core/modules/root/rootModule"
], (App, rootModule) ->

    # createRegionInSelector = (el, id) ->
    #     $(el).append("<div id=#{id} />")
    #     r = new Marionette.Region
    #         el: "##{id}"
    #     return r

    App.addInitializer (options) ->
        console.log "App.addInitializer", options
        if !options.regionSelector
            throw new Error "Application region not specified!"

        App.addRegions 
            root: options.regionSelector
            tableRegion: "#table"

        console.log "App.tableRegion", App.tableRegion

        # tableRegion = createRegionInSelector App.getRegionManager().get("root").el, "#table"

        # console.log "tableRegion", tableRegion

        # rootModule.start options

    App.getRegionManager = () ->
        @_regionManager

    App.show = (region, view) ->
        region.show view

    App.showView = (view) ->
        @.tableRegion.show view
        return view

    App.log = (msg) ->
        console.log "LOG"


    return App