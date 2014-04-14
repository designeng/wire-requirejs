((buster, compose) ->
    addOne = (x) ->
        x + 1
    addOneWithInverse = (x) ->
        addOne x
    'use strict'
    assert = undefined
    refute = undefined
    assert = buster.assert
    refute = buster.refute
    addOneWithInverse.inverse = (x) ->
        x - 1

    buster.testCase 'transform/compose',
        'should return identity if no input transforms provided': ->
            c = compose()
            assert.equals 1, c(1)
            return

        'should return identity inverse if no input transforms provided': ->
            c = compose()
            assert.equals 1, c.inverse(1)
            return

        'should compose a single function': ->
            c = compose(addOne)
            assert.equals 1, c(0)
            return

        'should compose a single function with inverse': ->
            c = compose(addOneWithInverse)
            assert.equals 0, c.inverse(1)
            return

        'should compose argument list of function': ->
            c = compose(addOne, addOne)
            assert.equals 2, c(0)
            return

        'should compose array of function': ->
            c = compose([
                addOne
                addOne
            ])
            assert.equals 2, c(0)
            return

        'should compose mixed argument list and arrays of function': ->
            c = compose(addOne, [
                addOne
                addOne
            ], addOne)
            assert.equals 4, c(0)
            return

        'should compose inverse of mixed argument list and arrays of function': ->
            c = compose(addOneWithInverse, [
                addOneWithInverse
                addOneWithInverse
            ], addOneWithInverse)
            assert.equals 0, c.inverse(4)
            return

        'should compose varargs functions': ->
            c = compose((a) ->
                a
            , (a, b, c) ->
                c
            )
            assert.equals 3, c(1, 2, 3)
            return

        'should compose varargs inverse functions': ->
            f1 = undefined
            f2 = undefined
            f1 = (a) ->
                a

            f1.inverse = (a, b, c) ->
                c

            f2 = (a, b, c) ->
                c

            f2.inverse = (a) ->
                a

            c = compose(f1, f2)
            assert.equals 3, c.inverse(1, 2, 3)
            return

    return
) require('buster'), require('../../transform/compose')