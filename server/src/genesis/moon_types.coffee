types = require './types'
astronomy = require './astronomy'
atmosphere_types = require './atmosphere_types'

ASTEROID = 
  name : types.fixed {value : 'Asteroid' }
  type : types.fixed {value : 'Rock' }  
  radius : types.range 
    from    : 400 / astronomy.EARTH_RADIUS
    to      : 800 / astronomy.EARTH_RADIUS
  gravity_x : types.range
    from    : 0.01
    to      : 0.05
  atmosphere : types.select_type_create_instance [
    atmosphere_types.NO_ATMOSPHERE
  ]
  distance : types.method
    method  : astronomy.distance_of_moon 
  temperature : types.method
    method  : astronomy.temperature_of_moon 
  density : types.range
    from    : 2.5
    to      : 9.0
  mass : types.method
    method : astronomy.mass_of_moon
  gravity : types.method
    method : astronomy.gravity_of_moon    

SUB_LUNAR = 
  name : types.fixed {value : 'Sub-lunar (Pluto, Eris)' }
  type : types.fixed {value : 'Rock' }  
  radius : types.range 
    from    : 800 / astronomy.EARTH_RADIUS
    to      : 1600 / astronomy.EARTH_RADIUS
  gravity_x : types.range
    from    : 0.05
    to      : 0.01
  atmosphere : types.select_type_create_instance [
    atmosphere_types.NO_ATMOSPHERE
    atmosphere_types.VERY_THIN_ATMOSPHERE
  ]
  distance : types.method
    method : astronomy.distance_of_moon 
  temperature : types.method
    method  : astronomy.temperature_of_moon 
  density : types.range
    from    : 2.5
    to      : 9.0
  mass : types.method
    method : astronomy.mass_of_moon
  gravity : types.method
    method : astronomy.gravity_of_moon        

LUNAR = 
  name : types.fixed {value : 'Lunar (Earths Moon)' }
  type : types.fixed {value : 'Rock' }  
  radius : types.range 
    from    : 1600 / astronomy.EARTH_RADIUS
    to      : 2400 / astronomy.EARTH_RADIUS
  gravity_x : types.range
    from    : 0.1
    to      : 0.3
  atmosphere : types.select_type_create_instance [
    atmosphere_types.NO_ATMOSPHERE
    atmosphere_types.VERY_THIN_ATMOSPHERE
    atmosphere_types.THIN_ATMOSPHERE
    atmosphere_types.NORMAL_ATMOSPHERE
  ]
  distance : types.method
    method : astronomy.distance_of_moon
  temperature : types.method
    method  : astronomy.temperature_of_moon 
  density : types.range
    from    : 2.5
    to      : 9.0
  mass : types.method
    method : astronomy.mass_of_moon
  gravity : types.method
    method : astronomy.gravity_of_moon         

SUPER_LUNAR = 
  name : types.fixed {value : 'Super-Lunar (Mars, Mercury)' }
  type : types.fixed {value : 'Rock' }  
  radius : types.range 
    from    : 2400 / astronomy.EARTH_RADIUS
    to      : 4000 / astronomy.EARTH_RADIUS
  gravity_x : types.range
    from    : 0.3
    to      : 0.7
  atmosphere : types.select_type_create_instance [
    atmosphere_types.NO_ATMOSPHERE
    atmosphere_types.VERY_THIN_ATMOSPHERE
    atmosphere_types.THIN_ATMOSPHERE
    atmosphere_types.NORMAL_ATMOSPHERE
    atmosphere_types.THICK_ATMOSPHERE
  ]
  distance : types.method
    method : astronomy.distance_of_moon  
  temperature : types.method
    method  : astronomy.temperature_of_moon 
  density : types.range
    from    : 2.5
    to      : 9.0
  mass : types.method
    method : astronomy.mass_of_moon
  gravity : types.method
    method : astronomy.gravity_of_moon       

SUB_TERRAN =
  name : types.fixed {value : 'Sub-Terran (Venus)' }
  type : types.fixed {value : 'Rock' }  
  radius : types.range 
    from    : 4000 / astronomy.EARTH_RADIUS
    to      : 6400 / astronomy.EARTH_RADIUS
  gravity_x : types.range
    from    : 0.7
    to      : 1.0
  atmosphere : types.select_type_create_instance [
    atmosphere_types.NO_ATMOSPHERE
    atmosphere_types.VERY_THIN_ATMOSPHERE
    atmosphere_types.THIN_ATMOSPHERE
    atmosphere_types.NORMAL_ATMOSPHERE
    atmosphere_types.THICK_ATMOSPHERE
  ]
  distance : types.method
    method : astronomy.distance_of_moon   
  temperature : types.method
    method  : astronomy.temperature_of_moon 
  density : types.range
    from    : 2.5
    to      : 9.0
  mass : types.method
    method : astronomy.mass_of_moon
  gravity : types.method
    method : astronomy.gravity_of_moon   

TERRAN =
  name : types.fixed {value : 'Terran (Earth)' } 
  type : types.fixed {value : 'Rock' }  
  radius : types.range 
    from    : 6400 / astronomy.EARTH_RADIUS
    to      : 8800 / astronomy.EARTH_RADIUS
  gravity_x : types.range
    from    : 1.0
    to      : 2.0
  atmosphere : types.select_type_create_instance [
    atmosphere_types.NO_ATMOSPHERE
    atmosphere_types.VERY_THIN_ATMOSPHERE
    atmosphere_types.THIN_ATMOSPHERE
    atmosphere_types.NORMAL_ATMOSPHERE
    atmosphere_types.THICK_ATMOSPHERE
    atmosphere_types.VERY_THICK_ATMOSPHERE
  ] 
  distance : types.method
    method : astronomy.distance_of_moon 
  temperature : types.method
    method  : astronomy.temperature_of_moon 
  density : types.range
    from    : 2.5
    to      : 9.0
  mass : types.method
    method : astronomy.mass_of_moon
  gravity : types.method
    method : astronomy.gravity_of_moon        

SUPER_TERRAN = 
  name : types.fixed {value : 'Super-Terran (Gliese 581 c)' }
  type : types.fixed {value : 'Rock' }  
  radius : types.range 
    from    : 8800 / astronomy.EARTH_RADIUS
    to      : 16000 / astronomy.EARTH_RADIUS
  gravity : types.range
    from    : 2.0
    to      : 3.0
  atmosphere : types.select_type_create_instance [
    atmosphere_types.NO_ATMOSPHERE
    atmosphere_types.VERY_THIN_ATMOSPHERE
    atmosphere_types.THIN_ATMOSPHERE
    atmosphere_types.NORMAL_ATMOSPHERE
    atmosphere_types.THICK_ATMOSPHERE
    atmosphere_types.VERY_THICK_ATMOSPHERE
  ] 
  distance : types.method
    method : astronomy.distance_of_moon
  temperature : types.method
    method  : astronomy.temperature_of_moon
  density : types.range
    from    : 2.5
    to      : 9.0
  mass : types.method
    method : astronomy.mass_of_moon
  gravity : types.method
    method : astronomy.gravity_of_moon 

module.exports = 
  ASTEROID : ASTEROID
  SUB_LUNAR : SUB_LUNAR
  LUNAR : LUNAR
  SUPER_LUNAR : SUPER_LUNAR
  SUB_TERRAN : SUB_TERRAN
  TERRAN : TERRAN
  SUPER_TERRAN : SUPER_TERRAN



