((buster, createEnum) ->
    'use strict'
    assert = undefined
    refute = undefined
    assert = buster.assert
    refute = buster.refute
    buster.testCase 'transform/createEnum',
        'should return a function': ->
            assert.isFunction createEnum({})
            return

        'should return an inverse function': ->
            assert.isFunction createEnum({}).inverse
            return

        transform:
            'should return an empty set when configured with empty input map': ->
                e = createEnum({})
                assert.equals e('test'), {}
                return

            'should return an empty set with non-existent input': ->
                e = createEnum(foo: 'bar')
                assert.equals e('test'), {}
                return

            'should return corresponding set values': ->
                e = createEnum(
                    a: 'a1'
                    b: 'b1'
                )
                result = e('a')
                assert result.a1
                refute result.b1
                return

            'should return corresponding set values when multi-value': ->
                e = createEnum(
                    a: 'a1'
                    b: 'b1'
                    c: 'c1'
                ,
                    multi: true
                )
                result = e([
                    'a'
                    'b'
                ])
                assert result.a1
                assert result.b1
                refute result.c1
                return

        inverse:
            'should return an empty array with empty input map': ->
                e = createEnum({})
                assert.equals e.inverse({}), []
                return

            'should return an empty array with non-existent input': ->
                e = createEnum(foo: 'bar')
                assert.equals e.inverse(baz: true), []
                return

            'should return corresponding values': ->
                e = createEnum(
                    a: 'a1'
                    b: 'b1'
                )
                assert.equals e.inverse(a1: true), ['a']
                return

            'should return corresponding set values when multi-value': ->
                e = createEnum(
                    a: 'a1'
                    b: 'b1'
                ,
                    multi: true
                )
                assert.equals e.inverse(
                    a1: true
                    b1: true
                ), [
                    'a'
                    'b'
                ]
                return

    return
) require('buster'), require('../../transform/createEnum')