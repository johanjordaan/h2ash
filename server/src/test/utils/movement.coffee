_ = require 'underscore'
THREE = require 'three'
should = require('chai').should()
expect = require('chai').expect

movement = require '../../utils/movement'

new_movable = () ->
  position = new THREE.Vector3()
  direction = new THREE.Vector3(1,0,0)
  max_speed = 1 # 1 m per second
  max_angular_speed = Math.PI  #180 deg per second
  o = new movement.Movable(position,direction,max_speed,max_angular_speed,0)
  return o  

check_vector = (v1,v2) ->
  distance = v1.distanceTo(v2)
  distance.should.be.below(0.01)


describe 'movement', () ->
  describe 'movement.update',() ->
    describe 'movement where no rotation is involved', () ->
      o = new_movable()
      o.set_target_position(new THREE.Vector3(10,0,0))
        
      it 'should move to (1,0,0) ', () ->
        o.set_speed(1) 
        o.update(1000)
        check_vector(o.position,new THREE.Vector3(1,0,0))  
        o.last_update.should.equal(1000)

      it 'should move to (1.5,0,0) ', () ->
        o.set_speed(0.5) 
        o.update(2000)
        check_vector(o.position,new THREE.Vector3(1.5,0,0))  
        o.last_update.should.equal(2000)  

      it 'should move to (10,0,0) and stop even if the time is more ', () ->
        o.set_speed(1) 
        o.update(30000)
        check_vector(o.position,new THREE.Vector3(10,0,0))   
        o.last_update.should.equal(30000)  

    describe 'movement where only rotation is involved', () ->
      it 'should rotate to (0.7,0.7,0) ', () ->
        o = new_movable()
        o.set_target_position(new THREE.Vector3(0,10,0))
        o.set_angular_speed((Math.PI/180)*1) 
        o.update(45000)
        check_vector(o.direction,(new THREE.Vector3(1,1,0).normalize() ))
        o.last_update.should.equal(45000)

      it 'should rotate to (0.7,-0.7,0) ', () ->
        o = new_movable()
        o.set_target_position(new THREE.Vector3(0,-10,0))
        o.set_angular_speed((Math.PI/180)*1) 
        o.update(45000)
        check_vector(o.direction,(new THREE.Vector3(1,-1,0).normalize() ))
        o.last_update.should.equal(45000)

      it 'should rotate to (0,1,0) ', () ->
        o = new_movable()
        o.set_target_position(new THREE.Vector3(0,100,0))
        o.set_angular_speed((Math.PI/180)*1) 
        o.update(99000)
        check_vector(o.direction,(new THREE.Vector3(0,1,0).normalize() ))
        o.last_update.should.equal(99000)

      it 'should rotate to (1,1,-1) ', () ->
        o = new_movable()
        o.set_target_position(new THREE.Vector3(100,100,-100))
        o.set_angular_speed((Math.PI/180)*1) 
        o.update(99000)
        check_vector(o.direction,(new THREE.Vector3(1,1,-1).normalize() ))
        o.last_update.should.equal(99000)


