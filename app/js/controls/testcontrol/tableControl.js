var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(["marionette"], function(Marionette) {
  var TableControl, _ref;
  return TableControl = (function(_super) {
    __extends(TableControl, _super);

    function TableControl() {
      _ref = TableControl.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    TableControl.prototype.template = "					<thead class='thead'/>					<tbody class='tbody'/>				";

    TableControl.prototype.regions = {
      thead: ".thead",
      tbody: ".tbody"
    };

    TableControl.prototype.initialize = function() {
      return console.log("TableControl inited");
    };

    TableControl.prototype.show = function(target) {
      console.log("show after init", target);
      return target;
    };

    TableControl.prototype.onRender = function() {
      console.log("@thead", this.thead);
      console.log("@tbody", this.tbody);
      this.thead.show(this.header);
      return this.tbody.show(this.body);
    };

    return TableControl;

  })(Marionette.Layout);
});