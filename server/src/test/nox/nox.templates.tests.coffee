should = require('chai').should()
expect = require('chai').expect
_ = require 'underscore'

nox = require '../../nox/nox'

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

