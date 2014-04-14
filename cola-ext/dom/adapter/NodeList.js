(function(define) {
  define(function(require) {
    /*
    Manages a collection of dom trees that are synced with a data
    collection.
    @constructor
    @param rootNode {Node} node to serve as a template for items
    in the collection / list.
    @param {object} options
    @param options.comparator {Function} comparator function to use for
    ordering nodes
    @param [options.containerNode] {Node} optional parent to all itemNodes. If
    omitted, the parent of rootNode is assumed to be containerNode.
    @param [options.querySelector] {Function} DOM query function
    @param [options.itemTemplateSelector] {String}
    @param [options.idAttribute] {String}
    @param [options.containerAttribute] {String}
    */

    var NodeAdapter, NodeListAdapter, SortedMap, allBindingStates, classList, colaListBindingStates, defaultIdAttribute, defaultTemplateSelector, findTemplateNode, listElementsSelector, setBindingStates, undef;
    NodeListAdapter = function(rootNode, options) {
      var container, self;
      container = void 0;
      self = void 0;
      if (!options) {
        options = {};
      }
      this._options = options;
      this.comparator = options.comparator;
      this.identifier = options.identifier;
      this._rootNode = rootNode;
      this._templateNode = findTemplateNode(rootNode, options);
      container = options.containerNode || this._templateNode.parentNode;
      if (!container) {
        throw new Error('No container node found for NodeListAdapter.');
      }
      this._containerNode = container;
      this._initTemplateNode();
      this._itemCount = undef;
      this._checkBoundState();
      self = this;
      this._itemData = new SortedMap(function(item) {
        return self.identifier(item);
      }, function(a, b) {
        return self.comparator(a, b);
      });
      this._itemsById = {};
    };
    /*
    Compares two data items.  Works just like the comparator function
    for Array.prototype.sort. This comparator is used to sort the
    items in the list.
    This property should be injected.  If not supplied, the list
    will rely on one assigned by cola.
    @param a {Object}
    @param b {Object}
    @returns {Number} -1, 0, 1
    */

    setBindingStates = function(states, node) {
      node.className = classList.addClass(states, classList.removeClass(allBindingStates, node.className));
    };
    findTemplateNode = function(root, options) {
      var node, useBestGuess;
      useBestGuess = void 0;
      node = void 0;
      useBestGuess = !options.itemTemplateSelector;
      if (options.querySelector) {
        node = options.querySelector(options.itemTemplateSelector || defaultTemplateSelector, root);
        if (!node && useBestGuess) {
          node = options.querySelector(listElementsSelector, root);
        }
      }
      if (!node && useBestGuess) {
        node = root.firstChild;
      }
      if (!node) {
        throw new Error('NodeListAdapter: could not find itemTemplate node');
      }
      return node;
    };
    'use strict';
    SortedMap = void 0;
    classList = void 0;
    NodeAdapter = void 0;
    defaultIdAttribute = void 0;
    defaultTemplateSelector = void 0;
    listElementsSelector = void 0;
    colaListBindingStates = void 0;
    allBindingStates = void 0;
    undef = void 0;
    SortedMap = require('../../SortedMap');
    classList = require('../classList');
    NodeAdapter = require('./Node');
    defaultTemplateSelector = '[data-cola-role="item-template"]';
    defaultIdAttribute = 'data-cola-id';
    listElementsSelector = 'tr,li';
    colaListBindingStates = {
      empty: 'cola-list-empty',
      bound: 'cola-list-bound',
      unbound: 'cola-list-unbound'
    };
    allBindingStates = Object.keys(colaListBindingStates).map(function(key) {
      return colaListBindingStates[key];
    }).join(' ');
    NodeListAdapter.prototype = {
      add: function(item) {
        var adapter, index;
        adapter = void 0;
        index = void 0;
        adapter = this._createNodeAdapter(item);
        index = this._itemData.add(item, adapter);
        if (index >= 0) {
          this._itemCount = (this._itemCount || 0) + 1;
          this._insertNodeAt(adapter._rootNode, index);
          this._checkBoundState();
          this._itemsById[this.identifier(item)] = item;
        }
      },
      remove: function(item) {
        var adapter, node;
        adapter = void 0;
        node = void 0;
        adapter = this._itemData.get(item);
        this._itemData.remove(item);
        if (adapter) {
          this._itemCount--;
          node = adapter._rootNode;
          node.parentNode.removeChild(node);
          this._checkBoundState();
          delete this._itemsById[this.identifier(item)];
        }
      },
      update: function(item) {
        var adapter, index, key;
        adapter = void 0;
        index = void 0;
        key = void 0;
        adapter = this._itemData.get(item);
        if (!adapter) {
          this.add(item);
        } else {
          this._updating = adapter;
          try {
            adapter.update(item);
            this._itemData.remove(item);
            index = this._itemData.add(item, adapter);
            key = this.identifier(item);
            this._itemsById[key] = item;
            this._insertNodeAt(adapter._rootNode, index);
          } finally {
            delete this._updating;
          }
        }
      },
      forEach: function(lambda) {
        this._itemData.forEach(lambda);
      },
      setComparator: function(comparator) {
        var i, self;
        i = 0;
        self = this;
        this.comparator = comparator;
        this._itemData.setComparator(comparator);
        this._itemData.forEach(function(adapter, item) {
          self._insertNodeAt(adapter._rootNode, i++);
        });
      },
      getOptions: function() {
        return this._options;
      },
      findItem: function(eventOrElement) {
        var id, idAttr, node;
        node = void 0;
        idAttr = void 0;
        id = void 0;
        if (!(eventOrElement && eventOrElement.target && eventOrElement.stopPropagation && eventOrElement.preventDefault || eventOrElement && eventOrElement.nodeName && eventOrElement.nodeType === 1)) {
          return;
        }
        node = (eventOrElement.nodeType ? eventOrElement : eventOrElement.target || eventOrElement.srcElement);
        if (!node) {
          return;
        }
        idAttr = this._options.idAttribute || defaultIdAttribute;
        while (true) {
          id = node.getAttribute(idAttr);
          if (!((id == null) && (node = node.parentNode) && node.nodeType === 1)) {
            break;
          }
        }
        return (id != null) && this._itemsById[id];
      },
      findNode: function(thing) {
        var data, item;
        item = void 0;
        data = void 0;
        if (!thing) {
          return;
        }
        if (typeof thing === 'string' || typeof thing === 'number') {
          item = this._itemsById[thing];
        } else {
          item = this.findItem(thing) || thing;
        }
        if (item != null) {
          data = this._itemData.get(item);
        }
        return data && data._rootNode;
      },
      comparator: undef,
      identifier: undef,
      destroy: function() {
        this._itemData.forEach(function(adapter) {
          adapter.destroy();
        });
      },
      _initTemplateNode: function() {
        var templateNode;
        templateNode = this._templateNode;
        if (templateNode.parentNode) {
          templateNode.parentNode.removeChild(templateNode);
        }
        if (templateNode.style.display) {
          templateNode.style.display = '';
        }
        if (templateNode.id) {
          templateNode.id = '';
        }
      },
      _createNodeAdapter: function(item) {
        var adapter, idAttr, node, origUpdate, self;
        node = void 0;
        adapter = void 0;
        idAttr = void 0;
        origUpdate = void 0;
        self = void 0;
        node = this._templateNode.cloneNode(true);
        adapter = new NodeAdapter(node, this._options);
        adapter.set(item);
        if (this.identifier) {
          idAttr = this._options.idAttribute || defaultIdAttribute;
          adapter._rootNode.setAttribute(idAttr, this.identifier(item));
        }
        origUpdate = adapter.update;
        self = this;
        adapter.update = function(item) {
          origUpdate.call(adapter, item);
          if (self._updating !== adapter) {
            self.update(item);
          }
        };
        return adapter;
      },
      _insertNodeAt: function(node, index) {
        var parent, refNode;
        parent = void 0;
        refNode = void 0;
        parent = this._containerNode;
        refNode = parent.childNodes[index];
        if (node !== refNode) {
          parent.insertBefore(node, refNode);
        }
      },
      _checkBoundState: function() {
        var isBound, isEmpty, states;
        states = void 0;
        isBound = void 0;
        isEmpty = void 0;
        states = [];
        isBound = this._itemCount != null;
        isEmpty = this._itemCount === 0;
        if (!isBound) {
          states.push(colaListBindingStates.unbound);
        }
        if (isEmpty) {
          states.push(colaListBindingStates.empty);
        }
        if (isBound && !isEmpty) {
          states.push(colaListBindingStates.bound);
        }
        setBindingStates(states.join(' '), this._rootNode);
      }
    };
    NodeListAdapter.canHandle = function(obj) {
      return obj && obj.tagName && obj.insertBefore && obj.removeChild;
    };
    return NodeListAdapter;
  });
})((typeof define === 'function' ? define : function(factory) {
  module.exports = factory(require);
}));
