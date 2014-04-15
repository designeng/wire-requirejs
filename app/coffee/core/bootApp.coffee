define [
    "appinstance"
    "core/modules/root/rootModule"
], (App, rootModule) ->

    App.addInitializer (options) ->
        console.log "App.addInitializer", options
        if !options.regionSelector
            throw new Error "Application region not specified!"

        App.addRegions 
            root: options.regionSelector
            tableRegion: "#table"

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