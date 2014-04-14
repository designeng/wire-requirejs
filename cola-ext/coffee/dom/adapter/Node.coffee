###
MIT License (c) copyright B Cavalier & J Hann
###
((define) ->
    define (require) ->
        
        ###
        Creates a cola adapter for interacting with dom nodes.  Be sure to
        unwatch any watches to prevent memory leaks in Internet Explorer 6-8.
        @constructor
        @param rootNode {Node}
        @param options {Object}
        ###
        NodeAdapter = (rootNode, options) ->
            @_rootNode = rootNode
            
            # set options
            options.bindings = guessBindingsFromDom(@_rootNode, options)
            @_options = options
            @_handlers = {}
            @_createItemToDomHandlers options.bindings
            return
        
        ###
        Tests whether the given object is a candidate to be handled by
        this adapter. Returns true if this is a DOMNode (or looks like one).
        @param obj
        @returns {Boolean}
        ###
        
        # crude test if an object is a node.
        guessBindingsFromDom = (rootNode, options) ->
            nodeFinder = undefined
            nodes = undefined
            bindings = undefined
            bindings = options.bindings or {}
            nodeFinder = options.nodeFinder or options.querySelectorAll or options.querySelector
            nodes = nodeFinder('[name],[data-cola-binding]', rootNode)
            if nodes
                Array::forEach.call nodes, (n) ->
                    name = undefined
                    attr = undefined
                    attr = (if n.name then 'name' else 'data-cola-binding')
                    name = guess.getNodePropOrAttr(n, attr)
                    bindings[name] = '[' + attr + '="' + name + '"]'    if name and (name of bindings)
                    return

            bindings
        'use strict'
        bindingHandler = undefined
        guess = undefined
        bindingHandler = require('../bindingHandler')
        guess = require('../guess')
        NodeAdapter:: =
            getOptions: ->
                @_options

            set: (item) ->
                @_item = item
                @_itemToDom item, @_handlers
                return

            update: (item) ->
                @_item = item
                @_itemToDom item, item
                return

            destroy: ->
                @_handlers.forEach (handler) ->
                    handler.unlisten()    if handler.unlisten
                    return

                return

            properties: (lambda) ->
                lambda @_item
                return

            _itemToDom: (item, hash) ->
                p = undefined
                handler = undefined
                for p of hash
                    handler = @_handlers[p]
                    handler item    if handler
                return

            _createItemToDomHandlers: (bindings) ->
                creator = undefined
                creator = bindingHandler(@_rootNode, @_options)
                Object.keys(bindings).forEach ((b) ->
                    @_handlers[b] = creator(bindings[b], b)
                    return
                ), this
                return

        NodeAdapter.canHandle = (obj) ->
            obj and obj.tagName and obj.getAttribute and obj.setAttribute

        return NodeAdapter
        return

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)