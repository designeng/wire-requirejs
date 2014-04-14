(function(buster, require) {
  var assert, def, refute, undef;
  assert = void 0;
  refute = void 0;
  undef = void 0;
  assert = buster.assert;
  refute = buster.refute;
  def = require('../../../network/strategy/default');
  buster.testCase('cola/network/strategy/default', {
    'should return function': function() {
      assert.isFunction(def([]));
    },
    '// should have more tests': function() {
      assert(false);
    }
  });
})(require('buster'), require);
