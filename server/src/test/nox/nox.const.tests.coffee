should = require('chai').should()
expect = require('chai').expect

nox = require '../../nox/nox'

describe 'nox.const', ()->
  describe '- basic uasge : ', () ->
    c = nox.const
      value : 10

    it 'should set the _nox_method flag', () ->
      c._nox_method.should.equal true

    it 'should set the _nox_errors flag', () ->
      c._nox_errors.should.be.a 'array'
      c._nox_errors.length.should.equal 0

    it 'should store the value in the value variable', () ->
      c.value.should.equal 10
      
    it 'should return the value when it is run', () ->   
      c_result = c.run()
      c_result.should.equal 10

  describe '- recursive usage : ', () ->
    c = nox.const
      value : nox.const
        value : nox.const
          value : 20

    it 'should set the _nox_method flag on the levels', () ->
      c._nox_method.should.equal true
      c.value._nox_method.should.equal true
      c.value.value._nox_method.should.equal true

    it 'should set the value of the lowest level value', () ->
      c.value.value.value.should.equal 20

    it 'should return the value when it is run', () ->   
      c_result = c.run()
      c_result.should.equal 20

  describe '- error conditions :', () ->
    c = nox.const {}
    c_result = c.run()

    it 'should return an error list if the required fields (value) is not specified', () ->
      c_result.should.be.a 'Array'
      c_result.length.should.equal 1

    it 'should return a usable error message', () ->
      c_result[0].should.equal "Required field [value] is missing."    