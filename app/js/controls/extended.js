define(["underscore"], function(_) {
  return _.mixin({
    argsToArray: function(args) {
      return Array.prototype.slice.call(args, 0);
    }
  });
});
