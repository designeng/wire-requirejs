((buster, require) ->
    assert = undefined
    refute = undefined
    compose = undefined
    mockApi = undefined
    undef = undefined
    assert = buster.assert
    refute = buster.refute
    compose = require('../../../network/strategy/compose')
    mockApi =
        isCanceled: ->
            @canceled

        cancel: ->
            @canceled = true
            return

        isHandled: ->
            @handled

        handle: ->
            @handled = true
            return

    buster.testCase 'cola/network/strategy/compose',
        'should return function': ->
            assert.isFunction compose([])
            return

        'should call each of the strategies': ->
            strategies = undefined
            strategies = [
                @spy()
                @spy()
                @spy()
            ]
            compose(strategies) {}, {}, {}, '', Object.create(mockApi)
            assert.called strategies[0]
            assert.called strategies[1]
            assert.called strategies[2]
            return

        'should call the strategies in order': ->
            strategies = undefined
            strategies = [
                @spy()
                @spy()
                @spy()
            ]
            compose(strategies) {}, {}, {}, '', Object.create(mockApi)
            assert.callOrder strategies[0], strategies[1], strategies[2]
            return

        'should not proceed past strategy that cancels': ->
            strategies = undefined
            strategies = [
                @spy()
                (src, dst, data, type, api) ->
                    api.cancel()
                @spy()
            ]
            compose(strategies) {}, {}, {}, '', Object.create(mockApi)
            assert.called strategies[0]
            refute.called strategies[2]
            return

    return
) require('buster'), require