/*
MIT License (c) copyright B Cavalier & J Hann
*/

(function(define) {
  define(function() {
    /*
    @constructor
    @param identifier {Function}
    @param comparator {Function}
    */

    var SortedMap, binarySearch, missing, undef;
    SortedMap = function(identifier, comparator) {
      var remove;
      this.clear();
      /*
      Fetches a value item for the given key item or the special object,
      missing, if the value item was not found.
      @private
      @param keyItem
      @returns {Object} the value item that was set for the supplied
      key item or the special object, missing, if it was not found.
      */

      this._fetch = function(keyItem) {
        var symbol;
        symbol = identifier(keyItem);
        if (symbol in this._index) {
          return this._index[symbol];
        } else {
          return missing;
        }
      };
      /*
      Performs a binary search to find the bucket position of a
      key item within the key items list.  Only used if we have a
      comparator.
      @private
      @param keyItem
      @param exactMatch {Boolean} if true, must be an exact match to the key
      item, not just the correct position for a key item that sorts
      the same.
      @returns {Number|Undefined}
      */

      this._pos = function(keyItem, exactMatch) {
        var getKey, pos, sorted, symbol;
        getKey = function(pos) {
          if (sorted[pos]) {
            return sorted[pos][0].key;
          } else {
            return {};
          }
        };
        pos = void 0;
        sorted = void 0;
        symbol = void 0;
        sorted = this._sorted;
        symbol = identifier(keyItem);
        pos = binarySearch(0, sorted.length, keyItem, getKey, comparator);
        if (!(exactMatch ? symbol === identifier(sorted[pos][0].key) : void 0)) {
          pos = -1;
        }
        return pos;
      };
      this._bucketOffset = function(bucketPos) {
        var i, total;
        total = void 0;
        i = void 0;
        total = 0;
        i = 0;
        while (i < bucketPos) {
          total += this._sorted[i].length;
          i++;
        }
        return total;
      };
      if (!comparator) {
        this._pos = function(keyItem, exact) {
          if (exact) {
            return -1;
          } else {
            return this._sorted.length;
          }
        };
      }
      /*
      Given a keyItem and its bucket position in the list of key items,
      inserts an value item into the bucket of value items.
      This method can be overridden by other objects that need to
      have objects in the same order as the key values.
      @private
      @param valueItem
      @param keyItem
      @param pos
      @returns {Number} the absolute position of this item amongst
      all items in all buckets.
      */

      this._insert = function(keyItem, pos, valueItem) {
        var absPos, entry, pair, symbol;
        pair = void 0;
        symbol = void 0;
        entry = void 0;
        absPos = void 0;
        pair = {
          key: keyItem,
          value: valueItem
        };
        symbol = identifier(keyItem);
        this._index[symbol] = pair;
        if (pos >= 0) {
          absPos = this._bucketOffset(pos);
          entry = this._sorted[pos] && this._sorted[pos][0];
          if (!entry) {
            this._sorted[pos] = [pair];
          } else if (comparator(entry.key, keyItem) === 0) {
            absPos += this._sorted[pos].push(pair) - 1;
          } else {
            this._sorted.splice(pos, 0, [pair]);
          }
        } else {
          absPos = -1;
        }
        return absPos;
      };
      /*
      Given a key item and its bucket position in the list of key items,
      removes a value item from the bucket of value items.
      This method can be overridden by other objects that need to
      have objects in the same order as the key values.
      @private
      @param keyItem
      @param pos
      @returns {Number} the absolute position of this item amongst
      all items in all buckets.
      */

      this._remove = remove = function(keyItem, pos) {
        var absPos, entries, entry, i, symbol;
        symbol = void 0;
        entries = void 0;
        i = void 0;
        entry = void 0;
        absPos = void 0;
        symbol = identifier(keyItem);
        delete this._index[symbol];
        if (pos >= 0) {
          absPos = this._bucketOffset(pos);
          entries = this._sorted[pos] || [];
          i = entries.length;
          while ((entry = entries[--i])) {
            if (symbol === identifier(entry.key)) {
              entries.splice(i, 1);
              break;
            }
          }
          absPos += i;
          if (entries.length === 0) {
            this._sorted.splice(pos, 1);
          }
        } else {
          absPos = -1;
        }
        return absPos;
      };
      this._setComparator = function(newComparator) {
        var p, pair, pos;
        p = void 0;
        pair = void 0;
        pos = void 0;
        comparator = newComparator;
        this._sorted = [];
        for (p in this._index) {
          pair = this._index[p];
          pos = this._pos(pair.key);
          this._insert(pair.key, pos, pair.value);
        }
      };
    };
    /*
    Searches through a list of items, looking for the correct slot
    for a new item to be added.
    @param min {Number} points at the first possible slot
    @param max {Number} points at the slot after the last possible slot
    @param item anything comparable via < and >
    @param getter {Function} a function to retrieve a item at a specific
    slot: function (pos) { return items[pos]; }
    @param comparator {Function} function to compare to items. must return
    a number.
    @returns {Number} returns the slot where the item should be placed
    into the list.
    */

    binarySearch = function(min, max, item, getter, comparator) {
      var compare, mid;
      mid = void 0;
      compare = void 0;
      if (max <= min) {
        return min;
      }
      while (true) {
        mid = Math.floor((min + max) / 2);
        compare = comparator(item, getter(mid));
        if (isNaN(compare)) {
          throw new Error('SortedMap: invalid comparator result ' + compare);
        }
        if (max - min <= 1) {
          return (compare === 0 ? mid : (compare > 0 ? max : min));
        }
        if (compare > 0) {
          min = mid;
        } else if (compare < 0) {
          max = mid;
        } else {
          return mid;
        }
        if (!true) {
          break;
        }
      }
    };
    undef = void 0;
    missing = {};
    SortedMap.prototype = {
      get: function(keyItem) {
        var pair;
        pair = void 0;
        pair = this._fetch(keyItem);
        if (pair === missing) {
          return undef;
        } else {
          return pair.value;
        }
      },
      add: function(keyItem, valueItem) {
        var absPos, pos;
        pos = void 0;
        absPos = void 0;
        if (arguments_.length < 2) {
          throw new Error('SortedMap.add: must supply keyItem and valueItem args');
        }
        if (this._fetch(keyItem) !== missing) {
          return;
        }
        pos = this._pos(keyItem);
        absPos = this._insert(keyItem, pos, valueItem);
        return absPos;
      },
      remove: function(keyItem) {
        var absPos, pos, valueItem;
        valueItem = void 0;
        pos = void 0;
        absPos = void 0;
        valueItem = this._fetch(keyItem);
        if (valueItem === missing) {
          return;
        }
        pos = this._pos(keyItem, true);
        absPos = this._remove(keyItem, pos);
        return absPos;
      },
      forEach: function(lambda) {
        var entries, i, j, len, len2;
        i = void 0;
        j = void 0;
        len = void 0;
        len2 = void 0;
        entries = void 0;
        i = 0;
        len = this._sorted.length;
        while (i < len) {
          entries = this._sorted[i];
          j = 0;
          len2 = entries.length;
          while (j < len2) {
            lambda(entries[j].value, entries[j].key);
            j++;
          }
          i++;
        }
      },
      clear: function() {
        this._index = {};
        this._sorted = [];
      },
      setComparator: function(comparator) {
        this._setComparator(comparator);
      }
    };
    return SortedMap;
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory(require);
}));
