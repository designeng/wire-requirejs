###
eventQueue
@author: brian
###
((define) ->
    define (require) ->
        
        ###
        Queue an event for processing later
        @param source
        @param data
        @param type
        ###
        
        # if queue length is zero, we need to start processing it again
        
        # enqueue event
        
        # start processing, if necessary
        
        ###
        Process an event immediately
        @param source
        @param data
        @param type
        ###
        
        # get the next event, if any
        
        # Ensure resolution is next turn, even if no event
        # is actually dispatched.
        
        # Only continue processing the queue if it's not empty
        makeEventName = (prefix, name) ->
            prefix + name.charAt(0).toUpperCase() + name.substr(1)
        when_ = undefined
        enqueue = undefined
        when_ = require('when')
        enqueue = require('../enqueue')
        return (
            makeBeforeEventName: (name) ->
                makeEventName 'before', name

            makeEventName: (name) ->
                makeEventName 'on', name

            queueEvent: (source, data, type) ->
                queueNeedsRestart = @queue.length is 0
                @queue.push
                    source: source
                    data: data
                    type: type

                queueNeedsRestart and @_dispatchNextEvent()

            processEvent: (source, data, type) ->
                self = this
                @inflight = when_(@inflight).always(->
                    self.eventProcessor source, data, type
                )
                @inflight

            _dispatchNextEvent: ->
                event = undefined
                remaining = undefined
                deferred = undefined
                self = undefined
                self = this
                event = @queue.shift()
                remaining = @queue.length
                deferred = when_.defer()
                enqueue ->
                    inflight = event and self.processEvent(event.source, event.data, event.type)
                    deferred.resolve inflight
                    return

                if remaining
                    deferred.promise.always ->
                        self._dispatchNextEvent()
                        return

                deferred.promise
        )
        return

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)