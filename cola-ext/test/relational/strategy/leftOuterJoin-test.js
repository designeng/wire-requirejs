(function(buster, createLeftOuterJoin, hashJoin) {
  var assert, fakeIterable, noop, origLeftOuterJoin, refute;
  noop = function() {};
  fakeIterable = function() {
    return {
      forEach: noop
    };
  };
  'use strict';
  assert = void 0;
  refute = void 0;
  origLeftOuterJoin = void 0;
  assert = buster.assert;
  refute = buster.refute;
  buster.testCase('relational/strategy/leftOuterJoin', {
    setUp: function() {
      origLeftOuterJoin = hashJoin.leftOuterJoin;
      hashJoin.leftOuterJoin = this.spy();
    },
    tearDown: function() {
      hashJoin.leftOuterJoin = origLeftOuterJoin;
    },
    'should throw if options not provided': function() {
      assert.exception(function() {
        createLeftOuterJoin();
      });
    },
    'should throw if options.leftKey not provided': function() {
      assert.exception(function() {
        createLeftOuterJoin({});
      });
    },
    'should return a function if options.leftKey is provided': function() {
      assert.isFunction(createLeftOuterJoin({
        leftKey: 'id'
      }));
    },
    'should return a function that forwards parameters to join engine': function() {
      var join, left, right;
      join = void 0;
      left = void 0;
      right = void 0;
      join = createLeftOuterJoin({
        leftKey: noop,
        rightKey: noop,
        projection: noop,
        multiValue: true
      });
      left = this.stub(fakeIterable());
      right = this.stub(fakeIterable());
      join(left, right);
      assert.calledOnceWith(hashJoin.leftOuterJoin, left, noop, right, noop, noop, true);
    }
  });
})(require('buster'), require('../../../relational/strategy/leftOuterJoin'), require('../../../relational/hashJoin'));
