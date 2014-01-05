_ = require 'underscore'
should = require('chai').should()
expect = require('chai').expect

nox = require '../../nox/nox'

saved_random = Math.random

fix_random_value = (value) ->
  fix_random_values [value]

fix_random_values = (values) ->
  values = values.reverse()
  Math.random = () ->
    value = values.pop()
    fix_random_values values.reverse()
    return value

describe 'nox.select', ()->
  describe '- basic usage (select from non-template list) flat distribution : ', () ->
    list = ['A','B','C','D']
    c = nox.select
      values : list
 
    it 'should set the _nox_method flag', () ->
      c._nox_method.should.equal true

    it 'should set the _nox_errors flag', () ->
      c._nox_errors.should.be.a 'array'
      c._nox_errors.length.should.equal 0

    it 'should store values in the values property', () ->
      c.values.should.equal list 

    it 'should set the default count to 1', () ->
      c.count.should.equal 1

    it 'should set the deafult return_one flag to false', () ->
      c.return_one.should.equal false  

    d = nox.select
      count : 3
      values : list  

    it 'should set the count to 3', () ->
      d.count.should.equal 3

    fix_random_values [0,0.5,1]
    result = d.run()

    it 'should return a result with length of 3', () ->
      result.length.should.equal 3

    it 'should return an array with values A,B,D based on 0,0.5 and 1 random values', () ->
      expected = ['A','B','D']
      for i in _.range(3)
        result[i].should.equal expected[i]
 
    e = nox.select_one
      values : list

    it 'should set the deafult return_one flag to falstrue if using select_one', () ->
      e.return_one.should.equal true  

    it 'should select a single item from the list (not as an array)', () ->
      fix_random_value 0.7
      e.run().should.equal 'C'

  describe '- basic usage (select from list of templates, the templates must be constructed) flat distribution', () ->
    male = nox.create_template 'male',
      name : nox.select_one
        values : ['John','Joe','Peter']

    female = nox.create_template 'female',
      name : nox.select_one
        values : ['Jane','Sue','Sandra','Ruth']

    alien = nox.create_template 'alien',
      name : nox.select_one
        values : ['Xi','Yi','Zi','Zoooo']

    a = nox.select 
      count : 2
      values : [alien,female,male]

    fix_random_values [1,0.5, 0.5,1]  
    result = a.run()

    it 'should return template instances based on the random numbers supplied', () ->
      result[0].name.should.equal 'Joe'   
      result[1].name.should.equal 'Ruth' 

  describe '- recursive usage : ', () ->      
    gen_list = () ->
      return ['X','Y','Z']

    r = nox.select 
      count : nox.rnd
        min : 1
        max : 3
      values : nox.method
        method : gen_list

    fix_random_values [0.5,0.5,1]
    result = r.run()  

    it 'should get the list of values(2) from the method and selcet a random one from the list', () ->
      result.length.should.equal 2 
      result[0].should.equal 'Y'
      result[1].should.equal 'Z'

  describe '- error conditions :', () ->
    c = nox.select {}
    c_result = c.run()

    it 'should return an error list if the required fields (values) is not specified', () ->
      c_result.should.be.a 'Array'
      c_result.length.should.equal 1 # All the other vaues are defaulted 

    it 'should return a usable error message', () ->
      c_result[0].should.equal "Required field [values] is missing."    

    d = nox.select { values : []}
    d_result = d.run()

    it 'should not allow empty list as values parameter ie a list of values must have at least one value', () ->  
      d_result.should.be.a 'Array'
      d_result.length.should.equal 1 # All the other vaues are defaulted 
      d_result[0].should.equal "Values list should contain at least one value."