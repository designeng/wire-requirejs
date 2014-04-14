(function(buster, require) {
  var FakeAdapter, FakeApi, assert, refute, syncDataDirectly, undef;
  FakeApi = function(phase) {
    return {
      phase: phase,
      isBefore: function() {
        return this.phase === 'before';
      }
    };
  };
  FakeAdapter = function() {
    return {
      add: function() {},
      forEach: function() {}
    };
  };
  assert = void 0;
  refute = void 0;
  undef = void 0;
  assert = buster.assert;
  refute = buster.refute;
  syncDataDirectly = require('../../../network/strategy/syncDataDirectly');
  buster.testCase('cola/network/strategy/syncDataDirectly', {
    'should return a function': function() {
      assert.isFunction(syncDataDirectly());
    },
    'should always cancel a "sync"': function() {
      var api, strategy;
      strategy = syncDataDirectly();
      api = new FakeApi('before');
      api.cancel = this.spy();
      strategy(new FakeAdapter(), new FakeAdapter(), {}, 'sync', api);
      assert.called(api.cancel);
    },
    '// should have more tests': function() {
      assert(false);
    }
  });
})(require('buster'), require);
