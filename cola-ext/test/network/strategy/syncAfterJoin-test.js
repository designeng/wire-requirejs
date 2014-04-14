(function(buster, require) {
  var assert, mockApi, refute, syncAfterJoin;
  assert = void 0;
  refute = void 0;
  assert = buster.assert;
  refute = buster.refute;
  syncAfterJoin = require('../../../network/strategy/syncAfterJoin');
  mockApi = {
    isAfter: function() {
      return true;
    }
  };
  buster.testCase('cola/network/strategy/syncAfterJoin', {
    'should return function': function() {
      assert.isFunction(syncAfterJoin([]));
    },
    'should call hub\'s queueEvent': function(done) {
      var api, dest, qspy, src;
      qspy = void 0;
      api = void 0;
      dest = void 0;
      src = void 0;
      qspy = this.spy();
      api = Object.create(mockApi);
      api.queueEvent = qspy;
      src = {};
      syncAfterJoin()(src, dest, {}, 'join', api);
      setTimeout((function() {
        assert.calledOnceWith(qspy, src, false, 'sync');
        done();
      }), 0);
    },
    'should call hub\'s queueEvent when provide is true': function(done) {
      var api, dest, qspy, src;
      qspy = void 0;
      api = void 0;
      dest = void 0;
      src = void 0;
      qspy = this.spy();
      api = Object.create(mockApi);
      api.queueEvent = qspy;
      src = {
        provide: true
      };
      syncAfterJoin()(src, dest, {}, 'join', api);
      setTimeout((function() {
        assert.calledOnceWith(qspy, src, true, 'sync');
        done();
      }), 0);
    }
  });
})(require('buster'), require);
