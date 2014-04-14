(function(buster, require) {
  var assert, base, mockApi, refute, undef;
  assert = void 0;
  refute = void 0;
  undef = void 0;
  assert = buster.assert;
  refute = buster.refute;
  base = require('../../../network/strategy/base');
  mockApi = {
    isPropagating: function() {
      return true;
    },
    isHandled: function() {
      return false;
    }
  };
  buster.testCase('cola/network/strategy/base', {
    'should return function': function() {
      assert.isFunction(base());
    },
    'should\texecute method on dest adapter': function() {
      var dest, spy, strategy;
      spy = void 0;
      strategy = void 0;
      dest = void 0;
      spy = this.spy();
      strategy = base();
      dest = {
        anyEvent: spy
      };
      strategy(null, dest, {}, 'anyEvent', mockApi);
      assert.calledOnce(spy);
    },
    'should not execute method on dest adapter if method doesn\'t exist': function() {
      var dest, spy, strategy;
      spy = void 0;
      strategy = void 0;
      dest = void 0;
      spy = this.spy();
      strategy = base();
      dest = {};
      strategy(null, dest, {}, 'anyEvent', mockApi);
      refute.calledOnce(spy);
    },
    'should throw if non-method with event name exists on dest adapter': function() {
      var dest, ex, spy, strategy;
      spy = void 0;
      strategy = void 0;
      dest = void 0;
      spy = this.spy();
      strategy = base();
      dest = {
        anyProp: 1
      };
      try {
        strategy(null, dest, {}, 'anyProp', mockApi);
        refute(true);
      } catch (_error) {
        ex = _error;
        assert(true);
      }
    }
  });
})(require('buster'), require);
