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
