((global, undef) ->
    noop = ->
    
    # Fake console if we need to
    addPackage = (pkgInfo) ->
        cfg = undefined
        loaderConfig.packages = []    unless loaderConfig.packages
        cfg = loaderConfig.packages
        pkgInfo.main = pkgInfo.main or pkgInfo.name
        cfg.push pkgInfo
        return
    if typeof global.console is undef
        global.console =
            log: noop
            error: noop
    doc = undefined
    head = undefined
    scripts = undefined
    script = undefined
    i = undefined
    baseUrl = undefined
    baseUrlSuffix = undefined
    selfName = undefined
    selfRegex = undefined
    loaders = undefined
    loader = undefined
    loaderName = undefined
    loaderPath = undefined
    loaderConfig = undefined
    selfName = 'test-config.js'
    selfRegex = new RegExp(selfName + '$')
    baseUrlSuffix = '../'
    loaderPath = 'test/curl/src/curl'
    doc = global.document
    head = doc.head or doc.getElementsByTagName('head')[0]
    
    # Find self script tag, use it to construct baseUrl
    i = 0
    scripts = head.getElementsByTagName('script')
    baseUrl = script.src.replace(selfName, '') + baseUrlSuffix    if selfRegex.test(script.src)    while (script = scripts[i++]) and not baseUrl
    
    # dojo configuration, in case we need it
    global.djConfig = baseUrl: baseUrl
    loaderConfig = global.curl =
        apiName: 'require' # friggin doh needs this
        baseUrl: baseUrl
        paths:
            curl: loaderPath

        
        #		pluginPath: 'curl/plugin',
        preload: []

    addPackage
        name: 'cola'
        location: '.'
        main: 'cola'

    addPackage
        name: 'dojo'
        location: 'test/lib/dojo'
        main: 'lib/main-browser'

    
    #	addPackage({ name: 'dijit', location: 'test/lib/dijit', main: 'lib/main' });
    #	addPackage({ name: 'sizzle', location: 'support/sizzle' });
    #	addPackage({ name: 'aop', location: 'support/aop' });
    addPackage
        name: 'when'
        location: 'test/when'
        main: 'when'

    
    # That's right y'all, document.write FTW
    doc.write '<script src="' + baseUrl + loaderPath + '.js' + '"></script>'
    return
) window