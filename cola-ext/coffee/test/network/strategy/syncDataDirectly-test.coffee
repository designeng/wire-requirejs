((buster, require) ->
    FakeApi = (phase) ->
        phase: phase
        isBefore: ->
            @phase is 'before'
    FakeAdapter = ->
        add: ->

        forEach: ->
    assert = undefined
    refute = undefined
    undef = undefined
    assert = buster.assert
    refute = buster.refute
    syncDataDirectly = require('../../../network/strategy/syncDataDirectly')
    buster.testCase 'cola/network/strategy/syncDataDirectly',
        'should return a function': ->
            assert.isFunction syncDataDirectly()
            return

        'should always cancel a "sync"': ->
            strategy = syncDataDirectly()
            api = new FakeApi('before')
            api.cancel = @spy()
            strategy new FakeAdapter(), new FakeAdapter(), {}, 'sync', api
            assert.called api.cancel
            return

        '// should have more tests': ->
            assert false
            return

    return
) require('buster'), require