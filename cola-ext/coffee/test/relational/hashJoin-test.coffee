((buster, when_, hashJoin) ->
    identity = (x) ->
        x
    projectPair = (left, right, key) ->
        left: left
        right: right
        key: key
    'use strict'
    assert = undefined
    refute = undefined
    fail = undefined
    assert = buster.assert
    refute = buster.refute
    fail = buster.assertions.fail
    buster.testCase 'relational/hashJoin',
        leftOuterJoin:
            'should produce empty result for empty left input': (done) ->
                left = undefined
                right = undefined
                left = []
                right = [
                    1
                    2
                    3
                ]
                when_(hashJoin.leftOuterJoin(left, identity, right, identity, identity), (joined) ->
                    assert.equals joined, []
                    return
                , fail).then done, done
                return

            'should contain all left items': (done) ->
                left = undefined
                right = undefined
                left = [
                    1
                    2
                    3
                ]
                right = [
                    2
                    4
                    6
                ]
                when_(hashJoin.leftOuterJoin(left, identity, right, identity, identity), (joined) ->
                    assert.equals joined, left
                    return
                , fail).then done, done
                return

            'should produce left input for empty right input': (done) ->
                left = undefined
                right = undefined
                left = [
                    1
                    2
                    3
                ]
                right = []
                when_(hashJoin.leftOuterJoin(left, identity, right, identity, identity), (joined) ->
                    assert.equals joined, left
                    return
                , fail).then done, done
                return

            'should project all items': (done) ->
                left = undefined
                right = undefined
                left = [
                    1
                    2
                    3
                ]
                right = [
                    1
                    2
                    3
                    4
                    5
                    6
                ]
                when_(hashJoin.leftOuterJoin(left, identity, right, identity, projectPair), (joined) ->
                    assert.equals joined.length, left.length
                    i = 0
                    len = joined.length

                    while i < len
                        assert.equals joined[i],
                            left: left[i]
                            right: right[i]
                            key: left[i]

                        i++
                    return
                , fail).then done, done
                return

    return
) require('buster'), require('when'), require('../../relational/hashJoin')