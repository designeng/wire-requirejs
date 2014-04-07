var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(["wire", "marionette"], function(wire, Marionette) {
  var rootSpec;
  define("globalEvents", ["jquery", "underscore", "backbone"], function($, _, Backbone) {
    var GlobalEvents, globalEvents;
    GlobalEvents = (function() {
      GlobalEvents.prototype.htmlEvents = ['html:click'];

      GlobalEvents.prototype.windowsEvents = ['window:resize'];

      function GlobalEvents() {
        this.bindGlobalEvents();
      }

      GlobalEvents.prototype.bindGlobalEvents = function() {
        var _this = this;
        $(window).on('resize', function() {
          var sEvents;
          sEvents = _this.joinEvent('windowsEvents');
          return _this.trigger(sEvents, {
            width: $(window).width(),
            height: $(window).height()
          });
        });
        return $("html").on('click', function(e) {
          var sEvents;
          sEvents = _this.joinEvent('htmlEvents');
          return _this.trigger(sEvents, e);
        });
      };

      GlobalEvents.prototype.addHtmlEvent = function(eventName) {
        return this.htmlEvents.push(eventName);
      };

      GlobalEvents.prototype.removeHtmlEvent = function(eventName) {
        return this.htmlEvents = _.without(this.htmlEvents, eventName);
      };

      GlobalEvents.prototype.joinEvent = function(eventGroup) {
        return this[eventGroup].join(' ');
      };

      return GlobalEvents;

    })();
    GlobalEvents = _.extend(GlobalEvents, Backbone.Events);
    if (typeof globalEvents === "undefined" || globalEvents === null) {
      return globalEvents = new GlobalEvents();
    }
  });
  define("targetToMixin", ["marionette"], function(Marionette) {
    var TargetToMixin, _ref;
    return TargetToMixin = (function(_super) {
      __extends(TargetToMixin, _super);

      function TargetToMixin() {
        _ref = TargetToMixin.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      TargetToMixin.prototype.template = "";

      TargetToMixin.prototype.initialize = function() {
        console.log("targetToMixin");
        return this.onHtmlClick();
      };

      TargetToMixin.prototype.onHtmlClick = function() {
        return console.log("onHtmlClick----");
      };

      return TargetToMixin;

    })(Marionette.Controller);
  });
  rootSpec = {
    globalEvents: {
      module: "globalEvents"
    },
    targetToMixin: {
      create: {
        module: "targetToMixin"
      },
      listenTo: {
        globalEvents: {
          "html:click": "onHtmlClick"
        }
      }
    },
    $plugins: ["wire/debug", "listenTo"]
  };
  return describe("After wire rootSpec context created", function() {
    beforeEach(function(done) {
      var _this = this;
      return wire(rootSpec).then(function(ctx) {
        _this.ctx = ctx;
        return done();
      }).otherwise(function(err) {
        return console.log("ERROR", err);
      });
    });
    return it("targetToMixin", function(done) {
      expect(this.ctx.targetToMixin).toBeDefined();
      return done();
    });
  });
});
