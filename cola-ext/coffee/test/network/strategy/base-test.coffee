((buster, require) ->
    assert = undefined
    refute = undefined
    undef = undefined
    assert = buster.assert
    refute = buster.refute
    base = require('../../../network/strategy/base')
    mockApi =
        isPropagating: ->
            true

        isHandled: ->
            false

    buster.testCase 'cola/network/strategy/base',
        'should return function': ->
            assert.isFunction base()
            return

        'should\texecute method on dest adapter': ->
            spy = undefined
            strategy = undefined
            dest = undefined
            spy = @spy()
            strategy = base()
            dest = anyEvent: spy
            strategy null, dest, {}, 'anyEvent', mockApi
            assert.calledOnce spy
            return

        'should not execute method on dest adapter if method doesn\'t exist': ->
            spy = undefined
            strategy = undefined
            dest = undefined
            spy = @spy()
            strategy = base()
            dest = {}
            strategy null, dest, {}, 'anyEvent', mockApi
            refute.calledOnce spy
            return

        'should throw if non-method with event name exists on dest adapter': ->
            spy = undefined
            strategy = undefined
            dest = undefined
            spy = @spy()
            strategy = base()
            dest = anyProp: 1
            try
                strategy null, dest, {}, 'anyProp', mockApi
                refute true
            catch ex
                assert true
            return

    return
) require('buster'), require