_ = require 'underscore'

nox = {}

nox.is_template = (object) ->
  return object._nox_template

nox.templates = {}

nox.create_template = (name,properties) ->
  nox.templates[name] = properties
  return properties 

nox.construct_template = (template,parent,index) ->
  ret_val = 
    _nox_template : true
    _parent : parent
    _index : index
  for key in _.keys(template)
    if template[key]._nox_method == true
      if(parent?)
        target = @_parent.key +'.'+key 
      template[key]._target = target
      ret_val[key] = template[key].run(ret_val)
  return ret_val  

nox.deep_clone = (source) ->
  ret_val = {}
  #console.log '----'
  for key in _.keys(source)
    if(_.isObject(source[key]))
      if(!_.isFunction(source[key]) && !_.isArray(source[key]) && !_.isNumber(source[key]))
        #console.log 'Deep',key,source[key]
        ret_val[key] = nox.deep_clone(source[key])
      else 
        #console.log 'Shallow',key,source[key]
        ret_val[key] = source[key]
    else
      #console.log 'Shallow',key,source[key]
      ret_val[key] = source[key]
  return ret_val

nox.extend_template = (source_template,name,properties) ->
  ret_val = nox.deep_clone(source_template)
  for key in _.keys(properties)
    for property_key in _.keys(properties[key])
      ret_val[key][property_key] = properties[key][property_key]  
      
  return nox.create_template name,ret_val  

nox.resolve = (parameter,target_object) ->
  return if parameter._nox_method then parameter.run target_object else parameter

nox.const = (input) ->
  ret_val = 
    _nox_method : true
    value : input.value
    run : (target_object) ->
      if(@value._nox_method)
        return @value.run(target_object)
      else
        return @value
  return ret_val 

nox.method = (input) ->
  ret_val = 
    _nox_method : true
    method : input.method
    run : (target_object) ->
      if(@method._nox_method)
        return @method.run(target_object) target_object 
      else
        return @method target_object
  return ret_val

nox.rnd = (input) ->
  if !input.min? then input.min = 0
  if !input.normal? then input.normal = false  

  ret_val = 
    _nox_method : true
    min : input.min
    max : input.max
    floor : input.floor
    normal : input.normal
    run : (target_object) ->
      min = nox.resolve @min, target_object
      max = nox.resolve @max, target_object
      normal = nox.resolve @normal, target_object

      itterations = if normal then 3 else 1

      ret_val = 0
      diff = max-min 
      for i in _.range(itterations)
        ret_val += min + diff*Math.random()
      ret_val = ret_val/itterations
      return ret_val
  return ret_val     

nox.rnd_normal = (input) ->
  input.normal = true
  return nox.rnd input

nox.select = (input) ->
  if !input.count? then input.count = 1
  if !input.return_one? then input.return_one = false

  ret_val = 
    _nox_method : true
    count : input.count
    values : input.values
    return_one : input.return_one
    run : (target_object) ->
      count = nox.resolve @count, target_object
      values = nox.resolve @values, target_object
      return_one = nox.resolve @return_one, target_object
      
      default_probability = 1/_.size(values)

      ret_val = []
      for i in _.range(count)
        r = Math.random()
        total_probability = 0
        for item in values
          probability = if item.probability? then item.probability else default_probability
          total_probability += probability
          if r<=total_probability
            if item.item? && item.probability?
              if nox.is_template(item.item) 
                ret_val.push nox.construct_template item.item
              else
                if _.isString(item.item) && _.contains(_.keys(nox.templates),item.item)
                  ret_val.push nox.construct_template nox.templates[item.item]
                else
                  ret_val.push item.item
            else 
              if _.isString(item) && _.contains(_.keys(nox.templates),item)
                ret_val.push nox.construct_template nox.templates[item]
              else
                ret_val.push item 
      if return_one
        return ret_val[0]     
      else 
        return ret_val
  return ret_val    

nox.select_one = (input) ->
  input.count = 1
  input.return_one = true
  return nox.select input 
  






get_name = (target_object) ->
  if target_object.type == 'Orc'
    return 'HamishOrc'
  else
    return "No an orc"

YEAR = 
  name : 'Years'
  symbol : 'T'

MonsterTemplate = nox.create_template 'MonsterTemplate',
  type : nox.const
    value : 'Generic Monster'
  name : nox.const
    value : 'Generic Monster Name'
  age : nox.rnd
    min : 10
    max : 15
  color : nox.select_one
    values : ['Green','Brown','White']
  children : nox.select
    count : 3

OrcTemplate = nox.extend_template MonsterTemplate,'OrcTemplate',
  type : 
    value : 'Orc'
  name : 
    value : nox.method
      method : nox.const
        value : get_name
  age : 
    min : 20
    max : nox.rnd_normal
      min : 20 
      max : 40

  children : 
    values : ['OrcChildTemplate']  


OrcChildTemplate = nox.extend_template OrcTemplate,'OrcChildTemplate',
  children : nox.const
    value : []
  age : nox.rnd
    min : 0
    max : 14



#console.log MonsterTemplate
console.log OrcTemplate


#console.log nox.construct_template MonsterTemplate
console.log nox.construct_template OrcTemplate


