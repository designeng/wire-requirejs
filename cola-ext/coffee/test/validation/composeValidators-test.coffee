((buster, composeValidators) ->
    assert = undefined
    refute = undefined
    fail = undefined
    assert = buster.assert
    refute = buster.refute
    fail = buster.assertions.fail
    buster.testCase 'validation/composeValidators',
        'should call each validator': ->
            v1 = undefined
            v2 = undefined
            v3 = undefined
            object = undefined
            v1 = @spy()
            v2 = @spy()
            v3 = @spy()
            object = {}
            composeValidators([
                v1
                v2
                v3
            ]) object
            assert.calledOnceWith v1, object
            assert.calledOnceWith v2, object
            assert.calledOnceWith v3, object
            return

        'should merge errors': ->
            v1 = undefined
            v2 = undefined
            v3 = undefined
            result = undefined
            v1 = @stub().returns(valid: true)
            v2 = @stub().returns(
                valid: false
                errors: [1]
            )
            v3 = @stub().returns(
                valid: false
                errors: [2]
            )
            result = composeValidators([
                v1
                v2
                v3
            ])({})
            assert.equals result,
                valid: false
                errors: [
                    1
                    2
                ]

            return

        'should pass when all validators pass': ->
            v1 = undefined
            v2 = undefined
            result = undefined
            v1 = @stub().returns(valid: true)
            v2 = @stub().returns(valid: true)
            result = composeValidators([
                v1
                v2
            ])({})
            assert.equals result,
                valid: true

            return

        'should fail when at least one validator fails': ->
            v1 = undefined
            v2 = undefined
            v3 = undefined
            result = undefined
            v1 = @stub().returns(valid: true)
            v2 = @stub().returns(valid: false)
            v3 = @stub().returns(valid: false)
            result = composeValidators([
                v1
                v2
                v3
            ])({})
            assert.equals result,
                valid: false

            return

    return
) require('buster'), require('../../validation/composeValidators')