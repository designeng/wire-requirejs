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

    ClientEditView.prototype.template = void 0;

    ClientEditView.prototype.formSelector = void 0;

    ClientEditView.prototype.events = {
      "click .save": "onClick"
    };

    ClientEditView.prototype.initialize = function() {
      return console.log("ClientEditView inited");
    };

    ClientEditView.prototype.show = function(target) {
      return target;
    };

    ClientEditView.prototype.log = function(prop) {
      return console.log("PROP:", this[prop]);
    };

    ClientEditView.prototype.onClick = function(e) {
      this.getValues();
      return false;
    };

    ClientEditView.prototype.getValues = function() {
      var form, res;
      form = this.$el.find(this.formSelector)[0];
      res = this._form.getValues(form);
      return console.log("RESULT:::", res);
    };

    return ClientEditView;

  })(Marionette.Layout);
});
