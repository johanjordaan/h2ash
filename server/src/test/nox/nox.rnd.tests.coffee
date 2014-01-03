should = require('chai').should()
expect = require('chai').expect

nox = require '../../nox/nox'

saved_random = Math.random

fix_random_value = (value) ->
  Math.random = () ->
    return value

describe 'nox.rnd', ()->
  describe '- basic uasge : ', () ->
    c = nox.rnd
      min : 1
      max : 6
 
    it 'should set the _nox_method flag', () ->
      c._nox_method.should.equal true

    it 'should set the _nox_errors flag', () ->
      c._nox_errors.should.be.a 'array'
      c._nox_errors.length.should.equal 0

    it 'should store the min and max values in the relevant properties', () ->
      c.min.should.equal 1
      c.max.should.equal 6

    d = nox.rnd
      max : 20  

    it 'should set the min default to 0', () ->
      d.min.should.equal 0

    it 'should set the normal flag to false (deafult is a flat distribution)', () ->
      d.normal.should.equal false

    it 'should return the value when it is run', () ->   
      fix_random_value 1
      c_result = c.run()
      c_result.should.equal 6


  describe '- recursive usage : ', () ->
    c = nox.rnd
      min : 15
      max : nox.const
        value : 20

    it 'should set the _nox_method flag on the levels', () ->
      c._nox_method.should.equal true
      c.max._nox_method.should.equal true

    it 'should set the _nox_errors flag', () ->
      c._nox_errors.should.be.a 'array'
      c._nox_errors.length.should.equal 0
      c.max._nox_errors.should.be.a 'array'
      c.max._nox_errors.length.should.equal 0
      
    it 'should set the value of the lowest level value', () ->
      c.max.value.should.equal 20

    it 'should return the value when it is run', () ->   
      fix_random_value 0
      c_result = c.run()
      c_result.should.equal 15

  describe '- error conditions :', () ->
    c = nox.rnd {}
    c_result = c.run()

    it 'should return an error list if the required fields (value) is not specified', () ->
      c_result.should.be.a 'Array'
      c_result.length.should.equal 1 # All the other vaues are defaulted 

    it 'should return a usable error message', () ->
      c_result[0].should.equal "Required field [max] is missing."    

  describe '- statistical measures - flat distribution : ', () ->
    c = nox.rnd 
      min : 0.5
      max : 1.25

    it 'should return the minimum on a random 0', () ->
      fix_random_value 0
      r = c.run()
      r.should.equal 0.5

    it 'should return the maximum on a random 1', () ->
      fix_random_value 1
      r = c.run()
      r.should.equal 1.25

    it 'should return the mid value on a random .5', () ->
      fix_random_value .5
      r = c.run()
      r.should.equal 0.5 + (1.25-0.5)/2

  describe '- statistical measures - normal distribution : ', () ->
    c = nox.rnd 
      min : -3.5
      max : 99
      normal : true

    it 'should return the minimum on a random 0', () ->
      fix_random_value 0
      r = c.run()
      r.should.equal -3.5

    it 'should return the maximum on a random 1', () ->
      fix_random_value 1
      r = c.run()
      r.should.equal 99

    it 'should return the mid value on a random .5', () ->
      fix_random_value .5
      r = c.run()
      r.should.equal -3.5 + (99+3.5)/2

