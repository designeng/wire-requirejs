(function(define) {
  define(function() {
    /*
    MessageChannel for browsers that support it
    From http://www.nonblocking.io/2011/06/windownexttick.html
    */

    var enqueue, initMessageChannel;
    initMessageChannel = function() {
      var channel, head, tail;
      channel = void 0;
      head = void 0;
      tail = void 0;
      channel = new MessageChannel();
      head = {};
      tail = head;
      channel.port1.onmessage = function() {
        var task;
        task = void 0;
        head = head.next;
        task = head.task;
        delete head.task;
        task();
      };
      return function(task) {
        tail = tail.next = {
          task: task
        };
        channel.port2.postMessage(0);
      };
    };
    'use strict';
    enqueue = void 0;
    if (typeof process !== 'undefined') {
      enqueue = process.nextTick;
    } else if (typeof msSetImmediate === 'function') {
      enqueue = msSetImmediate.bind(window);
    } else if (typeof setImmediate === 'function') {
      enqueue = setImmediate;
    } else if (typeof MessageChannel !== 'undefined') {
      enqueue = initMessageChannel();
    } else {
      enqueue = function(task) {
        setTimeout(task, 0);
      };
    }
    return enqueue;
  });
})((typeof define === 'function' && define.amd ? define : function(factory) {
  module.exports = factory();
}));
