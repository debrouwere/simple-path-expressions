// Generated by CoffeeScript 1.8.0
(function() {
  var _,
    __slice = [].slice;

  _ = require('underscore');

  exports.multimatch = function() {
    var i, match, matches, pattern, patterns, str, _i, _len;
    str = arguments[0], patterns = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    matches = [];
    i = -1;
    while (i++ < str.length) {
      for (_i = 0, _len = patterns.length; _i < _len; _i++) {
        pattern = patterns[_i];
        match = pattern.exec(str.slice(i));
        if (match !== null) {
          i += match[0].length - 1;
          match.unshift(pattern);
          matches.push(match);
          break;
        }
      }
    }
    return matches;
  };

  exports.name = function(match, groups) {
    var obj, pattern, values, _ref;
    _ref = match, pattern = _ref[0], match = _ref[1], values = 3 <= _ref.length ? __slice.call(_ref, 2) : [];
    obj = _.object(_.zip(groups, values));
    obj.pattern = pattern;
    obj.match = match;
    obj.index = match.index;
    return obj;
  };

}).call(this);
