((buster, when_, QueryAdapter) ->
    promiseFor = (it) ->
        when_ it
    createDatasource = ->
        getIdentity: ->

        query: ->

        add: ->

        put: ->

        remove: ->
    assert = undefined
    refute = undefined
    fail = undefined
    assert = buster.assert
    refute = buster.refute
    fail = buster.assertions.fail
    buster.testCase 'adapter/Query',
        'should throw if no datasource provided': ->
            assert.exception ->
                new QueryAdapter()
                return

            return

        options:
            'should be a provider by default': ->
                a = new QueryAdapter({})
                assert a.provide
                return

            'should allow overriding provide': ->
                a = new QueryAdapter({},
                    provide: false
                )
                refute a.provide
                return

            'should preserve bindings options': ->
                bindings = undefined
                adaptedObject = undefined
                bindings = {}
                adaptedObject = new QueryAdapter({},
                    bindings: bindings
                )
                assert.equals adaptedObject.getOptions().bindings, bindings
                return

        query:
            'should query datasource': (done) ->
                qa = undefined
                ds = undefined
                queryStub = undefined
                added = undefined
                removed = undefined
                ds = @stub(createDatasource())
                ds.query.returns promiseFor([id: 1])
                
                # Have to hold onto this stub because QueryAdapter
                # will replace ds.query
                queryStub = ds.query
                added = @spy()
                removed = @spy()
                qa = new QueryAdapter(ds)
                
                # TODO: Should be able to just return this, but there is an error
                # in buster right now if we do.  When that's fixed, we can remove
                # the done() calls and just return a promise.
                qa.query().then(->
                    assert.calledOnce queryStub
                    return
                , fail).then done, done
                return

        add:
            'should add item to datasource': (done) ->
                ds = undefined
                qa = undefined
                item = undefined
                ds = @stub(createDatasource())
                ds.getIdentity.returns 1
                qa = new QueryAdapter(ds)
                item = id: 1
                qa.add(item).then(->
                    assert.calledOnceWith ds.add, item
                    return
                , fail).then done, done
                return

        remove:
            'should remove item from datasource': (done) ->
                ds = undefined
                qa = undefined
                item = undefined
                item = id: 1
                ds = @stub(createDatasource())
                ds.query.returns [item]
                ds.getIdentity.returns item.id
                qa = new QueryAdapter(ds)
                qa.query()
                qa.remove(item).then(->
                    assert.calledOnceWith ds.remove, item.id
                    return
                , fail).then done, done
                return

        update:
            'should update item in datasource': (done) ->
                ds = undefined
                qa = undefined
                item = undefined
                item = id: 1
                ds = @stub(createDatasource())
                ds.getIdentity.returns 1
                ds.query.returns [item]
                qa = new QueryAdapter(ds)
                qa.query()
                qa.update(item).then(->
                    assert.calledOnceWith ds.put, item
                    return
                , fail).then done, done
                return

        forEach:
            'should iterate over empty results before query': ->
                qa = undefined
                spy = undefined
                qa = new QueryAdapter(createDatasource())
                spy = @spy()
                qa.forEach spy
                refute.called spy
                return

            'should iterate when results are available': (done) ->
                ds = undefined
                qa = undefined
                spy = undefined
                ds = @stub(createDatasource())
                ds.query.returns promiseFor([id: 1])
                qa = new QueryAdapter(ds)
                spy = @spy()
                qa.query()
                qa.forEach(spy).then(->
                    assert.calledOnce spy
                    return
                , fail).then done, done
                return

        async:
            '// should have tests to assert that values returned from server update internal state': ->

            '// should have tests to assert that errors returned from server are handled': ->

    return
) require('buster'), require('when'), require('../../adapter/Query')