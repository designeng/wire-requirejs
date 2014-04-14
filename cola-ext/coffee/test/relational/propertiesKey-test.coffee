((buster, propertiesKey) ->
    'use strict'
    assert = undefined
    refute = undefined
    assert = buster.assert
    refute = buster.refute
    buster.testCase 'relational/propertiesKey',
        'should return property value for single property': ->
            fixture = undefined
            key = undefined
            fixture = foo: 'bar'
            key = propertiesKey('foo')
            assert.equals key(fixture), 'bar'
            return

        'should return undefined for missing single property': ->
            fixture = undefined
            key = undefined
            fixture = foo: 'bar'
            key = propertiesKey('missing')
            refute.defined key(fixture)
            return

        'should return joined values for an array of properties': ->
            fixture = undefined
            key = undefined
            fixture =
                p1: 'foo'
                p2: 'bar'

            key = propertiesKey([
                'p1'
                'p2'
            ])
            assert.equals key(fixture), 'foo|bar'
            return

        'should use the supplied join separator': ->
            fixture = undefined
            key = undefined
            fixture =
                p1: 'foo'
                p2: 'bar'

            key = propertiesKey([
                'p1'
                'p2'
            ], ',')
            assert.equals key(fixture), 'foo,bar'
            return

        'should only include defined and non-null values for an array of properties': ->
            fixture = undefined
            key = undefined
            fixture =
                p1: 'foo'
                p2: 'bar'

            key = propertiesKey([
                'p1'
                'p3'
                'p2'
            ])
            assert.equals key(fixture), 'foo|bar'
            return

        'should return empty string when all properties in array are missing': ->
            fixture = undefined
            key = undefined
            fixture =
                p1: 'foo'
                p2: 'bar'

            key = propertiesKey([
                'p3'
                'p4'
            ])
            assert.equals key(fixture), ''
            return

    return
) require('buster'), require('../../relational/propertiesKey')