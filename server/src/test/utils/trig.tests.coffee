_ = require 'underscore'
should = require('chai').should()
expect = require('chai').expect

trig = require '../../utils/trig'

describe 'utils.trig', () ->
  describe 'deg2rad - convert degrees to radian', () ->
    it 'should convert 0 deg to 0 radians', () ->
      trig.deg2rad(0).should.equal 0
    it 'should convert 90 deg to PI/2', () ->
      trig.deg2rad(90).should.equal Math.PI/2
    it 'should convert 180 deg to PI', () ->
      trig.deg2rad(180).should.equal Math.PI
    it 'should convert 270 deg to PI+PI/2', () ->
      trig.deg2rad(270).should.equal Math.PI+Math.PI/2  
    it 'should convert 360 deg to 0', () ->
      trig.deg2rad(360).should.equal 0  
    it 'should convert 359 deg to 2*PI', () ->
      trig.deg2rad(359.9999999999999).should.be.within 2*Math.PI-0.00001, 2*Math.PI+0.00001
    it 'should convert -90 deg to 270 converted', () ->
      trig.deg2rad(-90).should.equal trig.deg2rad(270)
    it 'should convert -0 deg to 0 converted', () ->
      trig.deg2rad(-0).should.equal trig.deg2rad(0)
    it 'should convert -180 deg to 180 converted', () ->
      trig.deg2rad(-180).should.equal trig.deg2rad(180)
    it 'should convert -270 deg to 90 converted', () ->
      trig.deg2rad(-270).should.equal trig.deg2rad(90)
    it 'should reduce all angles bigger than 360 to the 0-360 range', () ->
      for i in _.range(100)
        r = _.random(360,3600)
        trig.deg2rad(r).should.equal trig.deg2rad(r%360)   

  describe 'rad2deg - convert radians to degrees', () ->
    it 'should convert 0 rad to 0 deg', () ->
      trig.rad2deg(0).should.equal 0
    it 'should convert PI/2 rad to 90 deg', () ->
      trig.rad2deg(Math.PI/2).should.equal 90
    it 'should convert PI rad to 180 deg', () ->
      trig.rad2deg(Math.PI).should.equal 180
    it 'should convert PI+PI/2 rad to 270 deg', () ->
      trig.rad2deg(Math.PI+Math.PI/2).should.equal 270
    it 'should convert 359 degrees to 2*PI', () ->
      trig.rad2deg(2*Math.PI).should.be.within  359.9999999999999-0.00001,359.9999999999999+0.00001

  describe 'make_cc - construct a cartesian coordinate object (x,y,z)', () ->
    cc = trig.make_cc -45,34.1,-0.0001
    it 'should return an object with x to the suplied value', () ->
      cc.x.should.equal -45
    it 'should return an object with y to the suplied value', () ->
      cc.y.should.equal 34.1
    it 'should return an object with y to the suplied value', () ->
      cc.z.should.equal -0.0001

  describe 'make_sc -  construct a spherical coordinate object (r,theta,phi)', () ->
    sc = trig.make_sc 1002.3,Math.PI/3,Math.PI
    it 'should return an object with r to the suplied value', () ->
      sc.r.should.equal 1002.3
    it 'should return an object with y to the suplied value', () ->
      sc.theta.should.equal Math.PI/3
    it 'should return an object with y to the suplied value', () ->
      sc.phi.should.equal Math.PI




