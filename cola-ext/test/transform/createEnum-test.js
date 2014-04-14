(function(buster, createEnum) {
  'use strict';
  var assert, refute;
  assert = void 0;
  refute = void 0;
  assert = buster.assert;
  refute = buster.refute;
  buster.testCase('transform/createEnum', {
    'should return a function': function() {
      assert.isFunction(createEnum({}));
    },
    'should return an inverse function': function() {
      assert.isFunction(createEnum({}).inverse);
    },
    transform: {
      'should return an empty set when configured with empty input map': function() {
        var e;
        e = createEnum({});
        assert.equals(e('test'), {});
      },
      'should return an empty set with non-existent input': function() {
        var e;
        e = createEnum({
          foo: 'bar'
        });
        assert.equals(e('test'), {});
      },
      'should return corresponding set values': function() {
        var e, result;
        e = createEnum({
          a: 'a1',
          b: 'b1'
        });
        result = e('a');
        assert(result.a1);
        refute(result.b1);
      },
      'should return corresponding set values when multi-value': function() {
        var e, result;
        e = createEnum({
          a: 'a1',
          b: 'b1',
          c: 'c1'
        }, {
          multi: true
        });
        result = e(['a', 'b']);
        assert(result.a1);
        assert(result.b1);
        refute(result.c1);
      }
    },
    inverse: {
      'should return an empty array with empty input map': function() {
        var e;
        e = createEnum({});
        assert.equals(e.inverse({}), []);
      },
      'should return an empty array with non-existent input': function() {
        var e;
        e = createEnum({
          foo: 'bar'
        });
        assert.equals(e.inverse({
          baz: true
        }), []);
      },
      'should return corresponding values': function() {
        var e;
        e = createEnum({
          a: 'a1',
          b: 'b1'
        });
        assert.equals(e.inverse({
          a1: true
        }), ['a']);
      },
      'should return corresponding set values when multi-value': function() {
        var e;
        e = createEnum({
          a: 'a1',
          b: 'b1'
        }, {
          multi: true
        });
        assert.equals(e.inverse({
          a1: true,
          b1: true
        }), ['a', 'b']);
      }
    }
  });
})(require('buster'), require('../../transform/createEnum'));
