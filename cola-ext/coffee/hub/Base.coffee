###
base
@author: brian
###
((define) ->
    define (require) ->
        
        # TODO: make these configurable/extensible
        
        # basic item events. most of these come with data. devs can
        # decide to use these events for their own purposes or send
        # different data than described here, the following list outlines
        # the intended behavior.
        # data == item updated
        # data == event type that caused the change
        # data == validation result object with at least a boolean valid prop
        # mode events
        # abort the current mode (no data)
        # finalize the current mode (no data)
        # edit event
        # enter edit mode (data == item to edit)
        # network-level events (not to be used by adapters)
        # an adapter has joined (data == adapter)
        # adapters need to sync (data == boolean. true == provider)
        # an adapter has left (data == adapter)
        
        ###
        Signal that event has not yet been pushed onto the network.
        Return false to prevent the event from being pushed.
        ###
        
        ###
        Signal that event is currently being propagated to adapters.
        ###
        
        ###
        Signal that an event has already been pushed onto the network.
        Return value is ignored since the event has already propagated.
        ###
        
        ###
        Signal that an event was canceled and not pushed onto the network.
        Return value is ignored since the event has already propagated.
        ###
        BaseHub = (options) ->
            eventTypes = undefined
            t = undefined
            @adapters = []
            options = {}    unless options
            @identifier = options.identifier or defaultIdentifier
            @eventProcessor = Object.create(eventProcessor,
                queue:
                    value: []

                eventProcessor:
                    value: @processEvent.bind(this)
            )
            eventTypes = @eventTypes
            for t of eventTypes
                @addApi t
            return
        
        # TODO: do something with this exception
        
        # create an adapter for this source
        
        # save the proxied adapter
        
        #
        #		 1. call events.beforeXXX(data)
        #		 2. call strategy on each source/dest pair w/ event XXX and data
        #		 - cancel iteration if any strategy returns false for any pair
        #		 3. if not canceled, call events.XXX(data)
        #		 
        
        # keep copy of original source so we can match it up later
        
        # sniff for event hooks
        
        # override methods that require event hooks
        
        # store original method on proxy (to stop recursion)
        
        # change public api of adapter to call back into hub
        
        # ensure hub has a public method of the same name
        
        # add function stub to api
        
        # add beforeXXX stub, too
        
        # loop through adapters that have the getItemForEvent() method
        # to try to find out which adapter and which data item
        createStrategyApi = (context, eventProcessor) ->
            isPhase = (phase) ->
                context.phase is phase
            return (
                queueEvent: (source, data, type) ->
                    eventProcessor.queueEvent source, data, type

                cancel: ->
                    context.canceled = true
                    return

                isCanceled: ->
                    !!context.canceled

                handle: ->
                    context.handled = true
                    return

                isHandled: ->
                    !!context.handled

                isBefore: ->
                    isPhase beforePhase

                isAfter: ->
                    isPhase afterPhase

                isAfterCanceled: ->
                    isPhase canceledPhase

                isPropagating: ->
                    isPhase propagatingPhase
            )
            return
        callOriginalMethod = (adapter, orig) ->
            ->
                orig.apply adapter, arguments_
        observeMethod = (queue, adapter, type, origMethod) ->
            adapter[type] = (data) ->
                queue.queueEvent adapter, data, type
                origMethod.call adapter, data
        findAdapterForSource = (source, adapters) ->
            i = undefined
            adapter = undefined
            found = undefined
            
            # loop through adapters and find which one was created for this source
            i = 0
            found = adapter    if adapter.origSource is source    while not found and (adapter = adapters[i++])
            found
        when_ = undefined
        baseEvents = undefined
        eventProcessor = undefined
        simpleStrategy = undefined
        defaultIdentifier = undefined
        beforePhase = undefined
        propagatingPhase = undefined
        afterPhase = undefined
        canceledPhase = undefined
        undef = undefined
        when_ = require('when')
        eventProcessor = require('./eventProcessor')
        simpleStrategy = require('../network/strategy/default')
        defaultIdentifier = require('../identifier/default')
        baseEvents =
            update: 1
            change: 1
            validate: 1
            abort: 1
            submit: 1
            edit: 1
            join: 1
            sync: 1
            leave: 1

        beforePhase = {}
        propagatingPhase = {}
        afterPhase = {}
        canceledPhase = {}
        BaseHub:: =
            eventTypes: baseEvents
            dispatchEvent: (name, data) ->
                try
                    return this[name](data)
                catch ex
                    return false
                return

            createAdapter: (source, options) ->
                Adapter = @resolver.resolve(source)
                (if Adapter then new Adapter(source, options) else source)

            addSource: (source, options) ->
                adapter = undefined
                proxy = undefined
                options = {}    unless options
                options.identifier = @identifier    unless options.identifier
                adapter = @createAdapter(source, options)
                proxy = @_createAdapterProxy(adapter, options)
                proxy.origSource = source
                @adapters.push proxy
                @eventProcessor.processEvent proxy, null, 'join'
                adapter

            processEvent: (source, data, type) ->
                context = undefined
                strategyApi = undefined
                self = undefined
                strategy = undefined
                adapters = undefined
                context = {}
                self = this
                strategy = @strategy
                adapters = @adapters
                when_(self.dispatchEvent(eventProcessor.makeBeforeEventName(type), data)).then((result) ->
                    context.canceled = result is false
                    return when_.reject(context)    if context.canceled
                    context.phase = beforePhase
                    strategyApi = createStrategyApi(context, self.eventProcessor)
                    strategy source, undef, data, type, strategyApi
                ).then(->
                    context.phase = propagatingPhase
                    when_.map adapters, (adapter) ->
                        strategy source, adapter, data, type, strategyApi    unless source is adapter

                ).then(->
                    context.phase = (if context.canceled then canceledPhase else afterPhase)
                    strategy source, undef, data, type, strategyApi
                ).then((result) ->
                    context.canceled = result is false
                    return when_.reject(context)    if context.canceled
                    self.dispatchEvent eventProcessor.makeEventName(type), data
                ).then ->
                    context


            destroy: ->
                adapters = undefined
                adapter = undefined
                adapters = @adapters
                adapter.destroy()    if typeof adapter.destroy is 'function'    while (adapter = adapters.pop())
                return

            addApi: (name) ->
                @_addApiMethod name
                @_addApiEvent name
                return

            _createAdapterProxy: (adapter, options) ->
                eventFinder = undefined
                name = undefined
                method = undefined
                proxy = undefined
                proxy = Object.create(adapter)
                proxy.provide = options.provide    if 'provide' of options
                eventFinder = @configureEventFinder(options.eventNames)
                for name of adapter
                    method = adapter[name]
                    if typeof method is 'function' and eventFinder(name)
                        proxy[name] = callOriginalMethod(adapter, method)
                        observeMethod @eventProcessor, adapter, name, method
                        @addApi name
                proxy

            configureEventFinder: (option) ->
                eventTypes = @eventTypes
                (if typeof option is 'function' then option else (name) ->
                    name of eventTypes
                )

            _addApiMethod: (name) ->
                adapters = undefined
                self = undefined
                eventProcessor = undefined
                adapters = @adapters
                eventProcessor = @eventProcessor
                self = this
                unless this[name]
                    this[name] = (anything) ->
                        sourceInfo = undefined
                        sourceInfo = self._findItemFor(anything)
                        unless sourceInfo
                            sourceInfo =
                                item: anything
                                source: findAdapterForSource(arguments_[1], adapters)
                        eventProcessor.queueEvent sourceInfo.source, sourceInfo.item, name
                return

            _addApiEvent: (name) ->
                eventName = @eventProcessor.makeEventName(name)
                if !this[eventName]
                    this[eventName] = (data) ->
                eventName = @eventProcessor.makeBeforeEventName(name)
                if !this[eventName]
                    this[eventName] = (data) ->
                return

            _findItemFor: (anything) ->
                item = undefined
                i = undefined
                adapters = undefined
                adapter = undefined
                adapters = @adapters
                i = 0
                item = adapter.findItem(anything)    if adapter.findItem    while not item and (adapter = adapters[i++])
                item and item: item

        return BaseHub
        return

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)