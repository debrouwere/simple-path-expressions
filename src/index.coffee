_ = require 'underscore'
placeholders = require './placeholders'
compiler = require './compiler'


exports.compile = compiler.compile


exports.match = (str, pattern, styles...) ->
    expression = compiler.compile pattern, styles...
    names = _.pluck expression.segments, 'name'
    matches = expression.exec str

    if matches is null
        null
    else
        _.object _.zip names, matches[1..]


class exports.InterpolationError extends Error
    name: 'InterpolationError'
    constructor: (@message) ->
        Error.captureStackTrace this, this.constructor


exports.fill = (path, map, styles...) ->
    patterns = placeholders.get styles...
    segments = compiler.analyze path, patterns...

    for segment in segments
        replacement = map[segment.name]

        if not replacement and segment.optional
            replacement = ''

        if replacement
            if segment.trailing
                replacement += '/'
        else
            if segment.optional
                replacement = ''
            else
                throw new exports.InterpolationError "no value provided for `#{segment.name}`"

        path = path.replace segment.match, replacement

    # get rid of any remaining regexp cruft
    path.replace /\((.+)\)/, '$1', 'g'
