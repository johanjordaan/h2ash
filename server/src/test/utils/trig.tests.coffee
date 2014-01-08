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

  describe 'make_sc - construct a spherical coordinate object (r,theta,phi)', () ->
    sc = trig.make_sc 1002.3,Math.PI/3,Math.PI
    it 'should return an object with r to the suplied value', () ->
      sc.r.should.equal 1002.3
    it 'should return an object with y to the suplied value', () ->
      sc.theta.should.equal Math.PI/3
    it 'should return an object with y to the suplied value', () ->
      sc.phi.should.equal Math.PI 

  assert_sc = (sc,r,theta,phi) ->
    sc.r.should.be.within r-0.0001,r+0.0001
    sc.theta.should.be.within theta-0.0001,theta+0.0001
    sc.phi.should.be.within phi-0.0001,phi+0.0001

  describe 'cc2sc - convert cartesian ccordinates to spherical cordinates', () ->
    describe 'quadrant 1 xyz', () ->
      it 'should convert 0,0,0 to 0,0,0', () ->
        sc = trig.cc2sc(trig.make_cc(0,0,0))
        assert_sc sc,0,0,0

      it 'should convert 50,0,0 to 50,90,0', () ->
        sc = trig.cc2sc(trig.make_cc(50,0,0))
        assert_sc sc,50,trig.deg2rad(90),0     
      it 'should convert 0,50,0 to 50,90,90', () ->
        cc = trig.make_cc(0,50,0)
        sc = trig.cc2sc(cc)
        assert_sc sc,50,trig.deg2rad(90),trig.deg2rad(90)
      it 'should convert 0,0,50 to 50,0,0', () ->
        cc = trig.make_cc(0,0,50)
        sc = trig.cc2sc(cc)
        assert_sc sc,50,0,0

      it 'should convert 50,50,0 to sqrt(50^2+50^2),90,45', () ->
        cc = trig.make_cc(50,50,0)
        sc = trig.cc2sc(cc)
        assert_sc sc,trig.cc_length(cc),trig.deg2rad(90),trig.deg2rad(45)
      it 'should convert 50,0,50 to sqrt(50^2+50^2),45,0', () ->
        cc = trig.make_cc(50,0,50)
        sc = trig.cc2sc(cc)
        assert_sc sc,trig.cc_length(cc),trig.deg2rad(45),0
      it 'should convert 0,50,50 to sqrt(50^2+50^2),45,90', () ->
        cc = trig.make_cc(0,50,50)
        sc = trig.cc2sc(cc)
        assert_sc sc,trig.cc_length(cc),trig.deg2rad(45),trig.deg2rad(90)

      it 'should convert 50,50,50 to sqrt(3*50^2),Math.acos(50/l),45', () ->
        cc = trig.make_cc(50,50,50)
        sc = trig.cc2sc(cc)
        l = Math.sqrt(3*(50*50))
        theta = Math.acos(cc.z/l)
        assert_sc sc,l,theta,trig.deg2rad(45)

    describe 'quadrant 2 -xyz', () ->
      it 'should convert -50,0,0 to 50,90,180', () ->
        sc = trig.cc2sc(trig.make_cc(-50,0,0))
        assert_sc sc,50,trig.deg2rad(90),trig.deg2rad(180)     

      it 'should convert -50,50,0 to sqrt(50^2+50^2),90,90+45', () ->
        cc = trig.make_cc(-50,50,0)
        sc = trig.cc2sc(cc)
        assert_sc sc,trig.cc_length(cc),trig.deg2rad(90),trig.deg2rad(90+45)
      it 'should convert -50,0,50 to sqrt(50^2+50^2),45,0', () ->
        cc = trig.make_cc(50,0,50)
        sc = trig.cc2sc(cc)
        assert_sc sc,trig.cc_length(cc),trig.deg2rad(45),trig.deg2rad(0)

      it 'should convert -50,50,50 to sqrt(3*50^),Math.acos(50/l),90+45', () ->
        cc = trig.make_cc(-50,50,50)
        sc = trig.cc2sc(cc)
        l = Math.sqrt(3*(50*50))
        theta = Math.acos(cc.z/l)
        assert_sc sc,l,theta,trig.deg2rad(90+45)

    describe 'quadrant 3 x-yz', () ->
      it 'should convert 0,-50,0 to 50,90,270', () ->
        cc = trig.make_cc(0,-50,0)
        sc = trig.cc2sc(cc)
        assert_sc sc,50,trig.deg2rad(90),trig.deg2rad(270)

      it 'should convert 50,-50,0 to sqrt(50^2+50^2),90,270+45', () ->
        cc = trig.make_cc(50,-50,0)
        sc = trig.cc2sc(cc)
        assert_sc sc,trig.cc_length(cc),trig.deg2rad(90),trig.deg2rad(270+45)
      it 'should convert 0,-50,50 to sqrt(50^2+50^2),45,270', () ->
        cc = trig.make_cc(0,-50,50)
        sc = trig.cc2sc(cc)
        assert_sc sc,trig.cc_length(cc),trig.deg2rad(45),trig.deg2rad(270)

      it 'should convert 50,-50,50 to sqrt(3*50^2),Math.acos(50/l),270+45', () ->
        cc = trig.make_cc(50,-50,50)
        sc = trig.cc2sc(cc)
        l = Math.sqrt(3*(50*50))
        theta = Math.acos(50/l)
        assert_sc sc,l,theta,trig.deg2rad(270+45)

    describe 'quadrant 4 xy-z', () ->
      it 'should convert 0,0,-50 to 50,180,0', () ->
        cc = trig.make_cc(0,0,-50)
        sc = trig.cc2sc(cc)
        assert_sc sc,50,trig.deg2rad(180),0

      it 'should convert 50,0,-50 to sqrt(50^2+50^2),90+45,0', () ->
        cc = trig.make_cc(50,0,-50)
        sc = trig.cc2sc(cc)
        assert_sc sc,trig.cc_length(cc),trig.deg2rad(90+45),0
      it 'should convert 0,50,-50 to sqrt(50^2+50^2),45,90', () ->
        cc = trig.make_cc(0,50,-50)
        sc = trig.cc2sc(cc)
        assert_sc sc,trig.cc_length(cc),trig.deg2rad(90+45),trig.deg2rad(90)

      it 'should convert 50,50,-50 to sqrt(3*50^2),Math.acos(50/l),45', () ->
        cc = trig.make_cc(50,50,-50)
        sc = trig.cc2sc(cc)
        l = Math.sqrt(3*(50*50))
        theta = Math.acos(cc.z/l)
        assert_sc sc,l,theta,trig.deg2rad(45)

    describe 'quadrant 5 -x-yz', () ->
      it 'should convert -50,-50,0 to sqrt(50^2+50^2),90,180+45', () ->
        cc = trig.make_cc(-50,-50,0)
        sc = trig.cc2sc(cc)
        assert_sc sc,trig.cc_length(cc),trig.deg2rad(90),trig.deg2rad(180+45)

      it 'should convert -50,-50,50 to sqrt(3*50^2),Math.acos(50/l),180+45', () ->
        cc = trig.make_cc(-50,-50,50)
        sc = trig.cc2sc(cc)
        l = Math.sqrt(3*(50*50))
        theta = Math.acos(cc.z/l)
        assert_sc sc,l,theta,trig.deg2rad(180+45)

    describe 'quadrant 6 -xy-z', () ->
      it 'should convert -50,0,-50 to sqrt(50^2+50^2),90+45,180', () ->
        cc = trig.make_cc(-50,0,-50)
        sc = trig.cc2sc(cc)
        assert_sc sc,trig.cc_length(cc),trig.deg2rad(90+45),trig.deg2rad(180)

      it 'should convert -50,50,-50 to sqrt(3*50^2),Math.acos(50/l),90+45', () ->
        cc = trig.make_cc(-50,50,-50)
        sc = trig.cc2sc(cc)
        l = Math.sqrt(3*(50*50))
        theta = Math.acos(cc.z/l)
        assert_sc sc,l,theta,trig.deg2rad(90+45)

    describe 'quadrant 7 x-y-z', () ->
      it 'should convert 0,-50,-50 to sqrt(50^2+50^2),90+45,270', () ->
        cc = trig.make_cc(0,-50,-50)
        sc = trig.cc2sc(cc)
        assert_sc sc,trig.cc_length(cc),trig.deg2rad(90+45),trig.deg2rad(270)

      it 'should convert 50,-50,-50 to sqrt(3*50^2),Math.acos(50/l),180+45', () ->
        cc = trig.make_cc(50,-50,-50)
        sc = trig.cc2sc(cc)
        l = Math.sqrt(3*(50*50))
        theta = Math.acos(cc.z/l)
        assert_sc sc,l,theta,trig.deg2rad(270+45)

    describe 'quadrant 7 x-y-z', () ->
      it 'should convert -50,-50,-50 to sqrt(3*50^2),Math.acos(50/l),180+45', () ->
        cc = trig.make_cc(-50,-50,-50)
        sc = trig.cc2sc(cc)
        l = Math.sqrt(3*(50*50))
        theta = Math.acos(cc.z/l)
        assert_sc sc,l,theta,trig.deg2rad(180+45)

  describe 'sc2cc', () ->
    it 'should be able to do a round trib cc -> sc -> cc', () ->
      for i in _.range(100)
        cc = trig.make_cc _.random(-1000,1000),_.random(-1000,1000),_.random(-1000,1000)
        sc = trig.cc2sc cc
        ccr = trig.sc2cc sc

        ccr.x.should.be.within cc.x-0.0001,cc.x+0.0001
        ccr.y.should.be.within cc.y-0.0001,cc.y+0.0001
        ccr.z.should.be.within cc.z-0.0001,cc.z+0.0001











