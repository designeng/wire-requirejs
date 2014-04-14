/*
MIT License (c) copyright B Cavalier & J Hann
*/

(function(define) {
  define(function(require) {
    /*
    Perform a left outer join on the supplied left and right iterables, returning
    a promise, which will resolve to an Array for the joined result.
    
    @param left {Iterable} anything with forEach. May be asynchronous
    @param leftKeyFunc {Function} function to generate a hash join key for left items
    @param right {Iterable} anything with forEach. May be asynchronous
    @param rightKeyFunc {Function} function to generate a hash join key for right items
    @param projectionFunc {Function} function to create a projected result from two joined items
    @param multiProjection {Boolean} by default (multiProjection is falsey), each left-right join pair will be passed
    to projectionFunc.  Thus, the projectionFunc may be invoked with the same left item
    many times.  if truthy, however, the left item and *all* its matching right items, as
    an Array, will be passed to projectionFunc.  Thus, the projectionFunc will be invoked
    only once per left item.
    @return {Promise} promise for the Array of joined results.
    */

    var buildJoinMap, doJoin, forEach, isArray, leftOuterJoin, projectEach, projectMulti, undef, when_;
    leftOuterJoin = function(left, leftKeyFunc, right, rightKeyFunc, projectionFunc, multiProjection) {
      var projectJoinResults;
      projectJoinResults = (multiProjection ? projectMulti : projectEach);
      return when_(buildJoinMap(right, rightKeyFunc), function(joinMap) {
        return doJoin(left, leftKeyFunc, joinMap, projectJoinResults, projectionFunc);
      });
    };
    buildJoinMap = function(items, keyFunc) {
      var joinMap;
      joinMap = {};
      return when_(items.forEach(function(item) {
        var addToMap, rightKey;
        addToMap = function(rightKey, item) {
          var rightItems;
          rightItems = joinMap[rightKey];
          if (!rightItems) {
            rightItems = [];
            joinMap[rightKey] = rightItems;
          }
          rightItems.push(item);
        };
        rightKey = void 0;
        rightKey = keyFunc(item);
        if (isArray(rightKey)) {
          forEach(rightKey, function(rightKey) {
            addToMap(rightKey, item);
          });
        } else {
          addToMap(rightKey, item);
        }
      })).then(function() {
        return joinMap;
      });
    };
    doJoin = function(items, keyFunc, joinMap, projectJoinResults, projectionFunc) {
      var joined;
      joined = [];
      return when_(items.forEach(function(item) {
        var join, joinKey;
        join = function(joinKey, item, map) {
          var joinMatches;
          joinMatches = map[joinKey];
          projectJoinResults(item, joinMatches, joinKey, projectionFunc, joined);
        };
        joinKey = void 0;
        joinKey = keyFunc(item);
        if (isArray(joinKey)) {
          forEach(joinKey, function(joinKey) {
            join(joinKey, item, joinMap);
          });
        } else {
          join(joinKey, item, joinMap);
        }
      })).then(function() {
        return joined;
      });
    };
    isArray = function(it) {
      return Object.prototype.toString.call(it) === '[object Array]';
    };
    projectMulti = function(leftItem, rightMatches, joinKey, projectionFunc, results) {
      var items;
      items = projectionFunc(leftItem, rightMatches, joinKey);
      results.splice(results.length, 0, items);
    };
    projectEach = function(leftItem, rightMatches, joinKey, projectionFunc, results) {
      var project;
      project = function(left, right, key) {
        var items;
        items = projectionFunc(left, right, key);
        results.push(items);
      };
      if (rightMatches) {
        rightMatches.forEach(function(rightItem) {
          project(leftItem, rightItem, joinKey);
        });
      } else {
        project(leftItem, undef, joinKey);
      }
    };
    forEach = function(arr, lambda) {
      var i, len;
      i = 0;
      len = arr.length;
      while (i < len) {
        lambda(arr[i], i, arr);
        i++;
      }
    };
    'use strict';
    when_ = void 0;
    undef = void 0;
    when_ = require('when');
    return {
      leftOuterJoin: leftOuterJoin
    };
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory(require);
}));
