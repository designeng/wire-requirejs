(function(buster, require) {
  var assert, compose, eq, fail, gt, lt, refute;
  lt = function() {
    return -1;
  };
  gt = function() {
    return 1;
  };
  eq = function() {
    return 0;
  };
  assert = void 0;
  refute = void 0;
  fail = void 0;
  assert = buster.assert;
  refute = buster.refute;
  fail = buster.assertions.fail;
  compose = require('../../comparator/compose');
  buster.testCase('comparator/compose', {
    'should return equality for equal items': function() {
      assert.equals(compose(eq, eq)(), 0);
    },
    'should return -1 for nested less': function() {
      assert.equals(compose(eq, lt)(), -1);
    },
    'should return 1 for nested less': function() {
      assert.equals(compose(eq, gt)(), 1);
    },
    'should throw if no comparators provided': function() {
      assert.exception(compose);
    }
  });
})(require('buster'), require);
