((buster, inherit) ->
    'use strict'
    assert = undefined
    refute = undefined
    assert = buster.assert
    refute = buster.refute
    input1 = undefined
    input2 = undefined
    input1 = a: 1
    input2 = b: 2
    buster.testCase 'projection/inherit',
        'should not modify input objects': ->
            inherit input1, input2
            assert.equals input1,
                a: 1

            assert input1.hasOwnProperty('a')
            assert.equals input2,
                b: 2

            assert input2.hasOwnProperty('b')
            return

        'should return a new object': ->
            result = inherit(input1, input2)
            refute.same result, input1
            refute.same result, input2
            return

        'should inherit properties from input1': ->
            result = inherit(input1, input2)
            assert.equals result.a, input1.a
            refute result.hasOwnProperty('a')
            return

        'should have own properties from input2': ->
            result = inherit(input1, input2)
            assert.equals result.b, input2.b
            assert result.hasOwnProperty('b')
            return

    return
) require('buster'), require('../../projection/inherit')