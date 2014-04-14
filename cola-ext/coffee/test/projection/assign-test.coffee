((buster, assign) ->
    'use strict'
    assert = undefined
    refute = undefined
    assert = buster.assert
    refute = buster.refute
    buster.testCase 'projection/assign',
        'should assign to specified property': ->
            a = assign('test')
            assert.equals a({}, 1),
                test: 1

            return

        'should return input 1': ->
            a = undefined
            input = undefined
            a = assign('test')
            input = {}
            assert.same a(input, 1), input
            return

        'should return unmodified input 1 if input 1 is falsey': ->
            a = undefined
            input = undefined
            a = assign('test')
            assert.equals a(input, 1), input
            return

    return
) require('buster'), require('../../projection/assign')