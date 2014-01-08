// Generated by CoffeeScript 1.6.3
(function() {
  var rnd, rnd_float_between, rnd_int_between, _;

  _ = require('underscore');

  rnd = function() {
    return Math.random();
  };

  rnd_float_between = function(min, max) {
    var delta, r;
    r = rnd();
    delta = max - min;
    return min + delta * r;
  };

  rnd_int_between = function(min, max) {
    var count, i, prob, r, total_prob, _i, _len, _ref;
    count = max - min + 1;
    prob = 1 / count;
    total_prob = prob;
    r = rnd();
    _ref = _.range(count);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      if (r <= total_prob) {
        return min + i;
      } else {
        total_prob += prob;
      }
    }
    return min + count - 1;
  };

  module.exports = {
    rnd: rnd,
    rnd_float_between: rnd_float_between,
    rnd_int_between: rnd_int_between
  };

}).call(this);