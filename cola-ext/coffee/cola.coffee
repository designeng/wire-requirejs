###
@license MIT License (c) copyright B Cavalier & J Hann
###

###
wire/cola plugin

wire is part of the cujo.js family of libraries (http://cujojs.com/)

Licensed under the MIT License at:
http://www.opensource.org/licenses/mit-license.php
###
((define) ->
    define [
        'when'
        './relational/propertiesKey'
        './comparator/byProperty'
    ], (when_, propertiesKey, byProperty) ->
        initBindOptions = (incomingOptions, pluginOptions, resolver) ->
            options = undefined
            identifier = undefined
            comparator = undefined
            incomingOptions = to: incomingOptions    if resolver.isRef(incomingOptions)
            options = copyOwnProps(incomingOptions, pluginOptions)
            options.querySelector = defaultQuerySelector    unless options.querySelector
            options.querySelectorAll = defaultQuerySelectorAll    unless options.querySelectorAll
            options.on = defaultOn    unless options.on
            
            # TODO: Extend syntax for identifier and comparator
            # to allow more fields, and more complex expressions
            identifier = options.identifier
            options.identifier = (if typeof identifier is 'string' or Array.isArray(identifier) then propertiesKey(identifier) else identifier)
            comparator = options.comparator or defaultComparator
            options.comparator = (if typeof comparator is 'string' then byProperty(comparator) else comparator)
            options
        doBind = (facet, options, wire) ->
            target = facet.target
            when_ wire(initBindOptions(facet.options, options, wire.resolver)), (options) ->
                to = options.to
                throw new Error('wire/cola: "to" must be specified')    unless to
                to.addSource target, copyOwnProps(options)
                target

        
        ###
        We don't want to copy the module property from the plugin options, and
        wire adds the id property, so we need to filter that out too.
        @type {Object}
        ###
        
        ###
        Copies own properties from each src object in the arguments list
        to a new object and returns it.  Properties further to the right
        win.
        
        @return {Object} a new object with own properties from all srcs.
        ###
        copyOwnProps = -> #srcs...
            i = undefined
            len = undefined
            p = undefined
            src = undefined
            dst = undefined
            dst = {}
            i = 0
            len = arguments_.length

            while i < len
                src = arguments_[i]
                if src
                    for p of src
                        dst[p] = src[p]    if src.hasOwnProperty(p)
                i++
            dst
        defaultComparator = undefined
        defaultQuerySelector = undefined
        defaultQuerySelectorAll = undefined
        defaultOn = undefined
        excludeOptions = undefined
        defaultComparator = byProperty('id')
        defaultQuerySelector = $ref: 'dom.first!'
        defaultQuerySelectorAll = $ref: 'dom.all!'
        defaultOn = $ref: 'on!'
        excludeOptions =
            id: 1
            module: 1

        return wire$plugin: (pluginOptions) ->
            bindFacet = (resolver, facet, wire) ->
                resolver.resolve doBind(facet, options, wire)
                return
            options = undefined
            p = undefined
            options = {}
            if arguments_.length
                pluginOptions = arguments_[arguments_.length - 1]
                for p of pluginOptions
                    options[p] = pluginOptions[p]    unless p of excludeOptions
            facets:
                bind:
                    ready: bindFacet

        return

    return

# use define for AMD if available
) (if typeof define is 'function' then define else (deps, factory) ->
    module.exports = factory.apply(this, deps.map(require))
    return
)