(function(buster, configure) {
  'use strict';
  var assert, refute;
  assert = void 0;
  refute = void 0;
  assert = buster.assert;
  refute = buster.refute;
  buster.testCase('transform/configure', {
    'should return a function': function() {
      assert.isFunction(configure(function() {}));
    },
    'should not return an inverse when input does not have an inverse': function() {
      refute.defined(configure(function() {}).inverse);
    },
    'should return an inverse when input has an inverse': function() {
      var t;
      t = function() {};
      t.inverse = function() {};
      assert.isFunction(configure(t).inverse);
    },
    'should pass all configured parameters through to resulting function': function() {
      var c, t;
      t = void 0;
      c = void 0;
      t = this.spy();
      c = configure(t, 1, 2, 3);
      c('a', 'b', 'c');
      assert.calledOnceWith(t, 'a', 'b', 'c', 1, 2, 3);
    },
    'should pass all configured parameters through to resulting inverse': function() {
      var c, t;
      t = function() {};
      t.inverse = this.spy();
      c = configure(t, 1, 2, 3);
      c.inverse('a', 'b', 'c');
      assert.calledOnceWith(t.inverse, 'a', 'b', 'c', 1, 2, 3);
    }
  });
})(require('buster'), require('../../transform/configure'));
