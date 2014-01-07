_ = require 'underscore'

nox = {}

nox.is_template = (object) ->
  if !object? 
    return false
  if !_.isObject(object) 
    return false

  return object._nox_template

nox.is_method = (object) ->
  if !object? 
    return false
  if !_.isObject(object) 
    return false

  return object._nox_method == true

nox.deep_clone = (source,directives) ->
  if(_.isFunction(source) || _.isNumber(source) || _.isString(source) || _.isBoolean(source))
    return source
  if(_.isArray(source))
    ret_val = []
    for i in source
      ret_val.push nox.deep_clone i
    return ret_val
  if(_.isObject(source))  
    ret_val = {}
    for key in _.keys(source)
      if directives? && directives.remove? && key in directives.remove
      else
        ret_val[key] = nox.deep_clone source[key],directives
    return ret_val

nox.probability = (probability,item) ->
  ret_val = 
    probability : probability
    item : item
  return ret_val  

nox.is_method_valid = (method) ->
  console.log 'xxxx',method
  if method._nox_errors.length > 0 
    return false
  
  for key in _.keys(method)
    if nox.is_method(method[key])
      if !nox.is_method_valid(method[key])
        return false
  return true

nox.is_template_valid = (template) ->
  if !template? 
    return false
  if !_.isObject(template) 
    return false
  if !nox.is_template(template)
    return false

  for key in _.keys(template)
    if nox.is_method(template[key])
      if !nox.is_method_valid(template[key])
        return false
  return true    

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
    # Excluse some of the internal fields
    #
    if key in ['_nox_template'] 
      continue

    if template[key]._nox_method == true
      ret_val[key] = template[key].run(ret_val)
    else 
      ret_val[key] = nox.deep_clone template[key]
  return ret_val  


nox.extend_fields = (fields,properties,directives) ->
  for key in _.keys(properties)
    # If the key does not exist in the source or (allows for new keys to be aded)
    # the properties value is not an object (allows methods to be overwritten by direct assignemnts)
    # the ret_val is not an object (allows overriding of direct value assignements)
    #   then simply deep_clone key from the parameters
    #  
    if directives? && directives.remove? && key in directives.remove
      delete fields[key]
    else  
      if !fields[key]? || !_.isObject(properties[key]) || !_.isObject(fields[key]) || nox.is_method(properties[key]) 
        fields[key] = nox.deep_clone properties[key]
      else
        nox.extend_fields fields[key],properties[key]

nox.extend_template = (source_template,name,properties,directives) ->
  # First copy the source_teplate as is
  #
  ret_val = nox.deep_clone(source_template,directives)
  nox.extend_fields ret_val,properties,directives
          
  return nox.create_template name,ret_val  

nox.de_nox = (o)->
  if _.isArray(o)
    for i in o
      nox.de_nox(i)
  else if _.isObject(o)
    delete o._parent
    delete o._nox_errors
    delete o._index
    delete o._nox_template_name
    for key in _.keys(o)
      nox.de_nox o[key]


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
  if !input.integer? then input.integer = false  

  ret_val = 
    _nox_method : true
    _nox_errors : []
    min : input.min
    max : input.max
    normal : input.normal
    integer : input.integer
    run : (target_object) ->
      if nox.check_fields @,['min','max','normal','integer']
        return @_nox_errors

      min = nox.resolve @min, target_object
      max = nox.resolve @max, target_object
      normal = nox.resolve @normal, target_object
      integer = nox.resolve @integer, target_object

      itterations = if normal then 3 else 1

      ret_val = 0
      diff = max-min 
      for i in _.range(itterations)
        if integer 
          ret_val += _.random(min,max)
        else 
          ret_val += min + diff*Math.random()
      ret_val = ret_val/itterations
      return ret_val
  return ret_val     

nox.rnd_int = (input) ->
  input.integer = true
  return nox.rnd input

nox.rnd_normal = (input) ->
  input.normal = true
  return nox.rnd input

nox.select = (input) ->
  if !input.count? then input.count = 1
  if !input.return_one? then input.return_one = false

  ret_val = 
    _nox_method : true
    _nox_errors : []
    count : input.count
    values : input.values
    return_one : input.return_one
    run : (target_object) -> 
      if nox.check_fields @,['values']
        return @_nox_errors

      count = nox.resolve @count, target_object
      values = nox.resolve @values, target_object
      return_one = nox.resolve @return_one, target_object


      # If the size of the list is 0 and we donr require only one then return an empty list
      #
      if count == 0 && !return_one
        return []

      if count !=1 && return_one
        @_nox_errors.push "To select one a count of exactly 1 is required."
        return @_nox_errors

      if _.size(values) == 0
        @_nox_errors.push "Values list should contain at least one value."
        return @_nox_errors

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
                ret_val.push nox.construct_template item.item,target_object,i
                break
              else
                if _.isString(item.item) && _.contains(_.keys(nox.templates),item.item)
                  ret_val.push nox.construct_template nox.templates[item.item],target_object,i
                  break
                else
                  ret_val.push item.item
                  break
            else 
              if nox.is_template item
                ret_val.push nox.construct_template item,target_object,i
                break
              else if _.isString(item) && _.contains(_.keys(nox.templates),item)
                ret_val.push nox.construct_template nox.templates[item],target_object,i
                break
              else
                ret_val.push item 
                break
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

