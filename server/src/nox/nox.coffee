_ = require 'underscore'

nox = {}

nox.is_template = (object) ->
  return object._nox_template

nox.deep_clone = (source) ->
  if(_.isFunction(source) || _.isNumber(source) || _.isString(source))
    return source
  if(_.isArray(source))
    ret_val = []
    for i in source
      ret_val.push nox.deep_clone i
    return ret_val
  if(_.isObject(source))  
    ret_val = {}
    for key in _.keys(source)
      ret_val[key] = nox.deep_clone(source[key])
    return ret_val


nox.templates = {}

# Note this will owerwrite any other template by this name
nox.create_template = (name,properties) ->
  nox.templates[name] = properties
  properties._nox_template = true
  properties._nox_template_name = name
  return properties 

nox.construct_template = (template,parent,index) ->
  ret_val = 
    _parent : parent
    _index : index
    _nox_errors : []

  if !template?
    ret_val._nox_errors.push "Cannot construct template with undefined template parameter."
    return ret_val

  if _.isString(template)
    template_str = template
    template = nox.templates[template]
    if !template?
      ret_val._nox_errors.push "Cannot find template [#{template_str}]."
      return ret_val


  for key in _.keys(template)
    if template[key]._nox_method == true
      ret_val[key] = template[key].run(ret_val)
    else 
      ret_val[key] = nox.deep_clone template[key]
  return ret_val  


nox.extend_template = (source_template,name,properties) ->
  ret_val = nox.deep_clone(source_template)
  for key in _.keys(properties)
    for property_key in _.keys(properties[key])
      ret_val[key][property_key] = properties[key][property_key]  
      
  return nox.create_template name,ret_val  

nox.resolve = (parameter,target_object) ->
  return if parameter._nox_method then parameter.run target_object else parameter

nox.check_field = (field,field_name,errors) ->
  if !field?
    errors.push "Required field [#{field_name}] is missing."  

nox.check_fields = (source,field_list) ->
  for field in field_list
    nox.check_field source[field],field,source._nox_errors
  
  return _.size(source._nox_errors)>0

nox.const = (input) ->  
  ret_val = 
    _nox_method : true
    _nox_errors : []
    value : input.value
    run : (target_object) ->
      if nox.check_fields @,['value']
        return @_nox_errors

      value = nox.resolve @value,target_object
      return value
  return ret_val 

nox.method = (input) ->
  ret_val = 
    _nox_method : true
    _nox_errors : []
    method : input.method
    run : (target_object) ->
      if nox.check_fields @,['method']
        return @_nox_errors

      method = nox.resolve @method,target_object
      return method(target_object)
  return ret_val

nox.rnd = (input) ->
  if !input.min? then input.min = 0
  if !input.normal? then input.normal = false  

  ret_val = 
    _nox_method : true
    _nox_errors : []
    min : input.min
    max : input.max
    normal : input.normal
    run : (target_object) ->
      if nox.check_fields @,['min','max','normal']
        return @_nox_errors

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
      count = Math.floor nox.resolve @count, target_object
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
  

module.exports = nox

