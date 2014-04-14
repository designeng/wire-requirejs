((buster, configure) ->
    'use strict'
    assert = undefined
    refute = undefined
    assert = buster.assert
    refute = buster.refute
    buster.testCase 'transform/configure',
        'should return a function': ->
            assert.isFunction configure(->
            )
            return

        'should not return an inverse when input does not have an inverse': ->
            refute.defined configure(->
            ).inverse
            return

        'should return an inverse when input has an inverse': ->
            t = ->
            t.inverse = ->

            assert.isFunction configure(t).inverse
            return

        'should pass all configured parameters through to resulting function': ->
            t = undefined
            c = undefined
            t = @spy()
            c = configure(t, 1, 2, 3)
            c 'a', 'b', 'c'
            assert.calledOnceWith t, 'a', 'b', 'c', 1, 2, 3
            return

        'should pass all configured parameters through to resulting inverse': ->
            t = ->
            t.inverse = @spy()
            c = configure(t, 1, 2, 3)
            c.inverse 'a', 'b', 'c'
            assert.calledOnceWith t.inverse, 'a', 'b', 'c', 1, 2, 3
            return

    return
) require('buster'), require('../../transform/configure')