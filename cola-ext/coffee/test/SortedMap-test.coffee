((buster, SortedMap) ->
    compareItems = (a, b) ->
        a.id - b.id
    compareByLast = (a, b) ->
        (if a.last < b.last then -1 else (if a.last > b.last then 1 else 0))
    symbolizeItem = (it) ->
        it.id
    assert = undefined
    refute = undefined
    undef = undefined
    assert = buster.assert
    refute = buster.refute
    buster.testCase 'SortedMap',
        add:
            'should throw if key and value not provided': ->
                map = new SortedMap(symbolizeItem, compareItems)
                assert.exception ->
                    map.add id: 1
                    return

                return

            'should add new items': ->
                hash = new SortedMap(symbolizeItem, compareItems)
                assert.equals hash.add(
                    id: 1
                , 1), 0
                assert.equals hash.add(
                    id: 2
                , 2), 1
                spy = @spy()
                hash.forEach spy
                assert.calledTwice spy
                return

            'should add very large item into last slot': ->
                hash = new SortedMap(symbolizeItem, compareItems)
                assert.equals hash.add(
                    id: 1
                , 1), 0
                assert.equals hash.add(
                    id: 9
                , 9), 1
                assert.equals hash.add(
                    id: 99
                , 99), 2
                assert.equals hash.add(
                    id: 999
                , 999), 3
                return

            'should fail silently when adding an item that already exists': ->
                hash = new SortedMap(symbolizeItem, compareItems)
                hash.add
                    id: 1
                , 1
                refute.defined hash.add(
                    id: 1
                , 1)
                return

            'should add all items even when no comparator supplied': ->
                map = undefined
                count = undefined
                result = undefined
                map = new SortedMap(symbolizeItem)
                assert.equals map.add(
                    id: 0
                , 0), 0
                assert.equals map.add(
                    id: 1
                , 1), 1
                assert.equals map.add(
                    id: 2
                , 2), 2
                count = 0
                result = 0
                map.forEach (item) ->
                    count++
                    result += item
                    return

                assert.equals count, 3
                assert.equals result, 3
                return

            'should add all items even when comparator says all items are equivalent': ->
                map = undefined
                count = undefined
                result = undefined
                map = new SortedMap(symbolizeItem, ->
                    0
                )
                assert.equals map.add(
                    id: 0
                , 0), 0
                assert.equals map.add(
                    id: 1
                , 1), 1
                assert.equals map.add(
                    id: 2
                , 2), 2
                count = 0
                result = 0
                map.forEach (item) ->
                    count++
                    result += item
                    return

                assert.equals count, 3
                assert.equals result, 3
                return

        remove:
            'should remove items': ->
                map = new SortedMap(symbolizeItem, compareItems)
                items = [
                    {
                        id: 1
                    }
                    {
                        id: 3
                    }
                    {
                        id: 4
                    }
                    {
                        id: 2
                    }
                ]
                map.add items[0], 'foo' # id: 1
                map.add items[1], 'bar' # id: 3
                map.add items[2], 'baz' # id: 4
                map.add items[3], 'fot' # id: 2
                map.remove id: 3
                spy = @spy()
                map.forEach spy
                assert.calledWith spy, 'foo', items[0]
                refute.calledWith spy, 'bar', items[1]
                assert.calledWith spy, 'baz', items[2]
                assert.calledWith spy, 'fot', items[3]
                return

            'should silently fail when removing non-existent items': ->
                map = new SortedMap(symbolizeItem, compareItems)
                map.add
                    id: 1
                , 1
                refute.defined map.remove(id: 2)
                return

        clear:
            'should remove all items': ->
                map = new SortedMap(symbolizeItem, compareItems)
                map.add
                    id: 1
                , 1
                map.add
                    id: 2
                , 2
                map.add
                    id: 3
                , 3
                map.clear()
                refute.defined map.get(id: 1)
                refute.defined map.get(id: 2)
                refute.defined map.get(id: 3)
                spy = @spy()
                map.forEach spy
                refute.called spy
                return

        forEach:
            'should iterate over all items in order': ->
                map = new SortedMap(symbolizeItem, compareByLast)
                map.add
                    id: 1
                    last: 'Attercop'
                    expected: 2
                , 1
                map.add
                    id: 3
                    last: 'TomNoddy'
                    expected: 4
                , 2
                map.add
                    id: 4
                    last: 'Aardvark'
                    expected: 1
                , 3
                map.add
                    id: 2
                    last: 'Bojangle'
                    expected: 3
                , 4
                count = 0
                prev = 0
                map.forEach (value, key) ->
                    count++
                    
                    # cheap test to see if they're in order
                    assert.equals key.expected - prev, 1
                    prev = key.expected
                    return

                assert count is 4
                return

    return
) require('buster'), require('../SortedMap')