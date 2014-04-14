/*
MIT License (c) copyright B Cavalier & J Hann
*/

(function(define) {
  define(function(require) {
    /*
    Manages a collection of objects taken from the supplied dataArray
    @param dataArray {Array} array of data objects to use as the initial
    population
    @param options.identifier {Function} function that returns a key/id for
    a data item.
    @param options.comparator {Function} comparator function that will
    be propagated to other adapters as needed
    */

    var ArrayAdapter, addAll, buildIndex, defaultIdentifier, makePromiseAware, methods, mixin, undef, when_;
    ArrayAdapter = function(dataArray, options) {
      var self;
      if (!options) {
        options = {};
      }
      this._options = options;
      this.comparator = options.comparator || this._defaultComparator;
      this.identifier = options.identifier || defaultIdentifier;
      if ('provide' in options) {
        this.provide = options.provide;
      }
      this._array = dataArray;
      this.clear();
      self = this;
      when_(dataArray, function(array) {
        mixin(self, methods);
        self._init(array);
      });
    };
    /*
    Default comparator that uses an item's position in the array
    to order the items.  This is important when an input array is already
    in sorted order, so the user doesn't have to specify a comparator,
    and so the order can be propagated to other adapters.
    @param a
    @param b
    @return {Number} -1 if a is before b in the input array
    1 if a is after b in the input array
    0 iff a and b have the same symbol as returned by the configured identifier
    */

    /*
    @param to
    @param from
    @param [transform]
    */

    mixin = function(to, from, transform) {
      var func, name;
      name = void 0;
      func = void 0;
      for (name in from) {
        if (from.hasOwnProperty(name)) {
          func = from[name];
          to[name] = (transform ? transform(func) : func);
        }
      }
      return to;
    };
    /*
    Returns a new function that will delay execution of the supplied
    function until this._resultSetPromise has resolved.
    
    @param func {Function} original function
    @return {Promise}
    */

    makePromiseAware = function(func) {
      var promiseAware;
      return promiseAware = function() {
        var args, self;
        self = void 0;
        args = void 0;
        self = this;
        args = Array.prototype.slice.call(arguments_);
        return when_(this._array, function() {
          return func.apply(self, args);
        });
      };
    };
    defaultIdentifier = function(item) {
      if (typeof item === 'object') {
        return item.id;
      } else {
        return item;
      }
    };
    /*
    Adds all the items, starting at the supplied start index,
    to the supplied adapter.
    @param adapter
    @param items
    */

    addAll = function(adapter, items) {
      var i, len;
      i = 0;
      len = items.length;
      while (i < len) {
        adapter.add(items[i]);
        i++;
      }
    };
    buildIndex = function(items, keyFunc) {
      var i, index, len;
      index = void 0;
      i = void 0;
      len = void 0;
      index = {};
      i = 0;
      len = items.length;
      while (i < len) {
        index[keyFunc(items[i])] = i;
        i++;
      }
      return index;
    };
    'use strict';
    when_ = void 0;
    methods = void 0;
    undef = void 0;
    when_ = require('when');
    ArrayAdapter.prototype = {
      provide: true,
      _init: function(dataArray) {
        if (dataArray && dataArray.length) {
          addAll(this, dataArray);
        }
      },
      _defaultComparator: function(a, b) {
        var aIndex, bIndex;
        aIndex = void 0;
        bIndex = void 0;
        aIndex = this._index(this.identifier(a));
        bIndex = this._index(this.identifier(b));
        return aIndex - bIndex;
      },
      comparator: undef,
      identifier: undef,
      getOptions: function() {
        return this._options;
      },
      forEach: function(lambda) {
        return this._forEach(lambda);
      },
      add: function(item) {
        return this._add(item);
      },
      remove: function(item) {
        return this._remove(item);
      },
      update: function(item) {
        return this._update(item);
      },
      clear: function() {
        return this._clear();
      }
    };
    methods = {
      _forEach: function(lambda) {
        var data, i, len;
        i = void 0;
        data = void 0;
        len = void 0;
        i = 0;
        data = this._data;
        len = data.length;
        while (i < len) {
          lambda(data[i]);
          i++;
        }
      },
      _add: function(item) {
        var index, key;
        key = void 0;
        index = void 0;
        key = this.identifier(item);
        index = this._index;
        if (key in index) {
          return null;
        }
        index[key] = this._data.push(item) - 1;
        return index[key];
      },
      _remove: function(itemOrId) {
        var at, data, index, key;
        key = void 0;
        at = void 0;
        index = void 0;
        data = void 0;
        key = this.identifier(itemOrId);
        index = this._index;
        if (!(key in index)) {
          return null;
        }
        data = this._data;
        at = index[key];
        data.splice(at, 1);
        this._index = buildIndex(data, this.identifier);
        return at;
      },
      _update: function(item) {
        var at, index, key;
        key = void 0;
        at = void 0;
        index = void 0;
        key = this.identifier(item);
        index = this._index;
        at = index[key];
        if (at >= 0) {
          this._data[at] = item;
        } else {
          index[key] = this._data.push(item) - 1;
        }
        return at;
      },
      _clear: function() {
        this._data = [];
        this._index = {};
      }
    };
    mixin(ArrayAdapter.prototype, methods, makePromiseAware);
    ArrayAdapter.canHandle = function(it) {
      return it && (when_.isPromise(it) || Object.prototype.toString.call(it) === '[object Array]');
    };
    return ArrayAdapter;
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory(require);
}));
