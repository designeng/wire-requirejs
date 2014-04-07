define [
    "underscore"
    "when"
], (_, When) ->

    return (options) ->

        extendProto = (componentDefinition, wire) ->

            # Did user supply a new routerclass (instead of Backbone default)
            When.promise (resolve) ->
                if !componentDefinition.options.fields
                    throw "no fields option specified"

                if componentDefinition.options.originalModule
                    wire.loadModule(componentDefinition.options.originalModule).then (Module) ->

                        _keys = _.keys componentDefinition.options.fields
                        _values = _.values componentDefinition.options.fields

                        class Extended extends Module
                            # no fields yet

                        i = 0
                        for key in _keys
                            Extended::[key] = _values[i]
                            i++

                        resolve Extended
                    , (error) ->
                        console.error error
                else
                    throw "no originalModule option specified"

        injectProperties = (resolver, componentDefinition, wire) ->
            extendProto(componentDefinition, wire).then (extended) ->
                resolver.resolve(extended)
            , (error) ->
                console.error error.stack

        context:
            ready: (resolver, wire) ->
                resolver.resolve()

        factories: 
            extend: injectProperties
