/*
MIT License (c) copyright B Cavalier & J Hann
*/

(function(define) {
  define(function(require) {
    /*
    Decorator that applies transforms to properties flowing in
    and out of an ObjectAdapter (or similar).
    @param adapter {Object}
    @param transforms {Object}
    */

    var SortedMap, addPropertyTransforms, hasProperties, identity, transformItem, untransformItem;
    addPropertyTransforms = function(adapter, transforms) {
      var origAdd, origForEach, origGet, origUpdate, transformedAdd, transformedForEach, transformedGet, transformedItemMap, transformedUpdate;
      origGet = void 0;
      origAdd = void 0;
      origUpdate = void 0;
      origForEach = void 0;
      transformedItemMap = void 0;
      if (transforms && hasProperties(transforms)) {
        origGet = adapter.get;
        origAdd = adapter.add;
        origUpdate = adapter.update;
        origForEach = adapter.forEach;
        transformedItemMap = new SortedMap(adapter.identifier, adapter.comparator);
        if (origGet) {
          adapter.get = transformedGet = function(id) {
            return untransformItem(origGet.call(adapter, id), transforms, transformedItemMap);
          };
        }
        if (origAdd) {
          adapter.add = transformedAdd = function(item) {
            return origAdd.call(adapter, transformItem(item, transforms, transformedItemMap));
          };
        }
        if (origUpdate) {
          adapter.update = transformedUpdate = function(item) {
            return origUpdate.call(adapter, transformItem(item, transforms, transformedItemMap));
          };
        }
        if (origForEach) {
          adapter.forEach = transformedForEach = function(lambda) {
            var transformedLambda;
            transformedLambda = function(item, key) {
              var inverted;
              inverted = untransformItem(item, transforms, transformedItemMap);
              return lambda(inverted, key);
            };
            return origForEach.call(adapter, transformedLambda);
          };
        }
      }
      return adapter;
    };
    identity = function(val) {
      return val;
    };
    hasProperties = function(obj) {
      var p;
      for (p in obj) {
        continue;
      }
    };
    transformItem = function(item, transforms, map) {
      var name, transform, transformed;
      transformed = void 0;
      name = void 0;
      transform = void 0;
      transformed = {};
      for (name in item) {
        transform = transforms[name] || identity;
        transformed[name] = transform(item[name], name, item);
      }
      for (name in transforms) {
        if (!(name in item)) {
          transformed[name] = transforms[name](null, name, item);
        }
      }
      map.remove(transformed);
      map.add(transformed, item);
      return transformed;
    };
    untransformItem = function(transformed, transforms, map) {
      var name, origItem, transform;
      origItem = void 0;
      name = void 0;
      transform = void 0;
      origItem = map.get(transformed);
      for (name in origItem) {
        transform = transforms[name] && transforms[name].inverse;
        if (transform) {
          origItem[name] = transform(transformed[name], name, transformed);
        }
      }
      return origItem;
    };
    'use strict';
    SortedMap = require('./../SortedMap');
    return addPropertyTransforms;
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory(require);
}));
