/*
@license MIT License (c) copyright B Cavalier & J Hann
*/

/*
wire/cola plugin

wire is part of the cujo.js family of libraries (http://cujojs.com/)

Licensed under the MIT License at:
http://www.opensource.org/licenses/mit-license.php
*/

(function(define) {
  define(['when', './relational/propertiesKey', './comparator/byProperty'], function(when_, propertiesKey, byProperty) {
    var copyOwnProps, defaultComparator, defaultOn, defaultQuerySelector, defaultQuerySelectorAll, doBind, excludeOptions, initBindOptions;
    initBindOptions = function(incomingOptions, pluginOptions, resolver) {
      var comparator, identifier, options;
      options = void 0;
      identifier = void 0;
      comparator = void 0;
      if (resolver.isRef(incomingOptions)) {
        incomingOptions = {
          to: incomingOptions
        };
      }
      options = copyOwnProps(incomingOptions, pluginOptions);
      if (!options.querySelector) {
        options.querySelector = defaultQuerySelector;
      }
      if (!options.querySelectorAll) {
        options.querySelectorAll = defaultQuerySelectorAll;
      }
      if (!options.on) {
        options.on = defaultOn;
      }
      identifier = options.identifier;
      options.identifier = (typeof identifier === 'string' || Array.isArray(identifier) ? propertiesKey(identifier) : identifier);
      comparator = options.comparator || defaultComparator;
      options.comparator = (typeof comparator === 'string' ? byProperty(comparator) : comparator);
      return options;
    };
    doBind = function(facet, options, wire) {
      var target;
      target = facet.target;
      return when_(wire(initBindOptions(facet.options, options, wire.resolver)), function(options) {
        var to;
        to = options.to;
        if (!to) {
          throw new Error('wire/cola: "to" must be specified');
        }
        to.addSource(target, copyOwnProps(options));
        return target;
      });
    };
    /*
    We don't want to copy the module property from the plugin options, and
    wire adds the id property, so we need to filter that out too.
    @type {Object}
    */

    /*
    Copies own properties from each src object in the arguments list
    to a new object and returns it.  Properties further to the right
    win.
    
    @return {Object} a new object with own properties from all srcs.
    */

    copyOwnProps = function() {
      var dst, i, len, p, src;
      i = void 0;
      len = void 0;
      p = void 0;
      src = void 0;
      dst = void 0;
      dst = {};
      i = 0;
      len = arguments_.length;
      while (i < len) {
        src = arguments_[i];
        if (src) {
          for (p in src) {
            if (src.hasOwnProperty(p)) {
              dst[p] = src[p];
            }
          }
        }
        i++;
      }
      return dst;
    };
    defaultComparator = void 0;
    defaultQuerySelector = void 0;
    defaultQuerySelectorAll = void 0;
    defaultOn = void 0;
    excludeOptions = void 0;
    defaultComparator = byProperty('id');
    defaultQuerySelector = {
      $ref: 'dom.first!'
    };
    defaultQuerySelectorAll = {
      $ref: 'dom.all!'
    };
    defaultOn = {
      $ref: 'on!'
    };
    excludeOptions = {
      id: 1,
      module: 1
    };
    return {
      wire$plugin: function(pluginOptions) {
        var bindFacet, options, p;
        bindFacet = function(resolver, facet, wire) {
          resolver.resolve(doBind(facet, options, wire));
        };
        options = void 0;
        p = void 0;
        options = {};
        if (arguments_.length) {
          pluginOptions = arguments_[arguments_.length - 1];
          for (p in pluginOptions) {
            if (!(p in excludeOptions)) {
              options[p] = pluginOptions[p];
            }
          }
        }
        return {
          facets: {
            bind: {
              ready: bindFacet
            }
          }
        };
      }
    };
  });
})((typeof define === 'function' ? define : function(deps, factory) {
  module.exports = factory.apply(this, deps.map(require));
}));
