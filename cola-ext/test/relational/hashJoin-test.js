(function(buster, when_, hashJoin) {
  var assert, fail, identity, projectPair, refute;
  identity = function(x) {
    return x;
  };
  projectPair = function(left, right, key) {
    return {
      left: left,
      right: right,
      key: key
    };
  };
  'use strict';
  assert = void 0;
  refute = void 0;
  fail = void 0;
  assert = buster.assert;
  refute = buster.refute;
  fail = buster.assertions.fail;
  buster.testCase('relational/hashJoin', {
    leftOuterJoin: {
      'should produce empty result for empty left input': function(done) {
        var left, right;
        left = void 0;
        right = void 0;
        left = [];
        right = [1, 2, 3];
        when_(hashJoin.leftOuterJoin(left, identity, right, identity, identity), function(joined) {
          assert.equals(joined, []);
        }, fail).then(done, done);
      },
      'should contain all left items': function(done) {
        var left, right;
        left = void 0;
        right = void 0;
        left = [1, 2, 3];
        right = [2, 4, 6];
        when_(hashJoin.leftOuterJoin(left, identity, right, identity, identity), function(joined) {
          assert.equals(joined, left);
        }, fail).then(done, done);
      },
      'should produce left input for empty right input': function(done) {
        var left, right;
        left = void 0;
        right = void 0;
        left = [1, 2, 3];
        right = [];
        when_(hashJoin.leftOuterJoin(left, identity, right, identity, identity), function(joined) {
          assert.equals(joined, left);
        }, fail).then(done, done);
      },
      'should project all items': function(done) {
        var left, right;
        left = void 0;
        right = void 0;
        left = [1, 2, 3];
        right = [1, 2, 3, 4, 5, 6];
        when_(hashJoin.leftOuterJoin(left, identity, right, identity, projectPair), function(joined) {
          var i, len;
          assert.equals(joined.length, left.length);
          i = 0;
          len = joined.length;
          while (i < len) {
            assert.equals(joined[i], {
              left: left[i],
              right: right[i],
              key: left[i]
            });
            i++;
          }
        }, fail).then(done, done);
      }
    }
  });
})(require('buster'), require('when'), require('../../relational/hashJoin'));
