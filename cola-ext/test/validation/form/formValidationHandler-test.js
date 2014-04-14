(function(buster, createFormValidationHandler) {
  var assert, createFakeNode, createForm, fail, refute, validationObjectWithErrors;
  createFakeNode = function() {
    return {
      className: ''
    };
  };
  createForm = function() {
    return {
      elements: {},
      className: ''
    };
  };
  'use strict';
  assert = void 0;
  refute = void 0;
  fail = void 0;
  assert = buster.assert;
  refute = buster.refute;
  fail = buster.assertions.fail;
  validationObjectWithErrors = void 0;
  validationObjectWithErrors = {
    valid: false,
    errors: [
      {
        property: 'test',
        code: 'test',
        message: 'test'
      }, {
        property: 'test2',
        code: 'test2',
        className: 'class',
        message: 'test2'
      }
    ]
  };
  buster.testCase('validation/form/formValidationHandler', {
    'should add invalid class to form': function() {
      var form, formValidationHandler;
      formValidationHandler = void 0;
      form = void 0;
      form = createForm();
      formValidationHandler = createFormValidationHandler(form);
      formValidationHandler({
        valid: false
      });
      assert.match(form.className, /\binvalid\b/);
    },
    'should add default and custom classes to associated node': function() {
      var form, formValidationHandler, node, node2;
      formValidationHandler = void 0;
      form = void 0;
      node = void 0;
      node2 = void 0;
      form = createForm();
      node = createFakeNode();
      node2 = createFakeNode();
      formValidationHandler = createFormValidationHandler(form, {
        findNode: function(f, name) {
          if (name === 'test') {
            return node;
          } else {
            return node2;
          }
        }
      });
      formValidationHandler(validationObjectWithErrors);
      assert.match(node.className, /\binvalid\b/);
      assert.match(node2.className, /\binvalid\b/);
      assert.match(node.className, /\btest\b/);
      assert.match(node2.className, /\bclass\b/);
    },
    'should remove classes from form when it becomes valid': function() {
      var form, formValidationHandler, node;
      formValidationHandler = void 0;
      form = void 0;
      node = void 0;
      form = createForm();
      node = createFakeNode();
      formValidationHandler = createFormValidationHandler(form, {
        findNode: function() {
          return node;
        }
      });
      formValidationHandler(validationObjectWithErrors);
      assert.match(form.className, /\binvalid\b/);
      formValidationHandler({
        valid: true
      });
      refute.match(form.className, /\binvalid\b/);
    },
    'should remove classes from associated node when it becomes valid': function() {
      var form, formValidationHandler, node, node2;
      formValidationHandler = void 0;
      form = void 0;
      node = void 0;
      node2 = void 0;
      form = createForm();
      node = createFakeNode();
      node2 = createFakeNode();
      formValidationHandler = createFormValidationHandler(form, {
        findNode: function(f, name) {
          if (name === 'test') {
            return node;
          } else {
            return node2;
          }
        }
      });
      formValidationHandler(validationObjectWithErrors);
      assert.match(node.className, /\binvalid\b/);
      assert.match(node.className, /\btest\b/);
      assert.match(node2.className, /\bclass\b/);
      formValidationHandler({
        valid: true
      });
      refute.match(node.className, /\binvalid\b/);
      refute.match(node.className, /\btest\b/);
      refute.match(node2.className, /\bclass\b/);
    }
  });
})(require('buster'), require('../../../validation/form/formValidationHandler'));
