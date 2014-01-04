_ = require 'underscore'
should = require('chai').should()
expect = require('chai').expect

nox = require '../../nox/nox'

test_method = (o) ->
  return 'Hallo'

describe 'nox.method', ()->
  describe '- basic uasge : ', () ->
    c = nox.method
      method : test_method

    it 'should set the _nox_method flag', () ->
      c._nox_method.should.equal true

    it 'should set the _nox_errors flag', () ->
      c._nox_errors.should.be.a 'array'
      c._nox_errors.length.should.equal 0
  

    it 'should store the value in the value variable', () ->
      c.method.should.be.a 'function'
      c.method.should.equal test_method
      
    it 'should return the value from the method when it is run', () ->   
      c_result = c.run()
      c_result.should.equal "Hallo"

  describe '- recursive usage : ', () ->
    c = nox.method
      method : nox.const
        value : test_method

    it 'should set the _nox_method flag on the levels', () ->
      c._nox_method.should.equal true
      c.method._nox_method.should.equal true

    it 'should set the correct method field', () ->
      c.method.should.be.a 'object'
      c.method.value.should.be.a 'function'
      c.method.value.should.equal test_method

    it 'should return the result of the method when it is run', () ->   
      c_result = c.run()
      c_result.should.equal "Hallo"

  describe '- error conditions :', () ->
    c = nox.method {}
    c_result = c.run()

    it 'should return an error list if the required fields (value) is not specified', () ->
      c_result.should.be.a 'Array'
      c_result.length.should.equal 1

    it 'should return a usable error message', () ->
      c_result[0].should.equal "Required field [method] is missing."    






###
  it 'should create a complex wrapper which retuns evaluates the value and return the evaluated value when run', (done) ->
    c = nox.const
      value : nox.const
        value : 20

    expect(c._parent).to.not.exis
    expect(c._index).to.not.exis       
    c.value.should.be.a 'object'
    c._nox_method.should.equal true

    c.value.value.should.equal 20
    c.value._nox_method.should.equal true

    c_result = c.run()
    c_result.should.equal 20

    done()

  it 'the wrapper should ', (done) ->
    template =
      v : nox.const
        value : nox.const
          value : 10

    done()    
###



#################
############ This is all testing stuff below
###
get_name = (target_object) ->
  if target_object.type == 'Orc'
    return 'HamishOrc'
  else
    return "No an orc"

YEARS = 
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
    count : nox.rnd
      min : 0
      max : 2

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
###
