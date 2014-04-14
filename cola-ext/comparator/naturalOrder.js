/*
MIT License (c) copyright B Cavalier & J Hann
*/

(function(define) {
  define(function() {
    'use strict';
    return function(a, b) {
      if (a === b) {
        return 0;
      } else {
        if (a < b) {
          return -1;
        } else {
          return 1;
        }
      }
    };
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory();
}));
