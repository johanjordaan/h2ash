_ = require 'underscore'

lcg_parm = 
  seed : new Date().getTime()  
  a : 1103515245;
  c : 12345;
  m : Math.pow(2,32);

srand = (seed) ->
  lcg_parm.seed = seed

rand = () ->
  lcg_parm.seed = (lcg_parm.a*lcg_parm.seed+lcg_parm.c)%lcg_parm.m;
  return lcg_parm.seed

random = () ->
  return rand()/lcg_parm.m;

# This is done sothat when I create test code I don't have to replace Math.random
# but only rnd with a 'know value emitter'
#
rnd = () ->
  return random()

rnd_float_between = (min,max) ->
  r = rnd()
  delta = max - min
  return min + delta*r

rnd_int_between = (min,max) ->
  count = max - min + 1
  prob = 1/count
  total_prob = prob
  r = rnd()
  for i in _.range(count)
    if r<=total_prob
      return min+i
    else
      total_prob += prob
  return min+count-1

# These are the debugging/testing functions
#
_saved = random
fix_value = (value) ->
  random = () ->
    return value
restore = () ->
  random = _saved



module.exports = 
  srand : srand
  rand : rand
  random : random
  rnd : rnd
  rnd_float_between : rnd_float_between
  rnd_int_between : rnd_int_between

  fix_value : fix_value
  restore : restore
