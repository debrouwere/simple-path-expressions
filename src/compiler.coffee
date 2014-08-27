_ = require 'underscore'
filters = require './filters'
placeholders = require './placeholders'
utils = require './utils'


# annotate a regexp match from `utils.multimatch`
# with some useful metadata
annotate = (match) ->
    lastChar = match.match[match.match.length - 1]
    match.trailing = if lastChar is '/' then yes else no
    match.optional = _.contains placeholders.optional, match.pattern
    match.type = filters[match.type] or filters['*']
    match

# give names to captured groups
name = _.partial utils.name, _, ['name', 'optional', 'type']


class exports.InterpolationError extends Error
    name: 'InterpolationError'
    constructor: (@message) ->
        Error.captureStackTrace this, this.constructor


class exports.PathExp
    constructor: (@raw, @styles...) ->
        if not styles.length then styles = ['unix', 'ruby', 'python']
        @patterns = placeholders.get styles...
        @placeholders = @_analyze()
        @hasPlaceholders = new Boolean @placeholders.length
        @regexp = @_compile()

    _analyze: ->
        matches = utils.multimatch @raw, @patterns...
        matches
            .map name
            .map annotate

    _compile: ->
        # optional segments that span multiple placeholders
        path = @raw.replace /\((.+)\)/, '(?:$1)?', 'g'
        # characters that need to be escaped
        # TODO: to a better job of this
        path = path.replace '.', '\\.'

        for placeholder in @placeholders
            type = placeholder.type

            if placeholder.trailing
                replacement = "(?:(#{type})/?)"
            else
                replacement = "(#{type})"

            if placeholder.optional
                replacement += '?'

            path = path.replace placeholder.match, replacement

        expression = new RegExp "^#{path}$"
        expression.placeholders = @placeholders
        expression

    match: (str) ->
        names = _.pluck @placeholders, 'name'
        matches = @regexp.exec str

        if matches is null
            null
        else
            _.object _.zip names, matches[1..]

    replace: (str, flags) ->
        @regexp.replace str, flags

    fill: (map) ->
        path = @raw

        for placeholder in @placeholders
            replacement = map[placeholder.name]

            if not replacement and placeholder.optional
                replacement = ''

            if replacement
                if placeholder.trailing
                    replacement += '/'
            else
                if placeholder.optional
                    replacement = ''
                else
                    throw new exports.InterpolationError "no value provided for `#{placeholder.name}`"

            path = path.replace placeholder.match, replacement

        # get rid of any remaining regexp cruft
        path.replace /\((.+)\)/, '$1', 'g'

    toRegExp: ->
        @regexp

    toString: ->
        @raw
