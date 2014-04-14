###
MIT License (c) copyright B Cavalier & J Hann
###
((define) ->
    define (require) ->
        'use strict'
        hashJoin = undefined
        createPropertiesKey = undefined
        defaultProjection = undefined
        hashJoin = require('../hashJoin')
        createPropertiesKey = require('../propertiesKey')
        defaultProjection = require('../../projection/inherit')
        
        ###
        Creates a join strategy that will perform a left outer hash join
        using the supplied options, using supplied key functions to generate
        hash keys for correlating items.
        @param options.leftKeyFunc {Function} function to create a join key
        for items on the left
        @param [options.rightKeyFunc] {Function} function to create a join key
        for items on the right.  If not provided, options.leftKeyFunc will be used
        @param [options.projection] {Function} function to project joined left
        and right values into a final join result
        @param [options.multiValue] {Boolean} if truthy, allows the projection to
        act on the complete set of correlated right-hand items, rather than on each
        distinct left-right pair.
        ###
        createLeftOuterJoinStrategy = (options) ->
            leftKeyFunc = undefined
            rightKeyFunc = undefined
            projection = undefined
            multiValue = undefined
            throw new Error('options.leftKeyFunc must be provided')    unless options and options.leftKey
            leftKeyFunc = options.leftKey
            leftKeyFunc = createPropertiesKey(leftKeyFunc)    unless typeof leftKeyFunc is 'function'
            rightKeyFunc = options.rightKey or leftKeyFunc
            rightKeyFunc = createPropertiesKey(rightKeyFunc)    unless typeof rightKeyFunc is 'function'
            projection = options.projection or defaultProjection
            multiValue = options.multiValue
            
            # Return the join strategy
            outerHashJoin = (left, right) ->
                hashJoin.leftOuterJoin left, leftKeyFunc, right, rightKeyFunc, projection, multiValue

    return
) (if typeof define is 'function' then define else (factory) ->
    module.exports = factory(require)
    return
)