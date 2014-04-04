var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(["marionette"], function(Marionette) {
  var TableHeaderControl, _ref;
  return TableHeaderControl = (function(_super) {
    __extends(TableHeaderControl, _super);

    function TableHeaderControl() {
      _ref = TableHeaderControl.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    TableHeaderControl.prototype.template = "tableHeaderControl";

    TableHeaderControl.prototype.initialize = function() {
      return console.log("tableHeaderControl inited");
    };

    TableHeaderControl.prototype.setHeader = function(opt) {
      return console.log("setHeader", opt);
    };

    TableHeaderControl.prototype.onRender = function() {
      return console.log("rendered");
    };

    return TableHeaderControl;

  })(Marionette.CompositeView);
});
