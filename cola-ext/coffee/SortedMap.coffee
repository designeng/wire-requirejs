###
MIT License (c) copyright B Cavalier & J Hann
###
((define) ->
    define ->
        
        ###
        @constructor
        @param identifier {Function}
        @param comparator {Function}
        ###
        SortedMap = (identifier, comparator) ->
            
            # identifier is required, comparator is optional
            @clear()
            
            ###
            Fetches a value item for the given key item or the special object,
            missing, if the value item was not found.
            @private
            @param keyItem
            @returns {Object} the value item that was set for the supplied
            key item or the special object, missing, if it was not found.
            ###
            @_fetch = (keyItem) ->
                symbol = identifier(keyItem)
                (if symbol of @_index then @_index[symbol] else missing)

            
            ###
            Performs a binary search to find the bucket position of a
            key item within the key items list.  Only used if we have a
            comparator.
            @private
            @param keyItem
            @param exactMatch {Boolean} if true, must be an exact match to the key
            item, not just the correct position for a key item that sorts
            the same.
            @returns {Number|Undefined}
            ###
            @_pos = (keyItem, exactMatch) ->
                getKey = (pos) ->
                    (if sorted[pos] then sorted[pos][0].key else {})
                pos = undefined
                sorted = undefined
                symbol = undefined
                sorted = @_sorted
                symbol = identifier(keyItem)
                pos = binarySearch(0, sorted.length, keyItem, getKey, comparator)
                pos = -1    unless symbol is identifier(sorted[pos][0].key)    if exactMatch
                pos

            @_bucketOffset = (bucketPos) ->
                total = undefined
                i = undefined
                total = 0
                i = 0
                while i < bucketPos
                    total += @_sorted[i].length
                    i++
                total

            unless comparator
                @_pos = (keyItem, exact) ->
                    (if exact then -1 else @_sorted.length)
            
            ###
            Given a keyItem and its bucket position in the list of key items,
            inserts an value item into the bucket of value items.
            This method can be overridden by other objects that need to
            have objects in the same order as the key values.
            @private
            @param valueItem
            @param keyItem
            @param pos
            @returns {Number} the absolute position of this item amongst
            all items in all buckets.
            ###
            @_insert = (keyItem, pos, valueItem) ->
                pair = undefined
                symbol = undefined
                entry = undefined
                absPos = undefined
                
                # insert into index
                pair =
                    key: keyItem
                    value: valueItem

                symbol = identifier(keyItem)
                @_index[symbol] = pair
                
                # insert into sorted table
                if pos >= 0
                    absPos = @_bucketOffset(pos)
                    entry = @_sorted[pos] and @_sorted[pos][0]
                    
                    # is this a new row (at end of array)?
                    unless entry
                        @_sorted[pos] = [pair]
                    
                    # are there already items of the same sort position here?
                    else if comparator(entry.key, keyItem) is 0
                        absPos += @_sorted[pos].push(pair) - 1
                    
                    # or do we need to insert a new row?
                    else
                        @_sorted.splice pos, 0, [pair]
                else
                    absPos = -1
                absPos

            
            ###
            Given a key item and its bucket position in the list of key items,
            removes a value item from the bucket of value items.
            This method can be overridden by other objects that need to
            have objects in the same order as the key values.
            @private
            @param keyItem
            @param pos
            @returns {Number} the absolute position of this item amongst
            all items in all buckets.
            ###
            @_remove = remove = (keyItem, pos) ->
                symbol = undefined
                entries = undefined
                i = undefined
                entry = undefined
                absPos = undefined
                symbol = identifier(keyItem)
                
                # delete from index
                delete @_index[symbol]

                
                # delete from sorted table
                if pos >= 0
                    absPos = @_bucketOffset(pos)
                    entries = @_sorted[pos] or []
                    i = entries.length
                    
                    # find it and remove it
                    while (entry = entries[--i])
                        if symbol is identifier(entry.key)
                            entries.splice i, 1
                            break
                    absPos += i
                    
                    # if we removed all pairs at this position
                    @_sorted.splice pos, 1    if entries.length is 0
                else
                    absPos = -1
                absPos

            @_setComparator = (newComparator) ->
                p = undefined
                pair = undefined
                pos = undefined
                comparator = newComparator
                @_sorted = []
                for p of @_index
                    pair = @_index[p]
                    pos = @_pos(pair.key)
                    @_insert pair.key, pos, pair.value
                return

            return
        
        # don't insert twice. bail if we already have it
        
        # find pos and insert
        
        # don't remove if we don't already have it
        
        # find positions and delete
        
        # hashmap of object-object pairs
        
        # 2d array of objects
        
        ###
        Searches through a list of items, looking for the correct slot
        for a new item to be added.
        @param min {Number} points at the first possible slot
        @param max {Number} points at the slot after the last possible slot
        @param item anything comparable via < and >
        @param getter {Function} a function to retrieve a item at a specific
        slot: function (pos) { return items[pos]; }
        @param comparator {Function} function to compare to items. must return
        a number.
        @returns {Number} returns the slot where the item should be placed
        into the list.
        ###
        binarySearch = (min, max, item, getter, comparator) ->
            mid = undefined
            compare = undefined
            return min    if max <= min
            loop
                mid = Math.floor((min + max) / 2)
                compare = comparator(item, getter(mid))
                throw new Error('SortedMap: invalid comparator result ' + compare)    if isNaN(compare)
                
                # if we've narrowed down to a choice of just two slots
                return (if compare is 0 then mid else (if compare > 0 then max else min))    if max - min <= 1
                
                # don't use mid +/- 1 or we may miss in-between values
                if compare > 0
                    min = mid
                else if compare < 0
                    max = mid
                else
                    return mid
                break unless true
            return
        undef = undefined
        missing = {}
        SortedMap:: =
            get: (keyItem) ->
                pair = undefined
                pair = @_fetch(keyItem)
                (if pair is missing then undef else pair.value)

            add: (keyItem, valueItem) ->
                pos = undefined
                absPos = undefined
                throw new Error('SortedMap.add: must supply keyItem and valueItem args')    if arguments_.length < 2
                return    unless @_fetch(keyItem) is missing
                pos = @_pos(keyItem)
                absPos = @_insert(keyItem, pos, valueItem)
                absPos

            remove: (keyItem) ->
                valueItem = undefined
                pos = undefined
                absPos = undefined
                valueItem = @_fetch(keyItem)
                return    if valueItem is missing
                pos = @_pos(keyItem, true)
                absPos = @_remove(keyItem, pos)
                absPos

            forEach: (lambda) ->
                i = undefined
                j = undefined
                len = undefined
                len2 = undefined
                entries = undefined
                i = 0
                len = @_sorted.length

                while i < len
                    entries = @_sorted[i]
                    j = 0
                    len2 = entries.length

                    while j < len2
                        lambda entries[j].value, entries[j].key
                        j++
                    i++
                return

            clear: ->
                @_index = {}
                @_sorted = []
                return

            setComparator: (comparator) ->
                @_setComparator comparator
                return

        return SortedMap
        return

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)