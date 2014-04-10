var __slice = [].slice;

define(["marionette", "when", "Bacon"], function(Marionette, When, Bacon) {
  var $, init;
  init = function(Bacon, $) {
    var asJQueryObject, assertArrayOrJQueryObject, e, effectNames, effects, eventNames, events, nonEmpty, _, _fn, _fn1, _i, _j, _len, _len1;
    nonEmpty = function(x) {
      return x.length > 0;
    };
    assertArrayOrJQueryObject = function(x) {
      if (!(x instanceof jQuery || x instanceof Array)) {
        throw new Error('Value must be either a jQuery object or an Array of jQuery objects');
      }
    };
    asJQueryObject = function(x) {
      var element, obj, _i, _len;
      if (x instanceof jQuery) {
        return x;
      } else {
        obj = $();
        for (_i = 0, _len = x.length; _i < _len; _i++) {
          element = x[_i];
          if (element instanceof jQuery) {
            obj = obj.add(element);
          }
        }
        return obj;
      }
    };
    _ = {
      indexOf: Array.prototype.indexOf ? function(xs, x) {
        return xs.indexOf(x);
      } : function(xs, x) {
        var i, y, _i, _len;
        for (i = _i = 0, _len = xs.length; _i < _len; i = ++_i) {
          y = xs[i];
          if (x === y) {
            return i;
          }
        }
        return -1;
      }
    };
    $.fn.asEventStream = Bacon.$.asEventStream;
    Bacon.$.textFieldValue = function(element, initValue) {
      var autofillPoller, events, get;
      get = function() {
        return element.val() || "";
      };
      autofillPoller = function() {
        return Bacon.interval(50).take(10).map(get).filter(nonEmpty).take(1);
      };
      events = element.asEventStream("keyup input").merge(element.asEventStream("cut paste").delay(1)).merge(autofillPoller());
      return Bacon.Binding({
        initValue: initValue,
        get: get,
        events: events,
        set: function(value) {
          return element.val(value);
        }
      });
    };
    Bacon.$.checkBoxValue = function(element, initValue) {
      return Bacon.Binding({
        initValue: initValue,
        get: function() {
          return element.prop("checked") || false;
        },
        events: element.asEventStream("change"),
        set: function(value) {
          return element.prop("checked", value);
        }
      });
    };
    Bacon.$.selectValue = function(element, initValue) {
      return Bacon.Binding({
        initValue: initValue,
        get: function() {
          return element.val();
        },
        events: element.asEventStream("change"),
        set: function(value) {
          return element.val(value);
        }
      });
    };
    Bacon.$.radioGroupValue = function(radios, initValue) {
      assertArrayOrJQueryObject(radios);
      radios = asJQueryObject(radios);
      return Bacon.Binding({
        initValue: initValue,
        get: function() {
          return radios.filter(":checked").first().val();
        },
        events: radios.asEventStream("change"),
        set: function(value) {
          return radios.each(function(i, elem) {
            return $(elem).prop("checked", elem.value === value);
          });
        }
      });
    };
    Bacon.$.checkBoxGroupValue = function(checkBoxes, initValue) {
      assertArrayOrJQueryObject(checkBoxes);
      checkBoxes = asJQueryObject(checkBoxes);
      return Bacon.Binding({
        initValue: initValue,
        get: function() {
          return checkBoxes.filter(":checked").map(function(i, elem) {
            return $(elem).val();
          }).toArray();
        },
        events: checkBoxes.asEventStream("change"),
        set: function(value) {
          return checkBoxes.each(function(i, elem) {
            return $(elem).prop("checked", _.indexOf(value, $(elem).val()) >= 0);
          });
        }
      });
    };
    Bacon.$.ajax = function(params, abort) {
      return Bacon.fromPromise($.ajax(params), abort);
    };
    Bacon.$.ajaxGet = function(url, data, dataType, abort) {
      return Bacon.$.ajax({
        url: url,
        dataType: dataType,
        data: data
      }, abort);
    };
    Bacon.$.ajaxGetJSON = function(url, data, abort) {
      return Bacon.$.ajax({
        url: url,
        dataType: "json",
        data: data
      }, abort);
    };
    Bacon.$.ajaxPost = function(url, data, dataType, abort) {
      return Bacon.$.ajax({
        url: url,
        dataType: dataType,
        data: data,
        type: "POST"
      }, abort);
    };
    Bacon.$.ajaxGetScript = function(url, abort) {
      return Bacon.$.ajax({
        url: url,
        dataType: "script"
      }, abort);
    };
    Bacon.$.lazyAjax = function(params) {
      return Bacon.once(params).flatMap(Bacon.$.ajax);
    };
    Bacon.Observable.prototype.ajax = function() {
      return this.flatMapLatest(Bacon.$.ajax);
    };
    Bacon.Observable.prototype.toDeferred = function() {
      var dfd, value;
      value = void 0;
      dfd = $.Deferred();
      this.take(1).endOnError().subscribe(function(evt) {
        if (evt.hasValue()) {
          value = evt.value();
          return dfd.notify(value);
        } else if (evt.isError()) {
          return dfd.reject(evt.error);
        } else if (evt.isEnd()) {
          return dfd.resolve(value);
        }
      });
      return dfd;
    };
    eventNames = ["keydown", "keyup", "keypress", "click", "dblclick", "mousedown", "mouseup", "mouseenter", "mouseleave", "mousemove", "mouseout", "mouseover", "resize", "scroll", "select", "change", "submit", "blur", "focus", "focusin", "focusout", "load", "unload"];
    events = {};
    _fn = function(e) {
      return events[e + 'E'] = function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        return this.asEventStream.apply(this, [e].concat(__slice.call(args)));
      };
    };
    for (_i = 0, _len = eventNames.length; _i < _len; _i++) {
      e = eventNames[_i];
      _fn(e);
    }
    $.fn.extend(events);
    effectNames = ["animate", "show", "hide", "toggle", "fadeIn", "fadeOut", "fadeTo", "fadeToggle", "slideDown", "slideUp", "slideToggle"];
    effects = {};
    _fn1 = function(e) {
      return effects[e + 'E'] = function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        return Bacon.fromPromise(this[e].apply(this, args).promise());
      };
    };
    for (_j = 0, _len1 = effectNames.length; _j < _len1; _j++) {
      e = effectNames[_j];
      _fn1(e);
    }
    $.fn.extend(effects);
    return Bacon.$;
  };
  if (typeof module !== "undefined" && module !== null) {
    Bacon = require("baconjs");
    $ = require("jquery");
    module.exports = init(Bacon, BaconModel, $);
  } else {
    if (typeof define === "function" && define.amd) {
      define(["bacon", "jquery"], init);
    } else {
      init(this.Bacon, this.$);
    }
  }
  return function(options) {
    var bindFacet, doBind;
    doBind = function(facet, options, wire) {
      var target;
      target = facet.target;
      return When(wire({
        options: facet.options
      }), function(options) {
        var bindings, element, selector, to;
        to = options.options.to;
        bindings = options.options.bindings;
        selector = options.options.selector;
        if (!to) {
          throw new Error('plugin/colBind: "to" must be specified');
        }
        if (!bindings) {
          throw new Error('plugin/colBind: "bindings" must be specified');
        }
        element = target.$el.find(selector);
        element.asEventStream();
        collectionBinder.bind(to, element);
        return target;
      });
    };
    bindFacet = function(resolver, facet, wire) {
      return resolver.resolve(doBind(facet, options, wire));
    };
    return {
      context: {
        ready: function(resolver, wire) {
          return resolver.resolve();
        }
      },
      destroy: {},
      facets: {
        bind: {
          "ready:before": bindFacet
        }
      }
    };
  };
});
