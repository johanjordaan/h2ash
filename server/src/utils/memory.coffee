_ = require 'underscore'

rough_size_of_object = (object) ->
  objectList = []
  stack = [ object ]
  bytes = 0

  while stack.length
    value = stack.pop()

    if _.isBoolean(value)
      bytes += 4
    else if _.isString(value)
      bytes += value.length * 2
    else if _.isNumber(value)
      bytes += 8;
    else if _.isArray(value)
      for i in value
        stack.push value[i]
    else if _.isObject(value) && objectList.indexOf( value ) == -1
      objectList.push value
      for key in _.keys(value) 
        stack.push value[key]
  
  return bytes;

module.exports = 
  rough_size_of_object : rough_size_of_object

