((buster, LocalStorageAdapter) ->
    identifier = (item) ->
        item.id
    fakeLocalStorage = ->
        items: {}
        setItem: (key, val) ->
            @items[key] = val
            return

        getItem: (key) ->
            @items[key]

        removeItem: (key) ->
            delete @items[key]

            return
    assert = undefined
    refute = undefined
    fail = undefined
    assert = buster.assert
    refute = buster.refute
    fail = buster.assertions.fail
    buster.testCase 'adapter/LocalStorage',
        'should throw when namespace not provided': ->
            assert.exception ->
                new LocalStorageAdapter()
                return

            return

        'should throw when localStorage not available and not provided in options': ->
            assert.exception ->
                new LocalStorageAdapter('fail')
                return

            return

        forEach:
            'should iterate over zero items when empty': ->
                storage = undefined
                a = undefined
                count = undefined
                storage = fakeLocalStorage()
                a = new LocalStorageAdapter('test',
                    localStorage: storage
                    identifier: identifier
                )
                count = 0
                a.forEach ->
                    ++count
                    return

                assert.equals count, 0
                return

            'should iterate over all items': ->
                storage = undefined
                a = undefined
                count = undefined
                storage = fakeLocalStorage()
                a = new LocalStorageAdapter('test',
                    localStorage: storage
                    identifier: identifier
                )
                a.add id: 1
                a.add id: 2
                a.add id: 3
                count = 0
                a.forEach ->
                    ++count
                    return

                assert.equals count, 3
                return

        add:
            'should add items': ->
                storage = undefined
                a = undefined
                count = undefined
                storage = fakeLocalStorage()
                a = new LocalStorageAdapter('test',
                    localStorage: storage
                    identifier: identifier
                )
                a.add id: 1
                count = 0
                a.forEach (item) ->
                    ++count
                    assert.equals item,
                        id: 1

                    return

                assert.equals count, 1
                return

        update:
            'should update items': ->
                storage = undefined
                a = undefined
                count = undefined
                storage = fakeLocalStorage()
                a = new LocalStorageAdapter('test',
                    localStorage: storage
                    identifier: identifier
                )
                a.add id: 1
                a.update
                    id: 1
                    success: true

                count = 0
                a.forEach (item) ->
                    ++count
                    assert item.success
                    return

                assert.equals count, 1
                return

        remove:
            'should remove items': ->
                storage = undefined
                a = undefined
                count = undefined
                storage = fakeLocalStorage()
                a = new LocalStorageAdapter('test',
                    localStorage: storage
                    identifier: identifier
                )
                a.add id: 1
                count = 0
                a.forEach (item) ->
                    ++count
                    assert.equals item,
                        id: 1

                    return

                assert.equals count, 1
                a.remove id: 1
                count = 0
                a.forEach ->
                    ++count
                    return

                assert.equals count, 0
                return

    return
) require('buster'), require('../../adapter/LocalStorage')