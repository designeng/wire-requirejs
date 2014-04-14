(function(buster, require) {
  var ArrayAdapter, CollectionHub, assert, refute;
  assert = void 0;
  refute = void 0;
  assert = buster.assert;
  refute = buster.refute;
  CollectionHub = require('../Collection');
  ArrayAdapter = require('../adapter/Array');
  buster.testCase('cola/Collection', {
    'should not fail if not given any constructor params': function() {
      refute.exception(function() {
        new CollectionHub();
      });
    },
    'should add methods for eventNames': function() {
      var h;
      h = new CollectionHub();
      assert.isObject(h);
      assert.isFunction(h.add);
      assert.isFunction(h.beforeAdd);
      assert.isFunction(h.onAdd);
      assert.isFunction(h.update);
      assert.isFunction(h.beforeUpdate);
      assert.isFunction(h.onUpdate);
      assert.isFunction(h.remove);
      assert.isFunction(h.beforeRemove);
      assert.isFunction(h.onRemove);
    },
    'should return an adapter when calling addSource with a non-adapter': function() {
      var a, h;
      h = new CollectionHub();
      a = h.addSource([]);
      assert.isObject(a);
      assert.isFunction(a.add);
    },
    'should pass through an adapter when calling addSource with an adapter': function() {
      var a, adapter, h;
      h = new CollectionHub();
      adapter = new ArrayAdapter([], {});
      a = h.addSource(adapter);
      assert.same(a, adapter);
    },
    'should override adapter default provide via options': function() {
      var a, defaultProvide, h;
      h = new CollectionHub();
      defaultProvide = true;
      a = h.addSource([], {
        provide: false
      });
      refute.equals(a.provide, defaultProvide);
    },
    'should find and add new event types from adapter': function() {
      var a, adapter, e, h;
      e = {};
      h = new CollectionHub({
        events: e
      });
      adapter = new ArrayAdapter([]);
      adapter.crazyNewEvent = function() {};
      a = h.addSource(adapter, {
        eventNames: function(name) {
          return /^crazy/.test(name);
        }
      });
      assert.isFunction(h.onCrazyNewEvent);
    },
    'should call findItem on each adapter': function() {
      var a, adapter, e, h;
      e = {};
      h = new CollectionHub({
        events: e
      });
      adapter = new ArrayAdapter([]);
      adapter.findItem = this.spy();
      a = h.addSource(adapter, {});
      h.findItem();
      assert.calledOnce(adapter.findItem);
    },
    'should call findNode on each adapter': function() {
      var a, adapter, e, h;
      e = {};
      h = new CollectionHub({
        events: e
      });
      adapter = new ArrayAdapter([]);
      adapter.findNode = this.spy();
      a = h.addSource(adapter, {});
      h.findNode();
      assert.calledOnce(adapter.findNode);
    },
    'should call strategy to join adapter': function() {
      var h, strategy;
      strategy = this.spy();
      h = new CollectionHub({
        strategy: strategy
      });
      h.onJoin = this.spy();
      h.addSource([]);
      assert.calledOnce(h.onJoin);
    },
    'should not call events if strategy cancels event': function(done) {
      var h, isAfterCanceled, primary, strategy;
      strategy = function(source, dest, data, type, api) {
        var isAfterCanceled;
        isAfterCanceled = api.isAfterCanceled();
        api.cancel();
      };
      h = new CollectionHub({
        strategy: strategy
      });
      primary = h.addSource([]);
      isAfterCanceled = void 0;
      h.beforeAdd = this.spy();
      h.onAdd = function() {
        assert.calledOnce(h.beforeAdd);
        done();
      };
      primary.name = 'primary';
      primary.add({
        id: 1
      });
      assert(isAfterCanceled, 'last event should be canceled');
    },
    'should run queued event in next turn': function(done) {
      var h, primary, removeDetected, strategy;
      strategy = function(source, dest, data, type, api) {
        var removeDetected;
        if ('add' === type) {
          api.queueEvent(source, data, 'remove');
        } else {
          if ('remove' === type) {
            removeDetected = true;
          }
        }
      };
      h = new CollectionHub({
        strategy: strategy
      });
      primary = h.addSource([]);
      removeDetected = void 0;
      primary.add({
        id: 1
      });
      refute.defined(removeDetected);
      setTimeout((function() {
        assert.defined(removeDetected);
        done();
      }), 100);
    },
    '// should add property transforms to adapter': function() {}
  });
})(require('buster'), require);
