(function(define) {
  define(function() {
    var defaultCollectionProperty, defaultPreserveCollection, isArray, undef;
    defaultCollectionProperty = void 0;
    defaultPreserveCollection = void 0;
    isArray = void 0;
    undef = void 0;
    defaultCollectionProperty = 'items';
    defaultPreserveCollection = false;
    isArray = Array.isArray || function(o) {
      return Object.prototype.toString.call(o) === '[object Array]';
    };
    /*
    @param [options] {Object}
    @param [options.collectionProperty] {String} the name of the array
    that will hold the collected items on the collector. If the collector
    is an array, this option is ignored.
    @param [options.preserveCollection] {Boolean} set this to true to
    preserve any existing items in the collector when starting a new
    collection (i.e. a "collect" event happens).  Typically, you'd want
    to start a fresh collection each time, but this is a way to pre-
    load certain items.  This option is ignored if the collector is an
    array.
    @return {Function}
    
    @description
    Note: this strategy relies on select and unselect events carrying
    the data item with them. (This is the intended behavior, but devs
    have the option to send something else.)
    */

    return function(options) {
      var adjustIndex, collProp, collect, collectThenDeliver, collection, collector, index, preserve, startCollecting, stopCollecting, uncollect;
      startCollecting = function(data) {
        var collection, collector, index;
        collector = data || [];
        if (isArray(collector)) {
          collection = collector;
        } else {
          collection = data[collProp];
          if (!collection) {
            collection = data[collProp] = [];
          }
        }
        if (!preserve && collection.length) {
          collection.splice(0, collection.length);
        }
        index = {};
      };
      stopCollecting = function() {
        var collector, index;
        collector = index = null;
      };
      collect = function(item, id) {
        var pos;
        pos = index[id];
        if (pos === undef) {
          index[id] = collection.push(item) - 1;
        }
      };
      uncollect = function(item, id) {
        var pos;
        pos = index[id];
        if (pos >= 0) {
          collection.splice(pos, 1);
          delete index[id];
          adjustIndex(pos);
        }
      };
      adjustIndex = function(fromPos) {
        var id;
        id = void 0;
        for (id in index) {
          if (index[id] > fromPos) {
            index[id]--;
          }
        }
      };
      collProp = void 0;
      preserve = void 0;
      collector = void 0;
      collection = void 0;
      index = void 0;
      if (!options) {
        options = {};
      }
      collProp = options.collectionProperty || defaultCollectionProperty;
      preserve = options.preserveCollection || defaultPreserveCollection;
      return collectThenDeliver = function(source, dest, data, type, api) {
        if (collector) {
          if (api.isBefore()) {
            if ('collect' === type) {
              api.cancel();
            }
          } else if (api.isAfter()) {
            if (type === 'select') {
              collect(data, source.identifier(data));
            } else if (type === 'unselect' || type === 'remove') {
              uncollect(data, source.identifier(data));
            } else if ('submit' === type) {
              api.queueEvent(source, collector, 'deliver');
              stopCollecting();
            } else {
              if ('cancel' === type) {
                stopCollecting();
              }
            }
          }
        } else {
          if (api.isAfter() ? 'collect' === type : void 0) {
            startCollecting(data);
          }
        }
      };
    };
  });
})((typeof define === 'function' && define.amd ? define : function(factory) {
  module.exports = factory();
}));
