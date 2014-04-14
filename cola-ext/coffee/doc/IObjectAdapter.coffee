###
MIT License (c) copyright B Cavalier & J Hann
###

###
Creates a cola adapter for interacting with a single object.
@constructor
@param object {Object}
###
IObjectAdapter = (object) ->
IObjectAdapter:: =
    
    ###
    Gets the options information that
    were provided to the adapter.
    @returns {Object}
    ###
    getOptions: ->

    
    ###
    Signals that one or more of the properties has changed.
    @param item {Object} the newly updated item
    ###
    update: (item) ->


###
Tests whether the given object is a candidate to be handled by
this adapter.
@param obj
@returns {Boolean}
###
IObjectAdapter.canHandle = (obj) ->