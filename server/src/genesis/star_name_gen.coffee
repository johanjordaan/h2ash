_ = require 'underscore'
rnd = require '../utils/rnd'

consonants = _.uniq [
  'an','ta','res',
  'lu','na',
  'sa','gi','ta','ri','us',
  'vir','go',
  'plei','ades'
  'sol',
  'cen','tau','ry',
  'ji','ta',
  'ri','gel'
  'tau','rus'
  'pisc','es'
]

generate_name = () ->
  l = rnd.rnd_int_between(1,4)
  name = ''
  for v in _.range(l)
    r = rnd.rnd_int_between(0,consonants.length-1)
    name += consonants[r]

  name = name.replace 'aa','a'
  name = name.replace 'uu','uu'
  name = name.replace 'ii','i'

  return name


module.exports =
  generate_name : generate_name