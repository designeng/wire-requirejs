###
MIT License (c) copyright B Cavalier & J Hann
###
((define) ->
    define (require) ->
        
        # Simple approach:
        # for each field name, find an associated node on which
        # to apply a validation class name.
        
        # Clear previously invalidated nodes first
        
        # Invalidate the form if results are invalid
        
        # Then, add invalid class to each field that is
        # now invalid
        
        # TODO: change this to support more than one error per node
        
        # Since this only applies a single invalid class
        # we can skip multiple errors on the same field
        addClasses = (node, cls) ->
            classList.setClassList node, cls
            return
        removeClasses = (node, cls) ->
            classList.setClassList node,
                add: []
                remove: cls

            return
        defaultFindNode = (form, fieldName) ->
            node = form.elements[fieldName]
            unless node
                fieldName = fieldName.split('.')
                fieldName = fieldName[fieldName.length - 1]
                node = form.elements[fieldName]
            
            # TODO: just return node as the default behavior
            (node and node.parentNode) or node
        'use strict'
        classList = undefined
        defaultInvalidClass = undefined
        classList = require('../../dom/classList')
        defaultInvalidClass = 'invalid'
        return createFormValidationHandler = (form, options) ->
            findNode = undefined
            invalidClass = undefined
            invalidFieldToNode = undefined
            options = {}    unless options
            findNode = options.findNode or defaultFindNode
            invalidClass = (if 'invalidClass' of options then options.invalidClass else defaultInvalidClass)
            invalidFieldToNode = {}
            formValidationHandler = (validationResults) ->
                i = undefined
                error = undefined
                removeClasses form, [invalidClass]
                for i of invalidFieldToNode
                    removeClasses invalidFieldToNode[i].node, invalidFieldToNode[i].classes
                addClasses form, [invalidClass]    if validationResults.valid is false
                return    unless validationResults.errors
                i = 0
                invalidFieldToNode = {}
                while (error = validationResults.errors[i++])
                    unless error.property of invalidFieldToNode
                        node = findNode(form, error.property)
                        classes = [error.className or error.code]
                        classes.push invalidClass    if invalidClass
                        if node
                            addClasses node, classes
                            console.log "CLASSES", classes 
                            invalidFieldToNode[error.property] =
                                node: node
                                classes: classes
                validationResults

        return

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)