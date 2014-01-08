// Generated by CoffeeScript 1.6.3
(function() {
  var cc2sc, cc_length, deg2rad, make_cc, make_sc, rad2deg, sc2cc;

  deg2rad = function(deg) {
    deg = deg % 360;
    if (deg < 0) {
      deg += 360;
    }
    return deg * (Math.PI / 180.0);
  };

  rad2deg = function(rad) {
    return rad * (180.0 / Math.PI);
  };

  make_cc = function(x, y, z) {
    var cc;
    return cc = {
      x: x,
      y: y,
      z: z
    };
  };

  make_sc = function(r, theta, phi) {
    var sc;
    return sc = {
      r: r,
      theta: theta,
      phi: phi
    };
  };

  cc_length = function(cc) {
    return Math.sqrt(cc.x * cc.x + cc.y * cc.y + cc.z * cc.z);
  };

  cc2sc = function(cc) {
    var phi, r, theta;
    r = cc_length(cc);
    if (r === 0) {
      theta = 0;
      phi = 0;
    } else {
      theta = Math.acos(cc.z / r);
      phi = Math.atan2(cc.y, cc.x);
    }
    if (theta < 0) {
      theta += 2 * Math.PI;
    }
    if (phi < 0) {
      phi += 2 * Math.PI;
    }
    return make_sc(r, theta, phi);
  };

  sc2cc = function(sc) {
    var x, y, z;
    x = sc.r * Math.sin(sc.theta) * Math.cos(sc.phi);
    y = sc.r * Math.sin(sc.theta) * Math.sin(sc.phi);
    z = sc.r * Math.cos(sc.theta);
    return make_cc(x, y, z);
  };

  module.exports = {
    deg2rad: deg2rad,
    rad2deg: rad2deg,
    make_cc: make_cc,
    make_sc: make_sc,
    cc_length: cc_length,
    cc2sc: cc2sc,
    sc2cc: sc2cc
  };

}).call(this);
