/*
eventQueue
@author: brian
*/

(function(define) {
  define(function(require) {
    /*
    Queue an event for processing later
    @param source
    @param data
    @param type
    */

    /*
    Process an event immediately
    @param source
    @param data
    @param type
    */

    var enqueue, makeEventName, when_;
    makeEventName = function(prefix, name) {
      return prefix + name.charAt(0).toUpperCase() + name.substr(1);
    };
    when_ = void 0;
    enqueue = void 0;
    when_ = require('when');
    enqueue = require('../enqueue');
    return {
      makeBeforeEventName: function(name) {
        return makeEventName('before', name);
      },
      makeEventName: function(name) {
        return makeEventName('on', name);
      },
      queueEvent: function(source, data, type) {
        var queueNeedsRestart;
        queueNeedsRestart = this.queue.length === 0;
        this.queue.push({
          source: source,
          data: data,
          type: type
        });
        return queueNeedsRestart && this._dispatchNextEvent();
      },
      processEvent: function(source, data, type) {
        var self;
        self = this;
        this.inflight = when_(this.inflight).always(function() {
          return self.eventProcessor(source, data, type);
        });
        return this.inflight;
      },
      _dispatchNextEvent: function() {
        var deferred, event, remaining, self;
        event = void 0;
        remaining = void 0;
        deferred = void 0;
        self = void 0;
        self = this;
        event = this.queue.shift();
        remaining = this.queue.length;
        deferred = when_.defer();
        enqueue(function() {
          var inflight;
          inflight = event && self.processEvent(event.source, event.data, event.type);
          deferred.resolve(inflight);
        });
        if (remaining) {
          deferred.promise.always(function() {
            self._dispatchNextEvent();
          });
        }
        return deferred.promise;
      }
    };
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory(require);
}));
