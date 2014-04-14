/*
MIT License (c) copyright B Cavalier & J Hann
*/

(function(global, define) {
  define(function(require) {
    var LocalStorageAdapter, defaultIdentifier, undef, when_;
    LocalStorageAdapter = function(namespace, options) {
      var data;
      if (!namespace) {
        throw new Error('cola/LocalStorageAdapter: must provide a storage namespace');
      }
      this._namespace = namespace;
      if (!options) {
        options = {};
      }
      if ('provide' in options) {
        this.provide = options.provide;
      }
      this._storage = options.localStorage || global.localStorage;
      if (!this._storage) {
        throw new Error('cola/LocalStorageAdapter: localStorage not available, must be supplied in options');
      }
      this.identifier = options.identifier || defaultIdentifier;
      data = this._storage.getItem(namespace);
      this._data = (data ? JSON.parse(data) : {});
    };
    'use strict';
    when_ = void 0;
    defaultIdentifier = void 0;
    undef = void 0;
    defaultIdentifier = require('./../identifier/default');
    when_ = require('when');
    LocalStorageAdapter.prototype = {
      provide: true,
      identifier: undef,
      getOptions: function() {
        return {};
      },
      forEach: function(lambda) {
        var data, key;
        data = this._data;
        for (key in data) {
          lambda(data[key]);
        }
      },
      add: function(item) {
        var id;
        id = this.identifier(item);
        if (id in this._data) {
          return null;
        }
        this._data[id] = item;
        this._sync();
        return id;
      },
      remove: function(item) {
        var id;
        id = this.identifier(item);
        if (!(id in this._data)) {
          return null;
        }
        delete this._data[id];
        this._sync();
        return item;
      },
      update: function(item) {
        var id;
        id = this.identifier(item);
        if (!(id in this._data)) {
          return null;
        }
        this._data[id] = item;
        this._sync();
        return item;
      },
      clear: function() {
        this._storage.removeItem(this._namespace);
      },
      _sync: function() {
        this._storage.setItem(this._namespace, JSON.stringify(this._data));
      }
    };
    return LocalStorageAdapter;
  });
})(this.window || global, (typeof define === 'function' ? define : function(factory) {
  module.exports = factory(require);
}));
