((buster, require) ->
    assert = undefined
    refute = undefined
    undef = undefined
    assert = buster.assert
    refute = buster.refute
    def = require('../../../network/strategy/default')
    buster.testCase 'cola/network/strategy/default',
        'should return function': ->
            assert.isFunction def([])
            return

        '// should have more tests': ->
            assert false
            return

    return
) require('buster'), require