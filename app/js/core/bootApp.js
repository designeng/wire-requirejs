define(["appinstance", "overridden"], function(App) {
  App.addInitializer(function(options) {
    console.log("App.addInitializer", options);
    if (!options.regionSelector) {
      throw new Error("Application region not specified!");
    }
    return App.addRegions({
      root: options.regionSelector,
      tableRegion: "#table"
    });
  });
  App.getRegionManager = function() {
    return this._regionManager;
  };
  App.show = function(region, view) {
    return region.show(view);
  };
  App.showView = function(view) {
    this.tableRegion.show(view);
    return view;
  };
  return App;
});
