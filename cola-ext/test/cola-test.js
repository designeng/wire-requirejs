(function(buster, when_, cola) {
  var assert, fail, makeResolver, refResolver, refute;
  makeResolver = function(resolve, reject) {
    return {
      resolve: resolve,
      reject: reject
    };
  };
  'use strict';
  assert = void 0;
  refute = void 0;
  fail = void 0;
  refResolver = void 0;
  assert = buster.assert;
  refute = buster.refute;
  fail = buster.assertions.fail;
  refResolver = {
    isRef: function() {
      return false;
    }
  };
  buster.testCase('cola', {
    'wire plugin': {
      'should return a valid plugin': function() {
        var plugin;
        plugin = cola.wire$plugin(null, null, {});
        assert.isFunction(plugin.facets.bind.ready);
      },
      'should fail if "to" not provided': function(done) {
        var bind, plugin, rejected, wire;
        plugin = void 0;
        bind = void 0;
        wire = void 0;
        rejected = void 0;
        plugin = cola.wire$plugin(null, null, {});
        bind = plugin.facets.bind.ready;
        wire = this.stub().returns({});
        wire.resolver = refResolver;
        rejected = this.spy();
        bind(makeResolver(function(p) {
          p.then(fail, rejected).then(function() {
            assert.calledOnce(rejected);
          }).then(done, done);
        }), {
          target: {}
        }, wire);
      },
      'should wire options': function() {
        var bind, plugin, resolved, wire;
        plugin = void 0;
        bind = void 0;
        wire = void 0;
        resolved = void 0;
        plugin = cola.wire$plugin(null, null, {});
        bind = plugin.facets.bind.ready;
        wire = this.stub().returns({
          to: {
            addSource: this.spy()
          }
        });
        wire.resolver = refResolver;
        resolved = this.spy();
        bind(makeResolver(resolved), {
          target: {}
        }, wire);
        assert.calledOnce(wire);
        assert.calledOnce(resolved);
      },
      'should add source': function() {
        var addSource, bind, plugin, target, wire;
        plugin = void 0;
        bind = void 0;
        wire = void 0;
        addSource = void 0;
        target = void 0;
        plugin = cola.wire$plugin(null, null, {});
        bind = plugin.facets.bind.ready;
        addSource = this.spy();
        wire = this.stub().returns({
          to: {
            addSource: addSource
          }
        });
        wire.resolver = refResolver;
        target = {};
        bind(makeResolver(this.spy()), {
          target: target
        }, wire);
        assert.calledOnceWith(addSource, target);
      },
      'should include default comparator if not provided': function() {
        var bind, plugin, resolved, wire, wired;
        plugin = void 0;
        bind = void 0;
        wire = void 0;
        resolved = void 0;
        wired = void 0;
        plugin = cola.wire$plugin(null, null, {});
        bind = plugin.facets.bind.ready;
        wire = function(s) {
          wired = s;
        };
        wire.resolver = refResolver;
        resolved = this.spy();
        bind(makeResolver(resolved), {
          target: {}
        }, wire);
        assert.isFunction(wired.comparator);
      }
    }
  });
})(require('buster'), require('when'), require('../cola'));
