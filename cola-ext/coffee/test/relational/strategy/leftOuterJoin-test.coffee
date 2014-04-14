((buster, createLeftOuterJoin, hashJoin) ->
    noop = ->
    fakeIterable = ->
        forEach: noop
    'use strict'
    assert = undefined
    refute = undefined
    origLeftOuterJoin = undefined
    assert = buster.assert
    refute = buster.refute
    buster.testCase 'relational/strategy/leftOuterJoin',
        setUp: ->
            origLeftOuterJoin = hashJoin.leftOuterJoin
            hashJoin.leftOuterJoin = @spy()
            return

        tearDown: ->
            hashJoin.leftOuterJoin = origLeftOuterJoin
            return

        'should throw if options not provided': ->
            assert.exception ->
                createLeftOuterJoin()
                return

            return

        'should throw if options.leftKey not provided': ->
            assert.exception ->
                createLeftOuterJoin {}
                return

            return

        'should return a function if options.leftKey is provided': ->
            assert.isFunction createLeftOuterJoin(leftKey: 'id')
            return

        'should return a function that forwards parameters to join engine': ->
            join = undefined
            left = undefined
            right = undefined
            join = createLeftOuterJoin(
                leftKey: noop
                rightKey: noop
                projection: noop
                multiValue: true
            )
            left = @stub(fakeIterable())
            right = @stub(fakeIterable())
            join left, right
            assert.calledOnceWith hashJoin.leftOuterJoin, left, noop, right, noop, noop, true
            return

    return
) require('buster'), require('../../../relational/strategy/leftOuterJoin'), require('../../../relational/hashJoin')