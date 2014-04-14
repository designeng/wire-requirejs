/*
MIT License (c) copyright B Cavalier & J Hann
*/

(function(define) {
  define(function(require) {
    var addClasses, classList, createFormValidationHandler, defaultFindNode, defaultInvalidClass, removeClasses;
    addClasses = function(node, cls) {
      classList.setClassList(node, cls);
    };
    removeClasses = function(node, cls) {
      classList.setClassList(node, {
        add: [],
        remove: cls
      });
    };
    defaultFindNode = function(form, fieldName) {
      var node;
      node = form.elements[fieldName];
      if (!node) {
        fieldName = fieldName.split('.');
        fieldName = fieldName[fieldName.length - 1];
        node = form.elements[fieldName];
      }
      return (node && node.parentNode) || node;
    };
    'use strict';
    classList = void 0;
    defaultInvalidClass = void 0;
    classList = require('../../dom/classList');
    defaultInvalidClass = 'invalid';
    return createFormValidationHandler = function(form, options) {
      var findNode, formValidationHandler, invalidClass, invalidFieldToNode;
      findNode = void 0;
      invalidClass = void 0;
      invalidFieldToNode = void 0;
      if (!options) {
        options = {};
      }
      findNode = options.findNode || defaultFindNode;
      invalidClass = ('invalidClass' in options ? options.invalidClass : defaultInvalidClass);
      invalidFieldToNode = {};
      return formValidationHandler = function(validationResults) {
        var classes, error, i, node;
        i = void 0;
        error = void 0;
        removeClasses(form, [invalidClass]);
        for (i in invalidFieldToNode) {
          removeClasses(invalidFieldToNode[i].node, invalidFieldToNode[i].classes);
        }
        if (validationResults.valid === false) {
          addClasses(form, [invalidClass]);
        }
        if (!validationResults.errors) {
          return;
        }
        i = 0;
        invalidFieldToNode = {};
        while ((error = validationResults.errors[i++])) {
          if (!(error.property in invalidFieldToNode)) {
            node = findNode(form, error.property);
            classes = [error.className || error.code];
            if (invalidClass) {
              classes.push(invalidClass);
            }
            if (node) {
              addClasses(node, classes);
              console.log("CLASSES", classes);
              invalidFieldToNode[error.property] = {
                node: node,
                classes: classes
              };
            }
          }
        }
        return validationResults;
      };
    };
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory(require);
}));
