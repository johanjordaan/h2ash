should = require('chai').should()
expect = require('chai').expect
_ = require 'underscore'

nox = require '../../nox/nox'

saved_random = Math.random

fix_random_value = (value) ->
  fix_random_values [value]

fix_random_values = (values) ->
  values = values.reverse()
  Math.random = () ->
    value = values.pop()
    fix_random_values values.reverse()
    if values.length==0
      Math.random = saved_random
    return value

describe 'nox.create_template', () ->
  describe '- basic uasge : ', () ->
    test_template = nox.create_template 'test_template',
      some_field : nox.const
        value : 'some_value'

    it 'should set the _nox_template flag', () ->
      test_template._nox_template.should.equal true

    it 'should set the _nox_template_name to the name of the template', () ->
      test_template._nox_template_name.should.equal 'test_template'

    it 'should add the template to the list of templates', () ->
      ('test_template' in _.keys(nox.templates)).should.equal true  

#describe 'nox.is_template_validate', () ->
#  describe '- basic usage : ', () ->
#    x_template = nox.create_template 'x_template',
#      name : nox.const
#        value : nox.const
#          xxx : "What is this"
#      surname : nox.rnd
#        no_max : 10
#
#    it 'should detect errors on any level of the template', () ->
#      nox.is_template_valid(x_template).should.equal false
#
    #it 'should detect a valid template', () ->
    #  valid_template  = nox.create_template 'valid',
    #    name : "hallo"
    #
    #  nox.is_template_valid(valid_template).should.equal true



describe 'nox.construct_template', () ->
  describe '- basic usage : ', () ->
    
    parent_template = nox.create_template 'parent_template',
      parent_val : nox.const
        value : 'parent_value'
    parent_instance = nox.construct_template parent_template

    it 'should set _parent to unefined since this has no parent', () ->
      expect(parent_instance._parent).to.not.exist

    it 'should set _index to unefined since this has no parent', () ->
      expect(parent_instance._parent).to.not.exist

    it 'should set the value of parent_val to parent_value', () ->
        parent_instance.parent_val.should.equal 'parent_value'

    test_template = nox.create_template 'test_template',
      some_field : nox.const
        value : 'some_value'
      non_nox_value : 'Hallo'
    test_instance = nox.construct_template test_template,parent_instance,3

    it 'should set _parent to the provided parent (parent_instance)', () ->
      test_instance._parent.should.equal parent_instance

    it 'should set _index to the provided index (3)', () ->
      test_instance._index.should.equal 3

    it 'should set the _nox_template_name of the isntance to the name of the template used to create it', () ->
      test_instance._nox_template_name.should.equal 'test_template'  

    it 'should copy any non nox values directly to the result', () ->
      test_instance.non_nox_value.should.equal "Hallo"  

  describe '- string based construction usage : ', () ->
    parent_template = nox.create_template 'parent_template',
      parent_val : nox.const
        value : 'parent_value'
    parent_instance = nox.construct_template 'parent_template'

    it 'should set _parent to unefined since this has no parent', () ->
      expect(parent_instance._parent).to.not.exist

    it 'should set _index to unefined since this has no parent', () ->
      expect(parent_instance._parent).to.not.exist

    it 'should set the value of parent_val to parent_value', () ->
        parent_instance.parent_val.should.equal 'parent_value'

    
  describe '- error conditions : ', () ->
    xxx = {}     
    parent_instance = nox.construct_template xxx.a

    it 'should return an error list if template passed to the constructor does not exist', () ->
      parent_instance._nox_errors.should.be.a 'Array'
      parent_instance._nox_errors.length.should.equal 1 

    it 'should return a usable error message', () ->
      parent_instance._nox_errors[0].should.equal "Cannot construct template with undefined template parameter."    

    string_instance = nox.construct_template 'some_silly_template'

    it 'should tell the user which template it could not find', () ->
      string_instance._nox_errors[0].should.equal "Cannot find template [some_silly_template]."

describe 'nox.extend_template', () ->
  describe '- basic usage (using the actual template class as input) : ', () ->
    base_template = nox.create_template 'base_template',
      name : nox.const
        value : 'name_field'
      type : nox.const
        value : 'type_field'
      age : nox.const
        value : 100 
      city : "Joburg" 
      some_field : "some_field"
      another : nox.rnd
        max : 10

    child_template = nox.extend_template base_template,'child_template',
      type : 
        value : 'child_type'                    ## Overriding existing field's parameters
      child_field : nox.const                   ## Adding new field
        value : 'child specific field'
      age : nox.rnd                             ## Override the function
        max : 80
      city : "Pretoria"
      some_field : nox.const
        value : "not_some_value"
      another : "not 10"

    it 'should set the name of the extended template to the name specified', () ->
      child_template._nox_template_name.should.equal 'child_template'

    it 'should add the base class fields to the extended template', () ->
      expect(child_template.name).to.exist      
      child_template.name.value.should.equal 'name_field'

    it 'should override existing fields parameters ', () ->
      expect(child_template.type).to.exist      
      child_template.type.value.should.equal 'child_type'

    it 'should add any new fields from the child template ', () ->
      expect(child_template.child_field).to.exist      
      child_template.child_field.value.should.equal 'child specific field'

    it 'should allow overiding of the function', () ->
      expect(child_template.age).to.exist      
      child_template.age.max.should.equal 80

    it 'should allow overriding of direct fields with direct fields', () ->
      child_template.city.should.equal "Pretoria"

    it 'should allow overriding of direct fields with nox_methods', () ->
      child_template.some_field.value.should.equal "not_some_value"

    it 'should allow the overriding of a nox_method by a direct value', () ->
      child_template.another.should.equal "not 10"

    fix_random_value 1
    child = nox.construct_template child_template

    it 'should return the values from the child template and ones derived from base', () ->
      child.type.should.equal 'child_type'
      child.child_field.should.equal 'child specific field'
      child.age.should.equal 80
  
  describe '- complex usage : testing multiple levels : ', () ->
    star_template = nox.create_template 'star_template',
      planets : nox.select
        count : nox.rnd
          max : 10
        values : ['a']

    m_template = nox.extend_template star_template,'m_template',
      planets : 
        count :
          min : 1
          max : 2   
        valuse : ['x'] 

    it 'should assign the overrideen values at the correct level of the child template', () ->
      expect(m_template.planets.count.min).to.exist
      m_template.planets.count.min.should.equal 1  
      m_template.planets.count.max.should.equal 2    


  describe 'extending an using directives', () ->
    base = nox.create_template 'base',
      name : "name"
      surname : "surname"

    child = nox.extend_template base,'child',
      name : "child_name"
      ,
      { remove : ['surname'] }

    it 'should leave the base template unmodified', () ->
      base.name.should.equal "name"
      expect(base.surname).to.exist





