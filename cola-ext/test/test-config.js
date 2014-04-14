(function(global, undef) {
  var addPackage, baseUrl, baseUrlSuffix, doc, head, i, loader, loaderConfig, loaderName, loaderPath, loaders, noop, script, scripts, selfName, selfRegex;
  noop = function() {};
  addPackage = function(pkgInfo) {
    var cfg;
    cfg = void 0;
    if (!loaderConfig.packages) {
      loaderConfig.packages = [];
    }
    cfg = loaderConfig.packages;
    pkgInfo.main = pkgInfo.main || pkgInfo.name;
    cfg.push(pkgInfo);
  };
  if (typeof global.console === undef) {
    global.console = {
      log: noop,
      error: noop
    };
  }
  doc = void 0;
  head = void 0;
  scripts = void 0;
  script = void 0;
  i = void 0;
  baseUrl = void 0;
  baseUrlSuffix = void 0;
  selfName = void 0;
  selfRegex = void 0;
  loaders = void 0;
  loader = void 0;
  loaderName = void 0;
  loaderPath = void 0;
  loaderConfig = void 0;
  selfName = 'test-config.js';
  selfRegex = new RegExp(selfName + '$');
  baseUrlSuffix = '../';
  loaderPath = 'test/curl/src/curl';
  doc = global.document;
  head = doc.head || doc.getElementsByTagName('head')[0];
  i = 0;
  scripts = head.getElementsByTagName('script');
  if ((function() {
    var _results;
    _results = [];
    while ((script = scripts[i++]) && !baseUrl) {
      _results.push(selfRegex.test(script.src));
    }
    return _results;
  })()) {
    baseUrl = script.src.replace(selfName, '') + baseUrlSuffix;
  }
  global.djConfig = {
    baseUrl: baseUrl
  };
  loaderConfig = global.curl = {
    apiName: 'require',
    baseUrl: baseUrl,
    paths: {
      curl: loaderPath
    },
    preload: []
  };
  addPackage({
    name: 'cola',
    location: '.',
    main: 'cola'
  });
  addPackage({
    name: 'dojo',
    location: 'test/lib/dojo',
    main: 'lib/main-browser'
  });
  addPackage({
    name: 'when',
    location: 'test/when',
    main: 'when'
  });
  doc.write('<script src="' + baseUrl + loaderPath + '.js' + '"></script>');
})(window);
