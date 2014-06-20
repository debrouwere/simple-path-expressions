_ = require 'underscore'
filters = require './filters'
placeholders = require './placeholders'
{match, name} = require './utils'


annotate = (match) ->
    lastChar = match.match[match.match.length - 1]
    match.trailing = if lastChar is '/' then yes else no
    match.optional = _.contains placeholders.optional, match.pattern
    match.type = filters[match.type] or filters['*']
    match


grouper = _.partial name, _, ['name', 'optional', 'type']


exports.analyze = analyze = (str, patterns...) ->
    matches = match str, patterns...
    matches
        .map grouper
        .map annotate


exports.compile = (path, styles...) ->
    patterns = placeholders.get styles...
    segments = analyze path, patterns...

    # optional segments that span multiple placeholders
    path = path.replace /\((.+)\)/, '(?:$1)?', 'g'

    for segment in segments
        type = segment.type

        if segment.trailing
            replacement = "(?:(#{type})/?)"
        else
            replacement = "(#{type})"

        if segment.optional
            replacement += '?'

        path = path.replace segment.match, replacement

    expression = new RegExp "^#{path}$"
    expression.segments = segments
    expression