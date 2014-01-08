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
    theta : theta   # inclination - 0-180 : Around the xy plane? from the +xaxis
    phi : phi       # azimuth - 0 - 360 : Around the z Axis from the +zaxis

cc_length = (cc) ->
  return Math.sqrt( cc.x*cc.x + cc.y*cc.y + cc.z*cc.z ) 

# Cartesian to Spherical
#
cc2sc = (cc) ->
  r = cc_length(cc)
  if r == 0 
    theta = 0
    phi = 0
  else
    theta = Math.acos(cc.z/r)  
    phi = Math.atan2(cc.y,cc.x)
  
  if theta<0
    theta += 2*Math.PI
  if phi<0
    phi += 2*Math.PI  

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
  cc_length : cc_length
  cc2sc : cc2sc
  sc2cc : sc2cc