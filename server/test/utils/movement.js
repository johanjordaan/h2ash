// Generated by CoffeeScript 1.6.3
(function() {
  var THREE, check_vector, expect, movement, new_movable, should, _;

  _ = require('underscore');

  THREE = require('three');

  should = require('chai').should();

  expect = require('chai').expect;

  movement = require('../../utils/movement');

  new_movable = function() {
    var direction, max_angular_speed, max_speed, o, position;
    position = new THREE.Vector3();
    direction = new THREE.Vector3(1, 0, 0);
    max_speed = 1;
    max_angular_speed = Math.PI;
    o = new movement.Movable(position, direction, max_speed, max_angular_speed, 0);
    return o;
  };

  check_vector = function(v1, v2) {
    var distance;
    distance = v1.distanceTo(v2);
    return distance.should.be.below(0.01);
  };

  describe('movement', function() {
    return describe('movement.update', function() {
      describe('movement where no rotation is involved', function() {
        var o;
        o = new_movable();
        o.set_target_position(new THREE.Vector3(10, 0, 0));
        it('should move to (1,0,0) ', function() {
          o.set_speed(1);
          o.update(1000);
          check_vector(o.position, new THREE.Vector3(1, 0, 0));
          return o.last_update.should.equal(1000);
        });
        it('should move to (1.5,0,0) ', function() {
          o.set_speed(0.5);
          o.update(2000);
          check_vector(o.position, new THREE.Vector3(1.5, 0, 0));
          return o.last_update.should.equal(2000);
        });
        return it('should move to (10,0,0) and stop even if the time is more ', function() {
          o.set_speed(1);
          o.update(30000);
          check_vector(o.position, new THREE.Vector3(10, 0, 0));
          return o.last_update.should.equal(30000);
        });
      });
      return describe('movement where only rotation is involved', function() {
        it('should rotate to (0.7,0.7,0) ', function() {
          var o;
          o = new_movable();
          o.set_target_position(new THREE.Vector3(0, 10, 0));
          o.set_angular_speed((Math.PI / 180) * 1);
          o.update(45000);
          check_vector(o.direction, new THREE.Vector3(1, 1, 0).normalize());
          return o.last_update.should.equal(45000);
        });
        it('should rotate to (0.7,-0.7,0) ', function() {
          var o;
          o = new_movable();
          o.set_target_position(new THREE.Vector3(0, -10, 0));
          o.set_angular_speed((Math.PI / 180) * 1);
          o.update(45000);
          check_vector(o.direction, new THREE.Vector3(1, -1, 0).normalize());
          return o.last_update.should.equal(45000);
        });
        it('should rotate to (0,1,0) ', function() {
          var o;
          o = new_movable();
          o.set_target_position(new THREE.Vector3(0, 100, 0));
          o.set_angular_speed((Math.PI / 180) * 1);
          o.update(99000);
          check_vector(o.direction, new THREE.Vector3(0, 1, 0).normalize());
          return o.last_update.should.equal(99000);
        });
        return it('should rotate to (1,1,-1) ', function() {
          var o;
          o = new_movable();
          o.set_target_position(new THREE.Vector3(100, 100, -100));
          o.set_angular_speed((Math.PI / 180) * 1);
          o.update(99000);
          check_vector(o.direction, new THREE.Vector3(1, 1, -1).normalize());
          return o.last_update.should.equal(99000);
        });
      });
    });
  });

}).call(this);
