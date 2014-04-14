((buster, when_, delay, WidenAdapter) ->
    assert = undefined
    refute = undefined
    assert = buster.assert
    refute = buster.refute
    buster.testCase 'adapter/ObjectToArray',
        'should throw if transform not supplied': ->
            assert.exception ->
                new WidenAdapter({})
                return

            return

        forEach:
            'should iterate over all items': ->
                a = undefined
                spy = undefined
                a = new WidenAdapter(
                    array: [
                        {
                            id: 1
                        }
                        {
                            id: 2
                        }
                    ]
                ,
                    transform: (o) ->
                        o.array
                )
                spy = @spy()
                a.forEach spy
                assert.calledTwice spy
                assert.calledWith spy,
                    id: 1

                assert.calledWith spy,
                    id: 2

                return

    return
) require('buster'), require('when'), require('when/delay'), require('../../adapter/ObjectToArray')