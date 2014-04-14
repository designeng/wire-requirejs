((define) ->
    define ->
        'use strict'
        formNodeRx = /^form$/i
        
        ###
        Simple function to find a form element.
        @param rootNode {HTMLElement} form node to search under
        @param nodeName {String} form element to find
        @return {HTMLElement}
        ###
        formElementFinder = (rootNode, nodeName) ->
            
            # use form.elements if this is a form
            rootNode.elements[nodeName]    if rootNode.elements and rootNode.elements.length

    return
) (if typeof define is 'function' and define.amd then define else (factory) ->
    module.exports = factory()
    return
)