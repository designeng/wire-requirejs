((buster, require) ->
    lt = ->
        -1
    gt = ->
        1
    eq = ->
        0
    assert = undefined
    refute = undefined
    fail = undefined
    assert = buster.assert
    refute = buster.refute
    fail = buster.assertions.fail
    compose = require('../../comparator/compose')
    buster.testCase 'comparator/compose',
        'should return equality for equal items': ->
            assert.equals compose(eq, eq)(), 0
            return

        'should return -1 for nested less': ->
            assert.equals compose(eq, lt)(), -1
            return

        'should return 1 for nested less': ->
            assert.equals compose(eq, gt)(), 1
            return

        'should throw if no comparators provided': ->
            assert.exception compose
            return

    return
) require('buster'), require