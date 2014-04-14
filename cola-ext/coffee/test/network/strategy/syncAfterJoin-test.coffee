((buster, require) ->
    assert = undefined
    refute = undefined
    assert = buster.assert
    refute = buster.refute
    syncAfterJoin = require('../../../network/strategy/syncAfterJoin')
    mockApi = isAfter: ->
        true

    buster.testCase 'cola/network/strategy/syncAfterJoin',
        'should return function': ->
            assert.isFunction syncAfterJoin([])
            return

        'should call hub\'s queueEvent': (done) ->
            qspy = undefined
            api = undefined
            dest = undefined
            src = undefined
            qspy = @spy()
            api = Object.create(mockApi)
            api.queueEvent = qspy
            src = {}
            syncAfterJoin() src, dest, {}, 'join', api
            setTimeout (->
                assert.calledOnceWith qspy, src, false, 'sync'
                done()
                return
            ), 0
            return

        'should call hub\'s queueEvent when provide is true': (done) ->
            qspy = undefined
            api = undefined
            dest = undefined
            src = undefined
            qspy = @spy()
            api = Object.create(mockApi)
            api.queueEvent = qspy
            src = provide: true
            
            # add provider option and test for true data param
            syncAfterJoin() src, dest, {}, 'join', api
            setTimeout (->
                
                # Ensure that it was called twice, *and* at least one of
                # those was called with these args
                assert.calledOnceWith qspy, src, true, 'sync'
                done()
                return
            ), 0
            return

    return
) require('buster'), require