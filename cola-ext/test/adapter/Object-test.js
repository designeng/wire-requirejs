(function(buster, when_, delay, ObjectAdapter) {
  var assert, fail, promiseFor, refute;
  promiseFor = function(it) {
    return delay(it, 0);
  };
  'use strict';
  assert = void 0;
  refute = void 0;
  fail = void 0;
  assert = buster.assert;
  refute = buster.refute;
  fail = buster.assertions.fail;
  buster.testCase('adapter/Object', {
    options: {
      'should pass options to getOptions': function() {
        var adaptedObject, bindings;
        bindings = {};
        adaptedObject = void 0;
        adaptedObject = new ObjectAdapter({}, {
          bindings: bindings
        });
        assert.equals(bindings, adaptedObject.getOptions().bindings);
      }
    },
    canHandle: {
      'should return true for a object literals': function() {
        assert(ObjectAdapter.canHandle({}), 'object');
      },
      'should return true for a promise': function() {
        assert(ObjectAdapter.canHandle(promiseFor({})));
      },
      'should return false for non-object literals': function() {
        refute(ObjectAdapter.canHandle(), 'undefined');
        refute(ObjectAdapter.canHandle(null), 'null');
        refute(ObjectAdapter.canHandle(function() {}), 'function');
        refute(ObjectAdapter.canHandle([]), 'array');
      }
    },
    update: {
      'should update an object when update() called': function() {
        var adapted, obj;
        obj = void 0;
        adapted = void 0;
        obj = {
          first: 'Fred',
          last: 'Flintstone'
        };
        adapted = new ObjectAdapter(obj);
        adapted.update({
          first: 'Donna',
          last: 'Summer'
        });
        assert.equals(adapted._obj.first, 'Donna');
        assert.equals(adapted._obj.last, 'Summer');
      },
      'should update some properties when update() called with a partial': function() {
        var adapted, obj;
        obj = void 0;
        adapted = void 0;
        obj = {
          first: 'Fred',
          last: 'Flintstone'
        };
        adapted = new ObjectAdapter(obj);
        adapted.update({
          last: 'Astaire'
        });
        assert.equals(adapted._obj.first, 'Fred');
        assert.equals(adapted._obj.last, 'Astaire');
      },
      'promise-aware': {
        'should update an object': function(done) {
          var adapted, obj;
          obj = void 0;
          adapted = void 0;
          obj = {
            first: 'Fred',
            last: 'Flintstone'
          };
          adapted = new ObjectAdapter(promiseFor(obj));
          when_(adapted.update({
            first: 'Donna',
            last: 'Summer'
          }), function() {
            return when_(adapted._obj, function(obj) {
              assert.equals(obj.first, 'Donna');
              assert.equals(obj.last, 'Summer');
            });
          }, fail).then(done, done);
        },
        'should update supplied properties when called with a partial': function(done) {
          var adapted, obj;
          obj = void 0;
          adapted = void 0;
          obj = {
            first: 'Fred',
            last: 'Flintstone'
          };
          adapted = new ObjectAdapter(promiseFor(obj));
          when_(adapted.update({
            last: 'Astaire'
          }), function() {
            return when_(adapted._obj, function(obj) {
              assert.equals(obj.first, 'Fred');
              assert.equals(obj.last, 'Astaire');
            });
          }, fail).then(done, done);
        }
      }
    }
  });
})(require('buster'), require('when'), require('when/delay'), require('../../adapter/Object'));
