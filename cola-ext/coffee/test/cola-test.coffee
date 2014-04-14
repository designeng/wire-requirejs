((buster, when_, cola) ->
    makeResolver = (resolve, reject) ->
        resolve: resolve
        reject: reject
    'use strict'
    assert = undefined
    refute = undefined
    fail = undefined
    refResolver = undefined
    assert = buster.assert
    refute = buster.refute
    fail = buster.assertions.fail
    refResolver = isRef: ->
        false

    buster.testCase 'cola',
        'wire plugin':
            'should return a valid plugin': ->
                plugin = cola.wire$plugin(null, null, {})
                assert.isFunction plugin.facets.bind.ready
                return

            'should fail if "to" not provided': (done) ->
                plugin = undefined
                bind = undefined
                wire = undefined
                rejected = undefined
                plugin = cola.wire$plugin(null, null, {})
                bind = plugin.facets.bind.ready
                wire = @stub().returns({})
                wire.resolver = refResolver
                rejected = @spy()
                bind makeResolver((p) ->
                    p.then(fail, rejected).then(->
                        assert.calledOnce rejected
                        return
                    ).then done, done
                    return
                ),
                    target: {}
                , wire
                return

            'should wire options': ->
                plugin = undefined
                bind = undefined
                wire = undefined
                resolved = undefined
                plugin = cola.wire$plugin(null, null, {})
                bind = plugin.facets.bind.ready
                wire = @stub().returns(to:
                    addSource: @spy()
                )
                wire.resolver = refResolver
                resolved = @spy()
                bind makeResolver(resolved),
                    target: {}
                , wire
                assert.calledOnce wire
                assert.calledOnce resolved
                return

            'should add source': ->
                plugin = undefined
                bind = undefined
                wire = undefined
                addSource = undefined
                target = undefined
                plugin = cola.wire$plugin(null, null, {})
                bind = plugin.facets.bind.ready
                addSource = @spy()
                wire = @stub().returns(to:
                    addSource: addSource
                )
                wire.resolver = refResolver
                target = {}
                bind makeResolver(@spy()),
                    target: target
                , wire
                assert.calledOnceWith addSource, target
                return

            'should include default comparator if not provided': ->
                plugin = undefined
                bind = undefined
                wire = undefined
                resolved = undefined
                wired = undefined
                plugin = cola.wire$plugin(null, null, {})
                bind = plugin.facets.bind.ready
                wire = (s) ->
                    wired = s
                    return

                wire.resolver = refResolver
                resolved = @spy()
                bind makeResolver(resolved),
                    target: {}
                , wire
                assert.isFunction wired.comparator
                return

    return
) require('buster'), require('when'), require('../cola')