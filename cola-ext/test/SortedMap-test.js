(function(buster, SortedMap) {
  var assert, compareByLast, compareItems, refute, symbolizeItem, undef;
  compareItems = function(a, b) {
    return a.id - b.id;
  };
  compareByLast = function(a, b) {
    if (a.last < b.last) {
      return -1;
    } else {
      if (a.last > b.last) {
        return 1;
      } else {
        return 0;
      }
    }
  };
  symbolizeItem = function(it) {
    return it.id;
  };
  assert = void 0;
  refute = void 0;
  undef = void 0;
  assert = buster.assert;
  refute = buster.refute;
  buster.testCase('SortedMap', {
    add: {
      'should throw if key and value not provided': function() {
        var map;
        map = new SortedMap(symbolizeItem, compareItems);
        assert.exception(function() {
          map.add({
            id: 1
          });
        });
      },
      'should add new items': function() {
        var hash, spy;
        hash = new SortedMap(symbolizeItem, compareItems);
        assert.equals(hash.add({
          id: 1
        }, 1), 0);
        assert.equals(hash.add({
          id: 2
        }, 2), 1);
        spy = this.spy();
        hash.forEach(spy);
        assert.calledTwice(spy);
      },
      'should add very large item into last slot': function() {
        var hash;
        hash = new SortedMap(symbolizeItem, compareItems);
        assert.equals(hash.add({
          id: 1
        }, 1), 0);
        assert.equals(hash.add({
          id: 9
        }, 9), 1);
        assert.equals(hash.add({
          id: 99
        }, 99), 2);
        assert.equals(hash.add({
          id: 999
        }, 999), 3);
      },
      'should fail silently when adding an item that already exists': function() {
        var hash;
        hash = new SortedMap(symbolizeItem, compareItems);
        hash.add({
          id: 1
        }, 1);
        refute.defined(hash.add({
          id: 1
        }, 1));
      },
      'should add all items even when no comparator supplied': function() {
        var count, map, result;
        map = void 0;
        count = void 0;
        result = void 0;
        map = new SortedMap(symbolizeItem);
        assert.equals(map.add({
          id: 0
        }, 0), 0);
        assert.equals(map.add({
          id: 1
        }, 1), 1);
        assert.equals(map.add({
          id: 2
        }, 2), 2);
        count = 0;
        result = 0;
        map.forEach(function(item) {
          count++;
          result += item;
        });
        assert.equals(count, 3);
        assert.equals(result, 3);
      },
      'should add all items even when comparator says all items are equivalent': function() {
        var count, map, result;
        map = void 0;
        count = void 0;
        result = void 0;
        map = new SortedMap(symbolizeItem, function() {
          return 0;
        });
        assert.equals(map.add({
          id: 0
        }, 0), 0);
        assert.equals(map.add({
          id: 1
        }, 1), 1);
        assert.equals(map.add({
          id: 2
        }, 2), 2);
        count = 0;
        result = 0;
        map.forEach(function(item) {
          count++;
          result += item;
        });
        assert.equals(count, 3);
        assert.equals(result, 3);
      }
    },
    remove: {
      'should remove items': function() {
        var items, map, spy;
        map = new SortedMap(symbolizeItem, compareItems);
        items = [
          {
            id: 1
          }, {
            id: 3
          }, {
            id: 4
          }, {
            id: 2
          }
        ];
        map.add(items[0], 'foo');
        map.add(items[1], 'bar');
        map.add(items[2], 'baz');
        map.add(items[3], 'fot');
        map.remove({
          id: 3
        });
        spy = this.spy();
        map.forEach(spy);
        assert.calledWith(spy, 'foo', items[0]);
        refute.calledWith(spy, 'bar', items[1]);
        assert.calledWith(spy, 'baz', items[2]);
        assert.calledWith(spy, 'fot', items[3]);
      },
      'should silently fail when removing non-existent items': function() {
        var map;
        map = new SortedMap(symbolizeItem, compareItems);
        map.add({
          id: 1
        }, 1);
        refute.defined(map.remove({
          id: 2
        }));
      }
    },
    clear: {
      'should remove all items': function() {
        var map, spy;
        map = new SortedMap(symbolizeItem, compareItems);
        map.add({
          id: 1
        }, 1);
        map.add({
          id: 2
        }, 2);
        map.add({
          id: 3
        }, 3);
        map.clear();
        refute.defined(map.get({
          id: 1
        }));
        refute.defined(map.get({
          id: 2
        }));
        refute.defined(map.get({
          id: 3
        }));
        spy = this.spy();
        map.forEach(spy);
        refute.called(spy);
      }
    },
    forEach: {
      'should iterate over all items in order': function() {
        var count, map, prev;
        map = new SortedMap(symbolizeItem, compareByLast);
        map.add({
          id: 1,
          last: 'Attercop',
          expected: 2
        }, 1);
        map.add({
          id: 3,
          last: 'TomNoddy',
          expected: 4
        }, 2);
        map.add({
          id: 4,
          last: 'Aardvark',
          expected: 1
        }, 3);
        map.add({
          id: 2,
          last: 'Bojangle',
          expected: 3
        }, 4);
        count = 0;
        prev = 0;
        map.forEach(function(value, key) {
          count++;
          assert.equals(key.expected - prev, 1);
          prev = key.expected;
        });
        assert(count === 4);
      }
    }
  });
})(require('buster'), require('../SortedMap'));
