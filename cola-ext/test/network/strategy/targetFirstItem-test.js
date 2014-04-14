(function(buster, require) {
  var assert, refute, targetFirstItem, undef;
  assert = void 0;
  refute = void 0;
  undef = void 0;
  assert = buster.assert;
  refute = buster.refute;
  targetFirstItem = require('../../../network/strategy/targetFirstItem');
  buster.testCase('targetFirstItem', {
    'should return function': function() {
      assert.isFunction(targetFirstItem([]));
    },
    'should call queueEvent once': function() {
      var api, data, qspy, src, strategy;
      qspy = void 0;
      src = void 0;
      data = void 0;
      api = void 0;
      strategy = void 0;
      qspy = this.spy();
      src = {};
      data = {};
      api = {
        isBefore: function() {
          return true;
        },
        queueEvent: qspy
      };
      strategy = targetFirstItem();
      strategy(src, null, data, 'add', api);
      strategy(src, null, data, 'add', api);
      assert.calledOnceWith(qspy, src, data, 'target');
      qspy = api.queueEvent = this.spy();
      strategy(src, null, data, 'sync', api);
      strategy(src, null, data, 'add', api);
      strategy(src, null, data, 'add', api);
      assert.calledOnceWith(qspy, src, data, 'target');
    }
  });
})(require('buster'), require);
