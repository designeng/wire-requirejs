/*
@license MIT License (c) copyright B Cavalier & J Hann
*/

/*
Licensed under the MIT License at:
http://www.opensource.org/licenses/mit-license.php
*/

(function(define) {
  define(function() {
    'use strict';
    var compose;
    return compose = function(comparators) {
      if (!arguments_.length) {
        throw new Error('comparator/compose: No comparators provided');
      }
      comparators = arguments_;
      return function(a, b) {
        var i, len, result;
        result = void 0;
        len = void 0;
        i = void 0;
        i = 0;
        len = comparators.length;
        while (true) {
          result = comparators[i](a, b);
          if (!(result === 0 && ++i < len)) {
            break;
          }
        }
        return result;
      };
    };
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory();
}));
