((buster, when_, delay, makeTransformed) ->
    createFakeAdapter = (data) ->
        data = data or []
        add: (item) ->

        remove: (item) ->

        update: (item) ->

        clear: ->

        forEach: (f) ->
            i = 0
            len = data.length

            while i < len
                f data[i]
                i++
            return

        getOptions: ->
    resolved = (val) ->
        delay val, 0
    makePromised = (f) ->
        promised = (x) ->
            resolved f(x)
        if f.inverse
            promised.inverse = (x) ->
                resolved f.inverse(x)
        promised
    addOne = (x) ->
        x + 1
    addOneWithInverse = (x) ->
        addOne x
    'use strict'
    assert = undefined
    refute = undefined
    fail = undefined
    assert = buster.assert
    refute = buster.refute
    fail = buster.assertions.fail
    addOneWithInverse.inverse = (x) ->
        x - 1

    buster.testCase 'adapter/makeTransformed',
        'should throw if no transform provided': ->
            assert.exception ->
                makeTransformed createFakeAdapter()
                return

            return

        'should not modify original adapter': ->
            adapter = undefined
            p = undefined
            originals = undefined
            originals = {}
            adapter = createFakeAdapter()
            for p of adapter
                originals[p] = adapter[p]
            makeTransformed adapter, addOneWithInverse
            for p of adapter
                assert.same adapter[p], originals[p]
            return

        'should preserve original comparator': ->
            comparator = ->
            adapter = undefined
            transformed = undefined
            adapter = createFakeAdapter()
            adapter.comparator = comparator
            transformed = makeTransformed(adapter, addOneWithInverse)
            assert.same transformed.comparator, comparator
            return

        'should preserve original identifier': ->
            identifier = ->
            adapter = undefined
            transformed = undefined
            adapter = createFakeAdapter()
            adapter.identifier = identifier
            transformed = makeTransformed(adapter, addOneWithInverse)
            assert.same transformed.identifier, identifier
            return

        getOptions:
            'should return original adapter options': ->
                adapter = undefined
                transformed = undefined
                options = undefined
                options = {}
                adapter = @stub(createFakeAdapter())
                transformed = makeTransformed(adapter, addOneWithInverse)
                adapter.getOptions.returns options
                assert.same transformed.getOptions(), options
                return

        forEach:
            'should delegate with transformed value': ->
                adapter = undefined
                transformed = undefined
                lambda = undefined
                adapter = createFakeAdapter([1])
                transformed = makeTransformed(adapter, addOne)
                lambda = @spy()
                transformed.forEach lambda
                assert.calledOnceWith lambda, 2
                return

            'should allow promised transforms': (done) ->
                adapter = undefined
                transformed = undefined
                lambda = undefined
                results = undefined
                adapter = createFakeAdapter([
                    1
                    2
                    3
                ])
                transformed = makeTransformed(adapter, makePromised(addOne))
                results = []
                lambda = (val) ->
                    results.push val
                    return

                when_(transformed.forEach(lambda), ->
                    assert.equals results, [
                        2
                        3
                        4
                    ]
                    return
                , fail).then done, done
                return

        add:
            'should call original with inverse transformed item': ->
                adapter = undefined
                transformed = undefined
                adapter = @stub(createFakeAdapter())
                transformed = makeTransformed(adapter, addOneWithInverse)
                transformed.add 1
                assert.calledOnceWith adapter.add, 0
                return

            'should allow promised transforms': (done) ->
                adapter = undefined
                transformed = undefined
                adapter = @stub(createFakeAdapter())
                transformed = makeTransformed(adapter, makePromised(addOneWithInverse))
                when_(transformed.add(1), ->
                    assert.calledOnceWith adapter.add, 0
                    return
                , fail).then done, done
                return

        remove:
            'should call original with inverse transformed item': ->
                adapter = undefined
                transformed = undefined
                adapter = @stub(createFakeAdapter())
                transformed = makeTransformed(adapter, addOneWithInverse)
                transformed.remove 1
                assert.calledOnceWith adapter.remove, 0
                return

            'should allow promised transforms': (done) ->
                adapter = undefined
                transformed = undefined
                adapter = @stub(createFakeAdapter())
                transformed = makeTransformed(adapter, makePromised(addOneWithInverse))
                when_(transformed.remove(1), ->
                    assert.calledOnceWith adapter.remove, 0
                    return
                , fail).then done, done
                return

        update:
            'should call original with inverse transformed item': ->
                adapter = undefined
                transformed = undefined
                adapter = @stub(createFakeAdapter())
                transformed = makeTransformed(adapter, addOneWithInverse)
                transformed.update 1
                assert.calledOnceWith adapter.update, 0
                return

            'should allow promised transforms': (done) ->
                adapter = undefined
                transformed = undefined
                adapter = @stub(createFakeAdapter())
                transformed = makeTransformed(adapter, makePromised(addOneWithInverse))
                when_(transformed.update(1), ->
                    assert.calledOnceWith adapter.update, 0
                    return
                , fail).then done, done
                return

        clear:
            'should call original clear': ->
                adapter = undefined
                transformed = undefined
                adapter = @stub(createFakeAdapter())
                transformed = makeTransformed(adapter, addOneWithInverse)
                transformed.clear()
                assert.calledOnce adapter.clear
                return

    return
) require('buster'), require('when'), require('when/delay'), require('../../adapter/makeTransformed')