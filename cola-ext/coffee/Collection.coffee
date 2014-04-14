###
Collection
###
((define) ->
    define (require) ->
        
        # collection item events. most of these come with data. devs can
        # decide to use these events for their own purposes or send
        # different data than described here, the following list outlines
        # the intended behavior.
        # data == item added
        # data == item removed
        # data == item targeted TODO: rename this to "point"?
        # multi-item events
        # select an item (data == item)
        # deselect an item (data == item)
        # batch events
        # start of batch mode (until abort or submit) (data = batch purpose)
        # collected items (data = batch purpose with collected items array as property)
        Collection = (options) ->
            Base.call this, options
            options = {}    unless options
            @strategy = options.strategy
            @strategy = simpleStrategy(options.strategyOptions)    unless @strategy
            return
        
        # loop through adapters that have the findNode() method
        # to try to find out which adapter and which node
        extend = (base, mixin) ->
            extended = Object.create(base)
            for p of mixin
                extended[p] = mixin[p]
            extended
        Base = undefined
        resolver = undefined
        eventTypes = undefined
        simpleStrategy = undefined
        Base = require('./hub/Base')
        resolver = require('./collectionAdapterResolver')
        simpleStrategy = require('./network/strategy/default')
        eventTypes = extend(Base::eventTypes,
            add: 1
            remove: 1
            target: 1
            select: 1
            unselect: 1
            collect: 1
            deliver: 1
        )
        Collection:: = Object.create(Base::,
            eventTypes:
                value: eventTypes

            resolver:
                value: resolver

            forEach:
                value: forEach = (lambda) ->
                    provider = @getProvider()
                    provider and provider.forEach(lambda)

            findItem:
                value: (anything) ->
                    info = @_findItemFor(anything)
                    info and info.item

            findNode:
                value: (anything) ->
                    info = @_findNodeFor(anything)
                    info and info.node

            getProvider:
                value: ->
                    a = undefined
                    i = @adapters.length
                    return a    if a.provide    while a = @adapters[--i]
                    return

            _findNodeFor:
                value: (anything) ->
                    node = undefined
                    i = undefined
                    adapters = undefined
                    adapter = undefined
                    adapters = @adapters
                    i = 0
                    node = adapter.findNode(anything)    if adapter.findNode    while not node and (adapter = adapters[i++])
                    node and node: node
        )
        return Collection
        return

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)