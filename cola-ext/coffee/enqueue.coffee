((define) ->
    define ->
        
        # node
        
        # IE 10. From http://github.com/kriskowal/q
        # bind is necessary
        
        # older envs w/only setTimeout
        
        ###
        MessageChannel for browsers that support it
        From http://www.nonblocking.io/2011/06/windownexttick.html
        ###
        initMessageChannel = ->
            channel = undefined
            head = undefined
            tail = undefined
            channel = new MessageChannel()
            head = {}
            tail = head
            channel.port1.onmessage = ->
                task = undefined
                head = head.next
                task = head.task
                delete head.task

                task()
                return

            (task) ->
                tail = tail.next = task: task
                channel.port2.postMessage 0
                return
        'use strict'
        enqueue = undefined
        if typeof process isnt 'undefined'
            enqueue = process.nextTick
        else if typeof msSetImmediate is 'function'
            enqueue = msSetImmediate.bind(window)
        else if typeof setImmediate is 'function'
            enqueue = setImmediate
        else if typeof MessageChannel isnt 'undefined'
            enqueue = initMessageChannel()
        else
            enqueue = (task) ->
                setTimeout task, 0
                return
        return enqueue
        return

    return
) (if typeof define is 'function' and define.amd then define else (factory) ->
    module.exports = factory()
    return
)