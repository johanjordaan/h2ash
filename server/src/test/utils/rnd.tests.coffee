_ = require 'underscore'
should = require('chai').should()
expect = require('chai').expect

rnd = require '../../utils/rnd'

saved_random = rnd.rnd

fix_random_value = (value) ->
  rnd.restore()

ff = 0.0001

describe 'rnd', () ->
  describe 'rnd.rand',() ->
    it 'should should return the same random sequence give the same seed', () ->
      rnd.srand(10)
      a = []
      for i in _.range(1000)
        a.push rnd.rand()

      rnd.srand(10)
      b = []
      for i in _.range(1000)
        b.push rnd.rand()
      
      for i in _.range(1000)
        a[i].should.equal b[i]

  describe 'rnd.random',() ->
    it 'should should return the same random sequence give the same seed', () ->
      rnd.srand(10)
      a = []
      for i in _.range(1000)
        a.push rnd.random()

      rnd.srand(10)
      b = []
      for i in _.range(1000)
        b.push rnd.random()
      
      for i in _.range(1000)
        a[i].should.equal b[i]

  describe 'rnd.rnd_float_between', () ->
    it 'should return the min on a 0', () ->
      rnd.fix_value 0
      rnd.rnd_float_between(-100.334,100.991).should.equal -100.334
    it 'should return the max on a 1', () ->
      rnd.fix_value 1
      rnd.rnd_float_between(-100.334,100.991).should.be.within 100.991-ff,100.991+ff
    it 'should return the mid on a 0.5', () ->
      rnd.fix_value 0.5
      mid = -100.334 + (100.991-(-100.334))/2
      rnd.rnd_float_between(-100.334,100.991).should.be.within mid-ff,mid+ff

  describe 'rnd.rnd_int_between', () ->
    it 'should return the min on a 0', () ->
      rnd.fix_value 0
      rnd.rnd_int_between(-132,334).should.equal -132
    it 'should return the max on a 1', () ->
      rnd.fix_value 1
      rnd.rnd_int_between(-132,334).should.equal 334
    it 'should return the mid on a 0.5', () ->
      rnd.fix_value 0.5
      mid = -132 + (334-(-132))/2
      rnd.rnd_int_between(-132,334).should.be.within mid-ff,mid+ff
    it 'should return the mid on a 0.5 it should return the floored value id the list length is not odd', () ->
      rnd.fix_value 0.5
      mid = 2
      rnd.rnd_int_between(1,4).should.be.within mid-ff,mid+ff


