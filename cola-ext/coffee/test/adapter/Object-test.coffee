((buster, when_, delay, ObjectAdapter) ->
    promiseFor = (it) ->
        delay it, 0
    'use strict'
    assert = undefined
    refute = undefined
    fail = undefined
    assert = buster.assert
    refute = buster.refute
    fail = buster.assertions.fail
    buster.testCase 'adapter/Object',
        options:
            'should pass options to getOptions': ->
                bindings = {}
                adaptedObject = undefined
                adaptedObject = new ObjectAdapter({},
                    bindings: bindings
                )
                assert.equals bindings, adaptedObject.getOptions().bindings
                return

        canHandle:
            'should return true for a object literals': ->
                assert ObjectAdapter.canHandle({}), 'object'
                return

            'should return true for a promise': ->
                assert ObjectAdapter.canHandle(promiseFor({}))
                return

            'should return false for non-object literals': ->
                refute ObjectAdapter.canHandle(), 'undefined'
                refute ObjectAdapter.canHandle(null), 'null'
                refute ObjectAdapter.canHandle(->
                ), 'function'
                refute ObjectAdapter.canHandle([]), 'array'
                return

        update:
            'should update an object when update() called': ->
                obj = undefined
                adapted = undefined
                obj =
                    first: 'Fred'
                    last: 'Flintstone'

                adapted = new ObjectAdapter(obj)
                adapted.update
                    first: 'Donna'
                    last: 'Summer'

                assert.equals adapted._obj.first, 'Donna'
                assert.equals adapted._obj.last, 'Summer'
                return

            'should update some properties when update() called with a partial': ->
                obj = undefined
                adapted = undefined
                obj =
                    first: 'Fred'
                    last: 'Flintstone'

                adapted = new ObjectAdapter(obj)
                adapted.update last: 'Astaire'
                assert.equals adapted._obj.first, 'Fred'
                assert.equals adapted._obj.last, 'Astaire'
                return

            'promise-aware':
                'should update an object': (done) ->
                    obj = undefined
                    adapted = undefined
                    obj =
                        first: 'Fred'
                        last: 'Flintstone'

                    adapted = new ObjectAdapter(promiseFor(obj))
                    when_(adapted.update(
                        first: 'Donna'
                        last: 'Summer'
                    ), ->
                        when_ adapted._obj, (obj) ->
                            assert.equals obj.first, 'Donna'
                            assert.equals obj.last, 'Summer'
                            return

                    , fail).then done, done
                    return

                'should update supplied properties when called with a partial': (done) ->
                    obj = undefined
                    adapted = undefined
                    obj =
                        first: 'Fred'
                        last: 'Flintstone'

                    adapted = new ObjectAdapter(promiseFor(obj))
                    when_(adapted.update(last: 'Astaire'), ->
                        when_ adapted._obj, (obj) ->
                            assert.equals obj.first, 'Fred'
                            assert.equals obj.last, 'Astaire'
                            return

                    , fail).then done, done
                    return

    return
) require('buster'), require('when'), require('when/delay'), require('../../adapter/Object')