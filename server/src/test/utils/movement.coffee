_ = require 'underscore'
THREE = require 'three'
should = require('chai').should()
expect = require('chai').expect

movement = require '../../utils/movement'

new_movable = () ->
  position = new THREE.Vector3()
  direction = new THREE.Vector3(1,0,0)
  max_speed = 1 # 1 m per second
  max_angular_speed = Math.PI/180  #1 deg per second
  o = new movement.Movable(position,direction,max_speed,max_angular_speed,0)
  return o  

check_vector = (v,x,y,z) ->
  v.x.should.equal(x)
  v.y.should.equal(y)
  v.y.should.equal(z)


describe 'movement', () ->
  describe 'movement.update',() ->
    describe 'movement where no rotation is involved', () ->
      o = new_movable()
      o.set_target_position(new THREE.Vector3(100,0,0))
        
      it 'should move to (1,0,0) ', () ->
        o.set_speed(1) 
        o.update(1000)
        check_vector(o.position,1,0,0)   
        o.last_update.should.equal(1000)

      it 'should move to (1.5,0,0) ', () ->
        o.set_speed(0.5) 
        o.update(2000)
        check_vector(o.position,1.5,0,0)   
        o.last_update.should.equal(2000)  


  


