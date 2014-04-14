((buster, require) ->
    assert = undefined
    refute = undefined
    undef = undefined
    assert = buster.assert
    refute = buster.refute
    targetFirstItem = require('../../../network/strategy/targetFirstItem')
    buster.testCase 'targetFirstItem',
        'should return function': ->
            assert.isFunction targetFirstItem([])
            return

        'should call queueEvent once': ->
            qspy = undefined
            src = undefined
            data = undefined
            api = undefined
            strategy = undefined
            qspy = @spy()
            src = {}
            data = {}
            api =
                isBefore: ->
                    true

                queueEvent: qspy

            
            # call twice:
            strategy = targetFirstItem()
            strategy src, null, data, 'add', api
            strategy src, null, data, 'add', api
            assert.calledOnceWith qspy, src, data, 'target'
            
            # call twice again after sync
            qspy = api.queueEvent = @spy()
            strategy src, null, data, 'sync', api
            strategy src, null, data, 'add', api
            strategy src, null, data, 'add', api
            assert.calledOnceWith qspy, src, data, 'target'
            return

    return
) require('buster'), require