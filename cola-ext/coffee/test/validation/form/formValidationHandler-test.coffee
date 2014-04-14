((buster, createFormValidationHandler) ->
    createFakeNode = ->
        className: ''
    createForm = ->
        elements: {}
        className: ''
    'use strict'
    assert = undefined
    refute = undefined
    fail = undefined
    assert = buster.assert
    refute = buster.refute
    fail = buster.assertions.fail
    validationObjectWithErrors = undefined
    validationObjectWithErrors =
        valid: false
        errors: [
            {
                property: 'test'
                code: 'test'
                message: 'test'
            }
            {
                property: 'test2'
                code: 'test2'
                className: 'class'
                message: 'test2'
            }
        ]

    buster.testCase 'validation/form/formValidationHandler',
        'should add invalid class to form': ->
            formValidationHandler = undefined
            form = undefined
            form = createForm()
            formValidationHandler = createFormValidationHandler(form)
            formValidationHandler valid: false
            assert.match form.className, /\binvalid\b/
            return

        'should add default and custom classes to associated node': ->
            formValidationHandler = undefined
            form = undefined
            node = undefined
            node2 = undefined
            form = createForm()
            node = createFakeNode()
            node2 = createFakeNode()
            formValidationHandler = createFormValidationHandler(form,
                findNode: (f, name) ->
                    (if name is 'test' then node else node2)
            )
            formValidationHandler validationObjectWithErrors
            assert.match node.className, /\binvalid\b/
            assert.match node2.className, /\binvalid\b/
            assert.match node.className, /\btest\b/
            assert.match node2.className, /\bclass\b/
            return

        'should remove classes from form when it becomes valid': ->
            formValidationHandler = undefined
            form = undefined
            node = undefined
            form = createForm()
            node = createFakeNode()
            formValidationHandler = createFormValidationHandler(form,
                findNode: ->
                    node
            )
            formValidationHandler validationObjectWithErrors
            assert.match form.className, /\binvalid\b/
            formValidationHandler valid: true
            refute.match form.className, /\binvalid\b/
            return

        'should remove classes from associated node when it becomes valid': ->
            formValidationHandler = undefined
            form = undefined
            node = undefined
            node2 = undefined
            form = createForm()
            node = createFakeNode()
            node2 = createFakeNode()
            formValidationHandler = createFormValidationHandler(form,
                findNode: (f, name) ->
                    (if name is 'test' then node else node2)
            )
            formValidationHandler validationObjectWithErrors
            assert.match node.className, /\binvalid\b/
            assert.match node.className, /\btest\b/
            assert.match node2.className, /\bclass\b/
            formValidationHandler valid: true
            refute.match node.className, /\binvalid\b/
            refute.match node.className, /\btest\b/
            refute.match node2.className, /\bclass\b/
            return

    return
) require('buster'), require('../../../validation/form/formValidationHandler')