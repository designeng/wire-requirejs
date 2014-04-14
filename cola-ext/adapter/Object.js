/*
MIT License (c) copyright B Cavalier & J Hann
*/

(function(define) {
  define(function(require) {
    /*
    Adapter that handles a plain object or a promise for a plain object
    @constructor
    @param obj {Object|Promise}
    @param options {Object}
    */

    var ObjectAdapter, when_;
    ObjectAdapter = function(obj, options) {
      if (!options) {
        options = {};
      }
      this._obj = obj;
      this._options = options;
      if ('provide' in options) {
        this.provide = options.provide;
      }
    };
    'use strict';
    when_ = require('when');
    ObjectAdapter.prototype = {
      provide: true,
      update: function(item) {
        var self;
        self = this;
        return when_(this._obj, function(obj) {
          var updateSynchronously;
          updateSynchronously = function(item) {
            var p;
            for (p in item) {
              obj[p] = item[p];
            }
          };
          self.update = updateSynchronously;
          return updateSynchronously(item);
        });
      },
      properties: function(lambda) {
        var self;
        self = this;
        return when_(this._obj, function(obj) {
          var properties;
          properties = function(l) {
            l(obj);
          };
          self.properties = properties;
          return properties(lambda);
        });
      },
      getOptions: function() {
        return this._options;
      }
    };
    /*
    Tests whether the given object is a candidate to be handled by
    this adapter.  Returns true if the object is of type 'object'.
    @param obj
    @returns {Boolean}
    */

    ObjectAdapter.canHandle = function(obj) {
      return obj && (when_.isPromise(obj) || Object.prototype.toString.call(obj) === '[object Object]');
    };
    return ObjectAdapter;
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory(require);
}));
