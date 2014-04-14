((buster, when_, delay, ArrayAdapter) ->
    promiseFor = (array) ->
        delay array, 0
    assert = undefined
    refute = undefined
    undef = undefined
    assert = buster.assert
    refute = buster.refute
    buster.testCase 'adapter/Array',
        canHandle:
            'should return true for an Array': ->
                assert ArrayAdapter.canHandle([])
                return

            'should return true for a promise': ->
                assert ArrayAdapter.canHandle(when_.defer().promise)
                return

            'should return false for a non-Array': ->
                refute ArrayAdapter.canHandle(null)
                refute ArrayAdapter.canHandle(undef)
                refute ArrayAdapter.canHandle(0)
                refute ArrayAdapter.canHandle(true)
                refute ArrayAdapter.canHandle(length: 1)
                return

        options:
            'should be a provider by default': ->
                a = new ArrayAdapter([])
                assert a.provide
                return

            'should allow overriding provide': ->
                a = new ArrayAdapter([],
                    provide: false
                )
                refute a.provide
                return

        forEach:
            'should iterate over all items': ->
                src = undefined
                forEachSpy = undefined
                src = new ArrayAdapter([
                    {
                        id: 1
                    }
                    {
                        id: 2
                    }
                ])
                forEachSpy = @spy()
                src.forEach forEachSpy
                assert.calledTwice forEachSpy
                assert.calledWith forEachSpy,
                    id: 1

                assert.calledWith forEachSpy,
                    id: 2

                return

            'should iterate over all promised items': (done) ->
                src = undefined
                forEachSpy = undefined
                src = new ArrayAdapter(promiseFor([
                    {
                        id: 1
                    }
                    {
                        id: 2
                    }
                ]))
                forEachSpy = @spy()
                src.forEach(forEachSpy).then ->
                    assert.calledTwice forEachSpy
                    assert.calledWith forEachSpy,
                        id: 1

                    assert.calledWith forEachSpy,
                        id: 2

                    done()
                    return

                return

        add:
            'should add new items': ->
                pa = new ArrayAdapter([id: 1])
                pa.add id: 2
                spy = @spy()
                pa.forEach spy
                assert.calledTwice spy
                return

            'should allow adding an item that already exists': ->
                pa = new ArrayAdapter([id: 1])
                spy = @spy()
                pa.forEach spy
                assert.calledOnce spy
                return

            'promise-aware':
                'should add new items': (done) ->
                    pa = undefined
                    spy = undefined
                    pa = new ArrayAdapter(promiseFor([id: 1]))
                    spy = @spy()
                    when_(pa.add(id: 2), ->
                        pa.forEach spy
                    ).then(->
                        assert.calledTwice spy
                        return
                    ).then done, done
                    return

                'should allow adding an item that already exists': (done) ->
                    pa = undefined
                    spy = undefined
                    pa = new ArrayAdapter(promiseFor([id: 1]))
                    spy = @spy()
                    when_(pa.add(id: 1), ->
                        pa.forEach spy
                    ).then(->
                        assert.calledOnce spy
                        return
                    ).then done, done
                    return

        remove:
            'should remove items': ->
                pa = new ArrayAdapter([
                    {
                        id: 1
                    }
                    {
                        id: 2
                    }
                ])
                pa.remove id: 1
                spy = @spy()
                pa.forEach spy
                assert.calledOnce spy
                return

            'should allow removing non-existent items': ->
                pa = new ArrayAdapter([])
                spy = @spy()
                pa.forEach spy
                refute.called spy
                return

            'promise-aware':
                'should remove items': (done) ->
                    pa = undefined
                    spy = undefined
                    pa = new ArrayAdapter(promiseFor([
                        {
                            id: 1
                        }
                        {
                            id: 2
                        }
                    ]))
                    spy = @spy()
                    when_(pa.remove(id: 2), ->
                        pa.forEach spy
                    ).then(->
                        assert.calledOnce spy
                        return
                    ).then done, done
                    return

                'should allow removing non-existent items': (done) ->
                    pa = undefined
                    spy = undefined
                    pa = new ArrayAdapter(promiseFor([]))
                    spy = @spy()
                    when_(pa.remove(id: 2), ->
                        pa.forEach spy
                    ).then(->
                        refute.calledOnce spy
                        return
                    ).then done, done
                    return

        update:
            'should update items': ->
                pa = new ArrayAdapter([
                    id: 1
                    success: false
                ])
                spy = @spy()
                pa.update
                    id: 1
                    success: true

                pa.forEach spy
                assert.calledOnceWith spy,
                    id: 1
                    success: true

                return

            'should ignore updates to non-existent items': ->
                pa = new ArrayAdapter([
                    id: 1
                    success: true
                ])
                spy = @spy()
                pa.update
                    id: 2
                    success: false

                pa.forEach spy
                assert.calledOnceWith spy,
                    id: 1
                    success: true

                return

            'promise-aware':
                'should update items': (done) ->
                    pa = undefined
                    spy = undefined
                    expected = undefined
                    pa = new ArrayAdapter(promiseFor([
                        id: 1
                        success: false
                    ]))
                    spy = @spy()
                    expected =
                        id: 1
                        success: true

                    when_(pa.update(expected), ->
                        pa.forEach spy
                    ).then(->
                        assert.calledOnceWith spy, expected
                        return
                    ).then done, done
                    return

                'should ignore updates to non-existent items': (done) ->
                    pa = undefined
                    spy = undefined
                    expected = undefined
                    expected =
                        id: 1
                        success: true

                    pa = new ArrayAdapter(promiseFor([expected]))
                    spy = @spy()
                    when_(pa.update(
                        id: 2
                        success: false
                    ), ->
                        pa.forEach spy
                    ).then(->
                        assert.calledOnceWith spy, expected
                        return
                    ).then done, done
                    return

        clear:
            'should remove all items': ->
                src = undefined
                forEachSpy = undefined
                src = new ArrayAdapter([
                    {
                        id: 1
                    }
                    {
                        id: 2
                    }
                ])
                forEachSpy = @spy()
                src.clear()
                src.forEach forEachSpy
                refute.called forEachSpy
                return

            'promise-aware':
                'should remove all items': (done) ->
                    src = undefined
                    forEachSpy = undefined
                    src = new ArrayAdapter(promiseFor([
                        {
                            id: 1
                        }
                        {
                            id: 2
                        }
                    ]))
                    forEachSpy = @spy()
                    when_(src.clear(), ->
                        src.forEach forEachSpy
                    ).then(->
                        refute.called forEachSpy
                        return
                    ).then done, done
                    return

    return
) require('buster'), require('when'), require('when/delay'), require('../../adapter/Array')