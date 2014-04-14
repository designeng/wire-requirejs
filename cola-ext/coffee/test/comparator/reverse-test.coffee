((buster, require) ->
    compare = (a, b) ->
        a - b
    assert = undefined
    refute = undefined
    fail = undefined
    assert = buster.assert
    refute = buster.refute
    fail = buster.assertions.fail
    reverse = require('../../comparator/reverse')
    buster.testCase 'comparator/reverse',
        'should return equality for equal items': ->
            assert.equals reverse(compare)(1, 1), 0
            return

        'should return -1 for nested less': ->
            assert.equals reverse(compare)(1, 0), -1
            return

        'should return 1 for nested less': ->
            assert.equals reverse(compare)(0, 1), 1
            return

        'should throw if no comparators provided': ->
            assert.exception reverse
            return

    return
) require('buster'), require