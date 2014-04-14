/*
MIT License (c) copyright B Cavalier & J Hann
*/

(function(define) {
  define(function(require) {
    /*
    Manages a collection of objects taken a queryable data source, which
    must provide query, add, and remove methods
    @constructor
    @param datasource {Object} queryable data source with query, add, put, remove methods
    @param [options.comparator] {Function} comparator function that will
    be propagated to other adapters as needed.  Note that QueryAdapter does not
    use this comparator internally.
    */

    var QueryAdapter, SortedMap, hasProperties, undef, when_;
    QueryAdapter = function(datasource, options) {
      var dsQuery, identifier, self;
      identifier = void 0;
      dsQuery = void 0;
      self = void 0;
      if (!datasource) {
        throw new Error('cola/QueryAdapter: datasource must be provided');
      }
      this._datasource = datasource;
      if (!options) {
        options = {};
      }
      this._options = options;
      if ('provide' in options) {
        this.provide = options.provide;
      }
      identifier = this.identifier = function(item) {
        return datasource.getIdentity(item);
      };
      this.comparator = this._options.comparator || function(a, b) {
        var aKey, bKey;
        aKey = void 0;
        bKey = void 0;
        aKey = identifier(a);
        bKey = identifier(b);
        if (aKey === bKey) {
          return 0;
        } else {
          if (aKey < bKey) {
            return -1;
          } else {
            return 1;
          }
        }
      };
      this._items = new SortedMap(identifier, this.comparator);
      dsQuery = datasource.query;
      self = this;
      datasource.query = function(query) {
        return self._queue(function() {
          return when_(dsQuery.call(datasource, arguments_), function(results) {
            self._items = new SortedMap(self.identifier, self.comparator);
            self._initResultSet(results);
            return results;
          });
        });
      };
    };
    /*
    Adds op to the internal queue of async tasks to ensure that
    it will run in the order added and not overlap with other async tasks
    @param op {Function} async task (function that returns a promise) to add
    to the internal queue
    @return {Promise} promise that will resolver/reject when op has completed
    @private
    */

    /*
    Initialized the internal map of items
    @param results {Array} array of result items
    @private
    */

    hasProperties = function(o) {
      var p;
      if (!o) {
        return false;
      }
      for (p in o) {
        continue;
      }
    };
    when_ = void 0;
    SortedMap = void 0;
    undef = void 0;
    when_ = require('when');
    SortedMap = require('./../SortedMap');
    QueryAdapter.prototype = {
      provide: true,
      comparator: undef,
      identifier: undef,
      query: function(query) {
        return this._datasource.query.apply(this._datasource, arguments_);
      },
      _queue: function(op) {
        this._inflight = when_(this._inflight, function() {
          return op();
        });
        return this._inflight;
      },
      _initResultSet: function(results) {
        var i, item, len, map, self;
        map = void 0;
        i = void 0;
        len = void 0;
        item = void 0;
        self = void 0;
        map = this._items;
        map.clear();
        self = this;
        i = 0;
        len = results.length;
        while (i < len) {
          item = results[i];
          map.add(item, item);
          self.add(item);
          i++;
        }
      },
      getOptions: function() {
        return this._options;
      },
      forEach: function(lambda) {
        var self;
        self = this;
        return this._queue(function() {
          return self._items.forEach(lambda);
        });
      },
      add: function(item) {
        var added, items, self;
        items = void 0;
        added = void 0;
        self = void 0;
        items = this._items;
        added = items.add(item, item);
        if (added >= 0 && !this._dontCallDatasource) {
          self = this;
          return when_(this._datasource.add(item), (function(returned) {
            if (self._itemWasUpdatedByDatasource(returned)) {
              self._execMethodWithoutCallingDatasource('update', returned);
            }
          }), function(err) {
            self._execMethodWithoutCallingDatasource('remove', item);
            throw errreturn;
          });
        }
      },
      remove: function(item) {
        var id, items, removed;
        removed = void 0;
        items = void 0;
        items = this._items;
        removed = items.remove(item);
        if (removed >= 0 && !this._dontCallDatasource) {
          id = this._datasource.getIdentity(item);
          return when_(this._datasource.remove(id), null, function(err) {
            self._execMethodWithoutCallingDatasource('add', item);
            throw errreturn;
          });
        }
      },
      update: function(item) {
        var items, orig, self;
        orig = void 0;
        items = void 0;
        self = void 0;
        items = this._items;
        orig = items.get(item);
        if (orig) {
          this._replace(orig, item);
          if (!this._dontCallDatasource) {
            self = this;
            return when_(this._datasource.put(item), (function(returned) {
              if (self._itemWasUpdatedByDatasource(returned)) {
                self._execMethodWithoutCallingDatasource('update', returned);
              }
            }), function(err) {
              self._execMethodWithoutCallingDatasource('update', orig);
              throw errreturn;
            });
          }
        }
      },
      _replace: function(oldItem, newItem) {
        this._items.remove(oldItem);
        this._items.add(newItem, newItem);
      },
      _itemWasUpdatedByDatasource: function(item) {
        return hasProperties(item);
      },
      _execMethodWithoutCallingDatasource: function(method, item) {
        this._dontCallDatasource = true;
        try {
          return this[method](item);
        } finally {
          this._dontCallDatasource = false;
        }
      },
      clear: function() {
        this._initResultSet([]);
      }
    };
    QueryAdapter.canHandle = function(it) {
      return it && typeof it.query === 'function' && (!(it instanceof QueryAdapter));
    };
    return QueryAdapter;
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory(require);
}));
