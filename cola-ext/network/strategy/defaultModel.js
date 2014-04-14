(function(define) {
  define(function(require) {
    'use strict';
    var base, changeEvent, compose, syncAfterJoin, syncModel, validate;
    compose = void 0;
    base = void 0;
    syncAfterJoin = void 0;
    syncModel = void 0;
    validate = void 0;
    changeEvent = void 0;
    compose = require('./compose');
    base = require('./base');
    syncAfterJoin = require('./syncAfterJoin');
    syncModel = require('./syncModel');
    validate = require('./validate');
    changeEvent = require('./changeEvent');
    /*
    This is a composition of the strategies that Brian and I think
    make sense. :)
    
    @param options {Object} a conglomeration of all of the options for the
    strategies used.
    @param options.targetFirstItem {Boolean} if truthy, the strategy
    will automatically target the first item that is added to the network.
    If falsey, it will not automatically target.
    @param options.validator {Function} if provided, will be used
    to validate data items on add and update events
    
    @return {Function} a composite network strategy function
    */

    return function(options) {
      return compose([validate(options), changeEvent(options), syncAfterJoin(options), syncModel(options), base(options)]);
    };
  });
})((typeof define === 'function' && define.amd ? define : function(factory) {
  module.exports = factory(require);
}));
