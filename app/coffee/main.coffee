require.config

    baseUrl: "/app/js"

    packages: [
        # lib packages
        {
            name: "wire"
            main: "wire"
            location: "../../bower_components/wire"
        },
        {
            name: "when"
            main: "when"
            location: "../../bower_components/when"
        },
        {
            name: "meld"
            main: "meld"
            location: "../../bower_components/meld"
        },
        {
            name: "cola"
            main: "cola"
            location: "../../bower_components/cola"
        },
        {
            name: "rest"
            main: "rest"
            location: "../../bower_components/rest"
        },
        {
            name: "backbone"
            main: "backbone"
            location: "../../bower_components/backbone"
        },
        {
            name: "underscore"
            main: "underscore"
            location: "../../bower_components/underscore"
        },
        {
            name: "marionette"
            main: "backbone.marionette"
            location: "../../bower_components/marionette/lib"
        },        
        {
            name: "jquery"
            main: "jquery"
            location: "../../bower_components/jquery/dist"
        },        
        {
            name: "text"
            main: "text"
            location: "../../bower_components/text"
        }     
    ]

    shim:
        "marionette":
            deps: ["backbone"]
            exports: "Marionette"

    paths:
        # plugins
        "domReady": "../../bower_components/domReady/domReady"

        # bootstrap spec
        "bootstrapSpec": "core/bootstrapSpec"
        "childSpec": "core/childSpec"

        # mediator
        "mediator": "boot/mediator"

        # contexts
        "context/main" : "withwire/context/main"

        # modules
        "withwire": "withwire/withwire"
        "oneComponent": "withwire/components/oneComponent"

require [
    "wire!bootstrapSpec"
    "childSpec"
], (bootstrapCTX, childSpec) ->

    bootstrapCTX.wire(
            childSpec
    ).then (childContext) ->
        console.log "resultCTX:", childContext
        

