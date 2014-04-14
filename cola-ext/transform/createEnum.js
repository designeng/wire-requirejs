/*
MIT License (c) copyright B Cavalier & J Hann
*/

(function(define) {
  define(function() {
    'use strict';
    var cleanPrototype, createEnumTransform;
    cleanPrototype = {};
    /*
    Creates a set of functions that will use the supplied options to
    transform (and reverse-transform) a string or array of strings into
    an object whose properties are the same as the properties in
    options.enumSet and whose values are true or false, depending
    on whether the supplied value matches property names on the
    enumSet.  The supplied value may be a string or an array of strings.
    If enumSet is an object and it's values are strings, it is also
    used as a map to transform the property names of the returned object.
    
    @param options {Object} a hashmap of options for the transform
    @param options.enumSet {Object} or {Array}
    @param options.multi {Boolean} optional. Set to true to allow multiple
    values to be returned from reverse().  Typically, you don't need to
    set this option unless reverse() may be called before transform().
    If transform() is called with an array, multi is auto-set to true.
    @returns {Function} function (value) { returns newValue; }
    
    @description Given the following binding, the data will be converted
    as follows.
    permissions: {
    node: 'myview',
    prop: 'classList',
    enumSet: {
    modify: 'can-edit-data',
    create: 'can-add-data',
    remove: 'can-delete-data'
    }
    }
    transform(['modify', 'create']) ==>
    {
    "can-edit-data": true,
    "can-add-data": true,
    "can-delete-data": false
    }
    reverse({ "can-add-data": true }) ==> ['create']
    */

    return createEnumTransform = function(enumSet, options) {
      var Begetter, beget, createEmptySet, createMap, createReverseMap, emptySet, enumReverse, enumTransform, isArrayLike, isString, map, multiValued, toString, unmap;
      enumTransform = function(value) {
        var i, len, multiValued, set, values;
        set = void 0;
        values = void 0;
        i = void 0;
        len = void 0;
        multiValued = isArrayLike(value);
        set = beget(emptySet);
        values = [].concat(value);
        len = values.length;
        i = 0;
        while (i < len) {
          if (values[i] in map) {
            set[map[values[i]]] = true;
          }
          i++;
        }
        return set;
      };
      enumReverse = function(set) {
        var p, values;
        values = void 0;
        p = void 0;
        values = [];
        for (p in set) {
          if (set[p] && p in unmap) {
            values.push(unmap[p]);
          }
        }
        if (multiValued === false) {
          return values[0];
        } else {
          return values;
        }
      };
      createMap = function(obj) {
        var i, len, map;
        map = void 0;
        i = void 0;
        len = void 0;
        if (isArrayLike(obj)) {
          map = {};
          len = obj.length;
          i = 0;
          while (i < len) {
            map[obj[i]] = obj[i];
            i++;
          }
        } else {
          map = beget(obj);
        }
        return map;
      };
      createReverseMap = function(map) {
        var p, unmap;
        unmap = void 0;
        p = void 0;
        unmap = {};
        for (p in map) {
          unmap[map[p]] = p;
        }
        return unmap;
      };
      createEmptySet = function(map) {
        var p, set;
        set = void 0;
        p = void 0;
        set = {};
        for (p in map) {
          set[p] = false;
        }
        return set;
      };
      toString = function(o) {
        return Object.prototype.toString.apply(o);
      };
      isString = function(obj) {
        return toString(obj) === '[object String]';
      };
      isArrayLike = function(obj) {
        return obj && obj.length && !isString(obj);
      };
      Begetter = function() {};
      beget = function(obj) {
        var newObj;
        newObj = void 0;
        Begetter.prototype = obj;
        newObj = new Begetter();
        Begetter.prototype = cleanPrototype;
        return newObj;
      };
      map = void 0;
      unmap = void 0;
      emptySet = void 0;
      multiValued = void 0;
      map = createMap(enumSet);
      unmap = createReverseMap(map);
      emptySet = createEmptySet(unmap);
      multiValued = options && options.multi;
      enumTransform.inverse = enumReverse;
      enumReverse.inverse = enumTransform;
      return enumTransform;
    };
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory();
}));
