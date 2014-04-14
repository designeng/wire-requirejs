(function(buster, require) {
  var assert, compare, fail, refute, reverse;
  compare = function(a, b) {
    return a - b;
  };
  assert = void 0;
  refute = void 0;
  fail = void 0;
  assert = buster.assert;
  refute = buster.refute;
  fail = buster.assertions.fail;
  reverse = require('../../comparator/reverse');
  buster.testCase('comparator/reverse', {
    'should return equality for equal items': function() {
      assert.equals(reverse(compare)(1, 1), 0);
    },
    'should return -1 for nested less': function() {
      assert.equals(reverse(compare)(1, 0), -1);
    },
    'should return 1 for nested less': function() {
      assert.equals(reverse(compare)(0, 1), 1);
    },
    'should throw if no comparators provided': function() {
      assert.exception(reverse);
    }
  });
})(require('buster'), require);
