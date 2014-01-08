_ = require 'underscore'
should = require('chai').should()
expect = require('chai').expect

rnd = require '../../utils/rnd'

saved_random = Math.random

fix_random_value = (value) ->
  Math.random = () ->
    return value

ff = 0.0001

describe 'rnd', () ->
  afterEach (done) -> 
    Math.random = saved_random
    done()

  describe 'rnd.rnd_float_between', () ->
    it 'should return the min on a 0', () ->
      fix_random_value 0
      rnd.rnd_float_between(-100.334,100.991).should.equal -100.334
    it 'should return the max on a 1', () ->
      fix_random_value 1
      rnd.rnd_float_between(-100.334,100.991).should.be.within 100.991-ff,100.991+ff
    it 'should return the mid on a 0.5', () ->
      fix_random_value 0.5
      mid = -100.334 + (100.991-(-100.334))/2
      rnd.rnd_float_between(-100.334,100.991).should.be.within mid-ff,mid+ff

  describe 'rnd.rnd_int_between', () ->
    it 'should return the min on a 0', () ->
      fix_random_value 0
      rnd.rnd_int_between(-132,334).should.equal -132
    it 'should return the max on a 1', () ->
      fix_random_value 1
      rnd.rnd_int_between(-132,334).should.equal 334
    it 'should return the mid on a 0.5', () ->
      fix_random_value 0.5
      mid = -132 + (334-(-132))/2
      rnd.rnd_int_between(-132,334).should.be.within mid-ff,mid+ff
    it 'should return the mid on a 0.5 it should return the floored value id the list length is not odd', () ->
      fix_random_value 0.5
      mid = 2
      rnd.rnd_int_between(1,4).should.be.within mid-ff,mid+ff


