(function(buster, compose) {
  var addOne, addOneWithInverse, assert, refute;
  addOne = function(x) {
    return x + 1;
  };
  addOneWithInverse = function(x) {
    return addOne(x);
  };
  'use strict';
  assert = void 0;
  refute = void 0;
  assert = buster.assert;
  refute = buster.refute;
  addOneWithInverse.inverse = function(x) {
    return x - 1;
  };
  buster.testCase('transform/compose', {
    'should return identity if no input transforms provided': function() {
      var c;
      c = compose();
      assert.equals(1, c(1));
    },
    'should return identity inverse if no input transforms provided': function() {
      var c;
      c = compose();
      assert.equals(1, c.inverse(1));
    },
    'should compose a single function': function() {
      var c;
      c = compose(addOne);
      assert.equals(1, c(0));
    },
    'should compose a single function with inverse': function() {
      var c;
      c = compose(addOneWithInverse);
      assert.equals(0, c.inverse(1));
    },
    'should compose argument list of function': function() {
      var c;
      c = compose(addOne, addOne);
      assert.equals(2, c(0));
    },
    'should compose array of function': function() {
      var c;
      c = compose([addOne, addOne]);
      assert.equals(2, c(0));
    },
    'should compose mixed argument list and arrays of function': function() {
      var c;
      c = compose(addOne, [addOne, addOne], addOne);
      assert.equals(4, c(0));
    },
    'should compose inverse of mixed argument list and arrays of function': function() {
      var c;
      c = compose(addOneWithInverse, [addOneWithInverse, addOneWithInverse], addOneWithInverse);
      assert.equals(0, c.inverse(4));
    },
    'should compose varargs functions': function() {
      var c;
      c = compose(function(a) {
        return a;
      }, function(a, b, c) {
        return c;
      });
      assert.equals(3, c(1, 2, 3));
    },
    'should compose varargs inverse functions': function() {
      var c, f1, f2;
      f1 = void 0;
      f2 = void 0;
      f1 = function(a) {
        return a;
      };
      f1.inverse = function(a, b, c) {
        return c;
      };
      f2 = function(a, b, c) {
        return c;
      };
      f2.inverse = function(a) {
        return a;
      };
      c = compose(f1, f2);
      assert.equals(3, c.inverse(1, 2, 3));
    }
  });
})(require('buster'), require('../../transform/compose'));
