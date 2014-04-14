((buster, require) ->
    assert = undefined
    refute = undefined
    assert = buster.assert
    refute = buster.refute
    CollectionHub = require('../Collection')
    ArrayAdapter = require('../adapter/Array')
    buster.testCase 'cola/Collection',
        'should not fail if not given any constructor params': ->
            refute.exception ->
                new CollectionHub()
                return

            return

        'should add methods for eventNames': ->
            h = new CollectionHub()
            
            # this isn't a complete list, but proves the mechanism basically works
            assert.isObject h
            assert.isFunction h.add
            assert.isFunction h.beforeAdd
            assert.isFunction h.onAdd
            assert.isFunction h.update
            assert.isFunction h.beforeUpdate
            assert.isFunction h.onUpdate
            assert.isFunction h.remove
            assert.isFunction h.beforeRemove
            assert.isFunction h.onRemove
            return

        'should return an adapter when calling addSource with a non-adapter': ->
            h = new CollectionHub()
            a = h.addSource([])
            
            # sniff for an adapter
            assert.isObject a
            assert.isFunction a.add
            return

        'should pass through an adapter when calling addSource with an adapter': ->
            h = new CollectionHub()
            adapter = new ArrayAdapter([], {})
            a = h.addSource(adapter)
            
            # sniff for an adapter
            assert.same a, adapter
            return

        'should override adapter default provide via options': ->
            h = new CollectionHub()
            defaultProvide = true
            a = h.addSource([],
                provide: false
            )
            
            # sniff for an adapter
            refute.equals a.provide, defaultProvide
            return

        'should find and add new event types from adapter': ->
            e = {}
            h = new CollectionHub(events: e)
            adapter = new ArrayAdapter([])
            adapter.crazyNewEvent = ->

            a = h.addSource(adapter,
                eventNames: (name) ->
                    /^crazy/.test name
            )
            
            # check for method on hub api
            assert.isFunction h.onCrazyNewEvent
            return

        'should call findItem on each adapter': ->
            e = {}
            h = new CollectionHub(events: e)
            adapter = new ArrayAdapter([])
            adapter.findItem = @spy()
            a = h.addSource(adapter, {})
            h.findItem()
            
            # check that findItem was called
            assert.calledOnce adapter.findItem
            return

        'should call findNode on each adapter': ->
            e = {}
            h = new CollectionHub(events: e)
            adapter = new ArrayAdapter([])
            adapter.findNode = @spy()
            a = h.addSource(adapter, {})
            h.findNode()
            
            # check that findItem was called
            assert.calledOnce adapter.findNode
            return

        'should call strategy to join adapter': ->
            strategy = @spy()
            h = new CollectionHub(strategy: strategy)
            h.onJoin = @spy()
            h.addSource []
            
            # strategy should be called to join primary into network
            assert.calledOnce h.onJoin
            return

        'should not call events if strategy cancels event': (done) ->
            # debug
            strategy = (source, dest, data, type, api) ->
                isAfterCanceled = api.isAfterCanceled()
                api.cancel()
                return
            h = new CollectionHub(strategy: strategy)
            primary = h.addSource([])
            isAfterCanceled = undefined
            h.beforeAdd = @spy()
            h.onAdd = ->
                assert.calledOnce h.beforeAdd
                done()
                return

            primary.name = 'primary'
            primary.add id: 1
            assert isAfterCanceled, 'last event should be canceled'
            return

        'should run queued event in next turn': (done) ->
            
            # ensure remove hasn't executed yet
            strategy = (source, dest, data, type, api) ->
                if 'add' is type
                    api.queueEvent source, data, 'remove'
                else removeDetected = true    if 'remove' is type
                return
            h = new CollectionHub(strategy: strategy)
            primary = h.addSource([])
            removeDetected = undefined
            primary.add id: 1
            refute.defined removeDetected
            setTimeout (->
                assert.defined removeDetected
                done()
                return
            ), 100
            return

        '// should add property transforms to adapter': ->

    return
) require('buster'), require