/*
MIT License (c) copyright B Cavalier & J Hann
*/

(function(define) {
  define(function() {
    var collectInverses, concat, identity, slice, undef;
    identity = function(it) {
      return it;
    };
    /*
    Creates a transform function by composing the supplied transform
    functions.  If all the supplied transform functions have an inverse,
    the returned function will also have an inverse created by composing
    the inverses.
    
    @param transforms... {Array|Function} Array of functions, or varargs
    list of functions.
    
    @returns {Function} composed function, with composed inverse if
    all supplied transforms also have an inverse
    */

    /*
    Collects all .inverses of the supplied transforms.
    @param transforms {Array} array of transforms, either *all* or *none* of
    which must have .inverse functions.
    */

    collectInverses = function(transforms) {
      var i, inverse, inverses, len;
      inverse = void 0;
      inverses = void 0;
      inverses = [];
      i = 0;
      len = transforms.length;
      while (i < len) {
        inverse = transforms[i].inverse;
        if (typeof inverse === 'function') {
          inverses.push(inverse);
        }
        i++;
      }
      if (inverses.length > 0 && inverses.length !== transforms.length) {
        throw new Error('Either all or none of the supplied transforms must provide an inverse');
      }
      return inverses;
    };
    'use strict';
    concat = void 0;
    slice = void 0;
    undef = void 0;
    concat = Array.prototype.concat;
    slice = Array.prototype.slice;
    identity.inverse = identity;
    identity.inverse.inverse = identity;
    return function(transforms) {
      var composed, inverses, txList;
      composed = void 0;
      txList = void 0;
      inverses = void 0;
      if (arguments_.length === 0) {
        return identity;
      }
      txList = concat.apply([], slice.call(arguments_));
      composed = function() {
        var args, i, len;
        args = slice.call(arguments_);
        i = 0;
        len = txList.length;
        while (i < len) {
          args[0] = txList[i].apply(undef, args);
          i++;
        }
        return args[0];
      };
      inverses = collectInverses(txList);
      if (inverses.length) {
        composed.inverse = function() {
          var args, i;
          args = slice.call(arguments_);
          i = inverses.length - 1;
          while (i >= 0) {
            args[0] = inverses[i].apply(undef, args);
            --i;
          }
          return args[0];
        };
        composed.inverse.inverse = composed;
      }
      return composed;
    };
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory();
}));
