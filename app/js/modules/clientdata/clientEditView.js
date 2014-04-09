var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(["marionette"], function(Marionette) {
  var ClientEditView, _ref;
  return ClientEditView = (function(_super) {
    __extends(ClientEditView, _super);

    function ClientEditView() {
      _ref = ClientEditView.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    ClientEditView.prototype.template = null;

    ClientEditView.prototype.initialize = function() {
      return console.log("ClientEditView inited");
    };

    ClientEditView.prototype.show = function(target) {
      console.log("TEMPLATE", this.template);
      return target;
    };

    return ClientEditView;

  })(Marionette.Layout);
});
