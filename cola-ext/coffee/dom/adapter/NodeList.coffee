((define) ->
    define (require) ->
        
        ###
        Manages a collection of dom trees that are synced with a data
        collection.
        @constructor
        @param rootNode {Node} node to serve as a template for items
        in the collection / list.
        @param {object} options
        @param options.comparator {Function} comparator function to use for
        ordering nodes
        @param [options.containerNode] {Node} optional parent to all itemNodes. If
        omitted, the parent of rootNode is assumed to be containerNode.
        @param [options.querySelector] {Function} DOM query function
        @param [options.itemTemplateSelector] {String}
        @param [options.idAttribute] {String}
        @param [options.containerAttribute] {String}
        ###
        NodeListAdapter = (rootNode, options) ->
            container = undefined
            self = undefined
            options = {}    unless options
            @_options = options
            @comparator = options.comparator
            @identifier = options.identifier
            @_rootNode = rootNode
            
            # 1. find templateNode
            @_templateNode = findTemplateNode(rootNode, options)
            
            # 2. get containerNode
            # TODO: should we get the container node just-in-time?
            container = options.containerNode or @_templateNode.parentNode
            throw new Error('No container node found for NodeListAdapter.')    unless container
            @_containerNode = container
            @_initTemplateNode()
            
            # keep track of itemCount, so we can set the cola-list-XXX state
            @_itemCount = undef
            @_checkBoundState()
            self = this
            
            # list of sorted data items, nodes, and unwatch functions
            @_itemData = new SortedMap((item) ->
                self.identifier item
            , (a, b) ->
                self.comparator a, b
            )
            @_itemsById = {}
            return
        
        # create adapter
        
        # add to map
        
        # figure out where to insert into dom
        
        # insert
        
        # grab node we're about to remove
        
        # remove item
        
        # remove from dom
        
        # using feature sniffing to detect if this is an event object
        # TODO: use instanceof HTMLElement where supported
        # not comments or text nodes
        
        # test for an event or an element (duck-typing by using
        # the same features we're sniffing below helps kill two birds...)
        
        # start at node and work up
        
        # what is this thing?
        
        # try this.get in case thing is an event or node
        # otherwise, assume it's a data item
        
        # determine if this data item is ours
        
        ###
        Compares two data items.  Works just like the comparator function
        for Array.prototype.sort. This comparator is used to sort the
        items in the list.
        This property should be injected.  If not supplied, the list
        will rely on one assigned by cola.
        @param a {Object}
        @param b {Object}
        @returns {Number} -1, 0, 1
        ###
        
        # remove from document
        
        # remove any styling to hide template node (ideally, devs
        # would use a css class for this, but whatevs)
        # css class: .cola-list-unbound .my-template-node { display: none }
        
        # remove id because we're going to duplicate
        
        # create NodeAdapter
        
        # label node for quick identification from events
        
        # override update() method to call back
        
        # update node(s) in NodeAdapter
        
        # cascade to us if we didn't initiate update()
        
        # Firefox cries when you try to insert before yourself
        # which can happen if we're moving into the same position.
        
        # crude test if an object is a node.
        setBindingStates = (states, node) ->
            node.className = classList.addClass(states, classList.removeClass(allBindingStates, node.className))
            return
        findTemplateNode = (root, options) ->
            useBestGuess = undefined
            node = undefined
            
            # user gave no explicit instructions
            useBestGuess = not options.itemTemplateSelector
            if options.querySelector
                
                # if no selector, try default selector
                node = options.querySelector(options.itemTemplateSelector or defaultTemplateSelector, root)
                
                # if still not found, search around for a list element
                node = options.querySelector(listElementsSelector, root)    if not node and useBestGuess
            node = root.firstChild    if not node and useBestGuess
            
            # if still not found, throw
            throw new Error('NodeListAdapter: could not find itemTemplate node')    unless node
            node
        'use strict'
        SortedMap = undefined
        classList = undefined
        NodeAdapter = undefined
        defaultIdAttribute = undefined
        defaultTemplateSelector = undefined
        listElementsSelector = undefined
        colaListBindingStates = undefined
        allBindingStates = undefined
        undef = undefined
        SortedMap = require('../../SortedMap')
        classList = require('../classList')
        NodeAdapter = require('./Node')
        defaultTemplateSelector = '[data-cola-role="item-template"]'
        defaultIdAttribute = 'data-cola-id'
        listElementsSelector = 'tr,li'
        colaListBindingStates =
            empty: 'cola-list-empty'
            bound: 'cola-list-bound'
            unbound: 'cola-list-unbound'

        allBindingStates = Object.keys(colaListBindingStates).map((key) ->
            colaListBindingStates[key]
        ).join(' ')
        NodeListAdapter:: =
            add: (item) ->
                adapter = undefined
                index = undefined
                adapter = @_createNodeAdapter(item)
                index = @_itemData.add(item, adapter)
                if index >= 0
                    @_itemCount = (@_itemCount or 0) + 1
                    @_insertNodeAt adapter._rootNode, index
                    @_checkBoundState()
                    @_itemsById[@identifier(item)] = item
                return

            remove: (item) ->
                adapter = undefined
                node = undefined
                adapter = @_itemData.get(item)
                @_itemData.remove item
                if adapter
                    @_itemCount--
                    node = adapter._rootNode
                    node.parentNode.removeChild node
                    @_checkBoundState()
                    delete @_itemsById[@identifier(item)]
                return

            update: (item) ->
                adapter = undefined
                index = undefined
                key = undefined
                adapter = @_itemData.get(item)
                unless adapter
                    @add item
                else
                    @_updating = adapter
                    try
                        adapter.update item
                        @_itemData.remove item
                        index = @_itemData.add(item, adapter)
                        key = @identifier(item)
                        @_itemsById[key] = item
                        @_insertNodeAt adapter._rootNode, index
                    finally
                        delete @_updating
                return

            forEach: (lambda) ->
                @_itemData.forEach lambda
                return

            setComparator: (comparator) ->
                i = 0
                self = this
                @comparator = comparator
                @_itemData.setComparator comparator
                @_itemData.forEach (adapter, item) ->
                    self._insertNodeAt adapter._rootNode, i++
                    return

                return

            getOptions: ->
                @_options

            findItem: (eventOrElement) ->
                node = undefined
                idAttr = undefined
                id = undefined
                return    unless eventOrElement and eventOrElement.target and eventOrElement.stopPropagation and eventOrElement.preventDefault or eventOrElement and eventOrElement.nodeName and eventOrElement.nodeType is 1
                node = (if eventOrElement.nodeType then eventOrElement else eventOrElement.target or eventOrElement.srcElement)
                return    unless node
                idAttr = @_options.idAttribute or defaultIdAttribute
                loop
                    id = node.getAttribute(idAttr)
                    break unless not id? and (node = node.parentNode) and node.nodeType is 1
                id? and @_itemsById[id]

            findNode: (thing) ->
                item = undefined
                data = undefined
                return    unless thing
                if typeof thing is 'string' or typeof thing is 'number'
                    item = @_itemsById[thing]
                else
                    item = @findItem(thing) or thing
                data = @_itemData.get(item)    if item?
                data and data._rootNode

            comparator: undef
            identifier: undef
            destroy: ->
                @_itemData.forEach (adapter) ->
                    adapter.destroy()
                    return

                return

            _initTemplateNode: ->
                templateNode = @_templateNode
                templateNode.parentNode.removeChild templateNode    if templateNode.parentNode
                templateNode.style.display = ''    if templateNode.style.display
                templateNode.id = ''    if templateNode.id
                return

            _createNodeAdapter: (item) ->
                node = undefined
                adapter = undefined
                idAttr = undefined
                origUpdate = undefined
                self = undefined
                node = @_templateNode.cloneNode(true)
                adapter = new NodeAdapter(node, @_options)
                adapter.set item
                if @identifier
                    idAttr = @_options.idAttribute or defaultIdAttribute
                    adapter._rootNode.setAttribute idAttr, @identifier(item)
                origUpdate = adapter.update
                self = this
                adapter.update = (item) ->
                    origUpdate.call adapter, item
                    self.update item    unless self._updating is adapter
                    return

                adapter

            _insertNodeAt: (node, index) ->
                parent = undefined
                refNode = undefined
                parent = @_containerNode
                refNode = parent.childNodes[index]
                parent.insertBefore node, refNode    unless node is refNode
                return

            _checkBoundState: ->
                states = undefined
                isBound = undefined
                isEmpty = undefined
                states = []
                isBound = @_itemCount?
                isEmpty = @_itemCount is 0
                states.push colaListBindingStates.unbound    unless isBound
                states.push colaListBindingStates.empty    if isEmpty
                states.push colaListBindingStates.bound    if isBound and not isEmpty
                setBindingStates states.join(' '), @_rootNode
                return

        NodeListAdapter.canHandle = (obj) ->
            obj and obj.tagName and obj.insertBefore and obj.removeChild

        NodeListAdapter

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)