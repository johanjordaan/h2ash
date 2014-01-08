_ = require 'underscore'

rnd_float_between = (min,max) ->
  r = Math.random()
  delta = max - min
  return min + delta*r

rnd_int_between = (min,max) ->
  count = max - min + 1
  prob = 1/count
  total_prob = prob
  r = Math.random()
  for i in _.range(count)
    if r<=total_prob
      return min+i
    else
      total_prob += prob
  return min+count-1


module.exports = 
  rnd_float_between : rnd_float_between
  rnd_int_between : rnd_int_between