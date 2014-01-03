_ = require 'underscore'

construct = (type,parent,index) ->
  ret_val = 
    _parent : parent
    _index : index

  methods = []  
  for key in _.keys(type)
    ret_val[key] = type[key].run(ret_val)

  return ret_val  

fixed = (p) ->
  ret_val =
    value : p.value
    run : (self) ->
      return @value
  return ret_val

rnd_variable = (p) ->
  if !p.min? 
    p.min = 0
  if !p.floor? 
    p.floor = false
  if !p.distribution? 
    p.distribution = 1  

  ret_val = 
    min : p.min
    max : p.max
    floor : p.floor
    distribution : p.distribution
    run : (self) ->
      ret_val = 0
      for i in _.range(@distribution)
        ret_val += _.random(@min,@max)
      ret_val = ret_val/@distribution
      if @floor
        ret_val = Math.floor(ret_val)
      return ret_val     
# 
variance = (p) ->
  if !p.variance
    p.variance = 0

  ret_val = 
    mean : p.mean
    variance : p.variance
    run : (self) ->
      mean = @mean
      if(_.isObject(mean))
        mean = mean.run()      
      return mean + mean*@variance * (0.5 - Math.random())    

select_one = (values) ->
  ret_val = 
    values : values
    run : (self) ->
      r = Math.random()
      default_probability = 1/_.size(@values)
      total_probability = 0
      for v in @values
        probability = default_probability
        if v.probability?
          probability = v.probability
        total_probability += probability
        if r<=total_probability
          if v.type? && v.probability?
            return v.type
          else 
            return v

select_type_create_instance = (values) ->
  ret_val =
    type : select_one values 
    run : (self) ->
      type = @type.run()
      return construct type,self

probability = (p) ->
  ret_val =
    percentage : p.percentage
    run : (self) ->
      return Math.random()<=@percentage

select_list = (p) ->
  ret_val = 
    size : p.size
    item : p.item
    run : (self) ->
      ret_val = []
      if _.isObject(@size)
        list_size = @size.run()
      else 
        list_size = @size
      for i in _.range list_size
        type = @item.run()
        new_item = construct type,self,i
        ret_val.push new_item 
      return ret_val

range = (p) ->
  ret_val = 
    from : p.from
    to : p.to
    run : (self) ->
      diff = @to - @from
      delta = diff * Math.random()
      return @from + delta 

method = (p) ->
  ret_val = 
    method : p.method
    run : (self) ->
      return @method self



module.exports = 
  construct : construct
  fixed : fixed
  rnd_variable : rnd_variable
  variance : variance
  select_one : select_one
  select_type_create_instance : select_type_create_instance
  probability : probability
  select_list : select_list
  range : range
  method : method




