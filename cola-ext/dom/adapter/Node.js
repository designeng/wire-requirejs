/*
MIT License (c) copyright B Cavalier & J Hann
*/

(function(define) {
  define(function(require) {
    /*
    Creates a cola adapter for interacting with dom nodes.  Be sure to
    unwatch any watches to prevent memory leaks in Internet Explorer 6-8.
    @constructor
    @param rootNode {Node}
    @param options {Object}
    */

    var NodeAdapter, bindingHandler, guess, guessBindingsFromDom;
    NodeAdapter = function(rootNode, options) {
      this._rootNode = rootNode;
      options.bindings = guessBindingsFromDom(this._rootNode, options);
      this._options = options;
      this._handlers = {};
      this._createItemToDomHandlers(options.bindings);
    };
    /*
    Tests whether the given object is a candidate to be handled by
    this adapter. Returns true if this is a DOMNode (or looks like one).
    @param obj
    @returns {Boolean}
    */

    guessBindingsFromDom = function(rootNode, options) {
      var bindings, nodeFinder, nodes;
      nodeFinder = void 0;
      nodes = void 0;
      bindings = void 0;
      bindings = options.bindings || {};
      nodeFinder = options.nodeFinder || options.querySelectorAll || options.querySelector;
      nodes = nodeFinder('[name],[data-cola-binding]', rootNode);
      if (nodes) {
        Array.prototype.forEach.call(nodes, function(n) {
          var attr, name;
          name = void 0;
          attr = void 0;
          attr = (n.name ? 'name' : 'data-cola-binding');
          name = guess.getNodePropOrAttr(n, attr);
          if (name && (name in bindings)) {
            bindings[name] = '[' + attr + '="' + name + '"]';
          }
        });
      }
      return bindings;
    };
    'use strict';
    bindingHandler = void 0;
    guess = void 0;
    bindingHandler = require('../bindingHandler');
    guess = require('../guess');
    NodeAdapter.prototype = {
      getOptions: function() {
        return this._options;
      },
      set: function(item) {
        this._item = item;
        this._itemToDom(item, this._handlers);
      },
      update: function(item) {
        this._item = item;
        this._itemToDom(item, item);
      },
      destroy: function() {
        this._handlers.forEach(function(handler) {
          if (handler.unlisten) {
            handler.unlisten();
          }
        });
      },
      properties: function(lambda) {
        lambda(this._item);
      },
      _itemToDom: function(item, hash) {
        var handler, p;
        p = void 0;
        handler = void 0;
        for (p in hash) {
          handler = this._handlers[p];
          if (handler) {
            handler(item);
          }
        }
      },
      _createItemToDomHandlers: function(bindings) {
        var creator;
        creator = void 0;
        creator = bindingHandler(this._rootNode, this._options);
        Object.keys(bindings).forEach((function(b) {
          this._handlers[b] = creator(bindings[b], b);
        }), this);
      }
    };
    NodeAdapter.canHandle = function(obj) {
      return obj && obj.tagName && obj.getAttribute && obj.setAttribute;
    };
    return NodeAdapter;
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory(require);
}));
