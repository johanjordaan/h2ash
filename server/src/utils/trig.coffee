deg2rad = (deg) -> 
  deg = deg%360
  if(deg<0) 
    deg+=360
  return deg*(Math.PI/180.0)

rad2deg = (rad) -> 
  return rad*(180.0/Math.PI) 

make_cc = (x,y,z) ->
  return cc = 
    x : x
    y : y
    z : z

make_sc = (r,theta,phi) ->
  return sc =
    r : r
    theta : theta   # inclination
    phi : phi       # azimuth

# Cartesian to Spherical
#
cc2sc = (cc) ->
  r = Math.sqrt( cc.x*cc.x + cc.y*cc.y + cc.z*cc.z ) 
  theta = Math.acos(cc.z/r)
  phi = Math.atan(cc.y/cc.x)
  return make_sc r,theta,phi

# Spherical to Cartesian 
#
sc2cc = (sc) ->
  x = sc.r * Math.sin(sc.theta) * Math.cos(sc.phi)
  y = sc.r * Math.sin(sc.theta) * Math.sin(sc.phi)
  z = sc.r * Math.cos(sc.theta)
  return make_cc x,y,z  

module.exports = 
  deg2rad : deg2rad
  rad2deg : rad2deg
  make_cc : make_cc
  make_sc : make_sc
  cc2sc : cc2sc
  sc2cc : sc2cc