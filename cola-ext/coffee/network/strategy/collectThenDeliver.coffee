((define) ->
    define ->
        defaultCollectionProperty = undefined
        defaultPreserveCollection = undefined
        isArray = undefined
        undef = undefined
        defaultCollectionProperty = 'items'
        defaultPreserveCollection = false
        isArray = Array.isArray or (o) ->
            Object::toString.call(o) is '[object Array]'

        
        ###
        @param [options] {Object}
        @param [options.collectionProperty] {String} the name of the array
        that will hold the collected items on the collector. If the collector
        is an array, this option is ignored.
        @param [options.preserveCollection] {Boolean} set this to true to
        preserve any existing items in the collector when starting a new
        collection (i.e. a "collect" event happens).  Typically, you'd want
        to start a fresh collection each time, but this is a way to pre-
        load certain items.  This option is ignored if the collector is an
        array.
        @return {Function}
        
        @description
        Note: this strategy relies on select and unselect events carrying
        the data item with them. (This is the intended behavior, but devs
        have the option to send something else.)
        ###
        (options) ->
            
            # if we're currently collecting
            
            # cancel if we get another "collect" event
            
            # TODO: how do we notify the system why we canceled?
            # queue an "error" event?
            
            # watch for select
            
            # also watch for unselect events and remove events
            
            # watch for "submit" events
            
            # watch for cancel events
            
            # if we're not collecting
            
            # watch for "collect" events
            startCollecting = (data) ->
                collector = data or []
                
                # figure out where to collect
                if isArray(collector)
                    
                    # collector is the collection. append to it
                    collection = collector
                else
                    
                    # use a property on collector
                    collection = data[collProp]
                    collection = data[collProp] = []    unless collection
                
                # figure out if we need to remove any existing items
                collection.splice 0, collection.length    if not preserve and collection.length
                
                # create index
                index = {}
                return
            stopCollecting = ->
                collector = index = null
                return
            collect = (item, id) ->
                pos = index[id]
                index[id] = collection.push(item) - 1    if pos is undef
                return
            uncollect = (item, id) ->
                pos = index[id]
                if pos >= 0
                    collection.splice pos, 1
                    delete index[id]

                    adjustIndex pos
                return
            adjustIndex = (fromPos) ->
                id = undefined
                for id of index
                    index[id]--    if index[id] > fromPos
                return
            collProp = undefined
            preserve = undefined
            collector = undefined
            collection = undefined
            index = undefined
            options = {}    unless options
            collProp = options.collectionProperty or defaultCollectionProperty
            preserve = options.preserveCollection or defaultPreserveCollection
            return collectThenDeliver = (source, dest, data, type, api) ->
                if collector
                    if api.isBefore()
                        api.cancel()    if 'collect' is type
                    else if api.isAfter()
                        if type is 'select'
                            collect data, source.identifier(data)
                        else if type is 'unselect' or type is 'remove'
                            uncollect data, source.identifier(data)
                        else if 'submit' is type
                            api.queueEvent source, collector, 'deliver'
                            stopCollecting()
                        else stopCollecting()    if 'cancel' is type
                else
                    startCollecting data    if 'collect' is type    if api.isAfter()
                return

            return

    return
) (if typeof define is 'function' and define.amd then define else (factory) ->
    module.exports = factory()
    return
)