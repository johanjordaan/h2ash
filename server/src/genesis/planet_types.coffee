types = require './types'
astronomy = require './astronomy'
moon_types = require './moon_types'
atmosphere_types = require './atmosphere_types'

# Add geology - stabe / unstable
# 

ASTEROID_BELT = 
  name : types.fixed {value : 'Asteroid Belt'}
  type : types.fixed {value : 'Asteroid Belt'}
  radius : types.range 
    from    : 0 / astronomy.EARTH_RADIUS
    to      : 1600 / astronomy.EARTH_RADIUS
  gravity_x : types.range
    from    : 0.0
    to      : 0.5
  atmosphere : types.select_type_create_instance [
    atmosphere_types.NO_ATMOSPHERE
  ]
  distance : types.method
    method  : astronomy.distance_of_planet  
  temperature : types.method
    method  : astronomy.temperature_of_planet
  orbital_period : types.method
    method : astronomy.orbital_period_of_planet  
  density : types.range
    from    : 2.5
    to      : 9.0
  mass : types.method
    method : astronomy.mass_of_planet
  gravity : types.method
    method : astronomy.gravity_of_planet  
  moons : types.fixed {value : [] }

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
    method  : astronomy.distance_of_planet   
  temperature : types.method
    method  : astronomy.temperature_of_planet 
  orbital_period : types.method
    method : astronomy.orbital_period_of_planet 
  density : types.range
    from    : 2.5
    to      : 9.0
  mass : types.method
    method : astronomy.mass_of_planet
  gravity : types.method
    method : astronomy.gravity_of_planet   
  moons : types.fixed { value : [] }

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
    method : astronomy.distance_of_planet      
  temperature : types.method
    method  : astronomy.temperature_of_planet 
  orbital_period : types.method
    method : astronomy.orbital_period_of_planet  
  density : types.range
    from    : 2.5
    to      : 9.0
  mass : types.method
    method : astronomy.mass_of_planet
  gravity : types.method
    method : astronomy.gravity_of_planet  
  moons : types.select_list
    size  : types.rnd_variable
      min   : 0
      max   : 3
    item  : types.select_one [moon_types.ASTEROID]


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
    method : astronomy.distance_of_planet      
  temperature : types.method
    method  : astronomy.temperature_of_planet 
  orbital_period : types.method
    method : astronomy.orbital_period_of_planet 
  density : types.range
    from    : 2.5
    to      : 9.0
  mass : types.method
    method : astronomy.mass_of_planet
  gravity : types.method
    method : astronomy.gravity_of_planet   
  moons : types.select_list
    size  : types.rnd_variable
      min   : 0
      max   : 3
    item  : types.select_one [moon_types.ASTEROID]  

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
    method : astronomy.distance_of_planet      
  temperature : types.method
    method  : astronomy.temperature_of_planet
  orbital_period : types.method
    method : astronomy.orbital_period_of_planet 
  density : types.range
    from    : 2.5
    to      : 9.0
  mass : types.method
    method : astronomy.mass_of_planet
  gravity : types.method
    method : astronomy.gravity_of_planet    
  moons : types.select_list
    size  : types.rnd_variable
      min   : 0
      max   : 3
    item  : types.select_one [moon_types.ASTEROID]  

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
    method : astronomy.distance_of_planet   
  temperature : types.method
    method  : astronomy.temperature_of_planet 
  orbital_period : types.method
    method : astronomy.orbital_period_of_planet 
  density : types.range
    from    : 2.5
    to      : 9.0
  mass : types.method
    method : astronomy.mass_of_planet
  gravity : types.method
    method : astronomy.gravity_of_planet      
  moons : types.select_list
    size  : types.rnd_variable
      min   : 0
      max   : 4
    item  : types.select_one [moon_types.ASTEROID,moon_types.SUB_LUNAR] 

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
    method : astronomy.distance_of_planet     
  temperature : types.method
    method  : astronomy.temperature_of_planet 
  orbital_period : types.method
    method : astronomy.orbital_period_of_planet 
  density : types.range
    from    : 2.5
    to      : 9.0
  mass : types.method
    method : astronomy.mass_of_planet
  gravity : types.method
    method : astronomy.gravity_of_planet     
  moons : types.select_list
    size  : types.rnd_variable
      min   : 0
      max   : 4
    item  : types.select_one [moon_types.ASTEROID,moon_types.SUB_LUNAR,moon_types.LUNAR] 

SUPER_TERRAN = 
  name : types.fixed {value : 'Super-Terran (Gliese 581 c)' }
  type : types.fixed {value : 'Rock' }  
  radius : types.range 
    from    : 8800 / astronomy.EARTH_RADIUS
    to      : 16000 / astronomy.EARTH_RADIUS
  gravity_x : types.range
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
    method : astronomy.distance_of_planet      
  temperature : types.method
    method  : astronomy.temperature_of_planet 
  orbital_period : types.method
    method : astronomy.orbital_period_of_planet 
  density : types.range
    from    : 2.5
    to      : 9.0
  mass : types.method
    method : astronomy.mass_of_planet
  gravity : types.method
    method : astronomy.gravity_of_planet   
  moons : types.select_list
    size  : types.rnd_variable
      min   : 0
      max   : 5
    item  : types.select_one [moon_types.ASTEROID,moon_types.SUB_LUNAR,moon_types.LUNAR,moon_types.SUPER_LUNAR]  


JOVIAN_MOON_DISTRIBUTION = [
  { probability : 0.5, type : moon_types.ASTEROID }
  { probability : 0.1, type : moon_types.SUB_LUNAR }
  { probability : 0.1, type : moon_types.LUNAR }
  { probability : 0.1, type : moon_types.SUPER_LUNAR }
  { probability : 0.1, type : moon_types.SUB_TERRAN }
  { probability : 0.1, type : moon_types.TERRAN }
]

SUB_JOVIAN = 
  name : types.fixed {value : 'Sub-Jovian (Uranus, Neptune)' }
  type : types.fixed {value : 'Gas' }
  radius : types.range 
    from    : 16000 / astronomy.EARTH_RADIUS
    to      : 40000 / astronomy.EARTH_RADIUS
  gravity_x : types.range
    from    : 1.0
    to      : 2.0
  atmosphere : types.select_type_create_instance [
    atmosphere_types.THICK_ATMOSPHERE
    atmosphere_types.VERY_THICK_ATMOSPHERE
  ] 
  distance : types.method
    method : astronomy.distance_of_planet      
  temperature : types.method
    method  : astronomy.temperature_of_planet 
  orbital_period : types.method
    method : astronomy.orbital_period_of_planet 
  density : types.range
    from    : 1.0
    to      : 3.0
  mass : types.method
    method : astronomy.mass_of_planet
  gravity : types.method
    method : astronomy.gravity_of_planet   
  moons : types.select_list
    size  : types.rnd_variable
      min   : 5
      max   : 20
    item  : types.select_one JOVIAN_MOON_DISTRIBUTION 

JOVIAN = 
  name : types.fixed {value : 'Jovian (Jupiter, Saturn)' }
  type : types.fixed {value : 'Gas' }
  radius : types.range 
    from    : 40000 / astronomy.EARTH_RADIUS
    to      : 80000 / astronomy.EARTH_RADIUS
  gravity_x : types.range
    from    : 2.0
    to      : 3.0
  atmosphere : types.select_type_create_instance [
    atmosphere_types.THICK_ATMOSPHERE
    atmosphere_types.VERY_THICK_ATMOSPHERE
  ] 
  distance : types.method
    method : astronomy.distance_of_planet      
  temperature : types.method
    method  : astronomy.temperature_of_planet 
  orbital_period : types.method
    method : astronomy.orbital_period_of_planet
  density : types.range
    from    : 1.0
    to      : 3.0
  mass : types.method
    method : astronomy.mass_of_planet
  gravity : types.method
    method : astronomy.gravity_of_planet   
  moons : types.select_list
    size  : types.rnd_variable
      min   : 5
      max   : 20
    item  : types.select_one JOVIAN_MOON_DISTRIBUTION 

SUPER_JOVIAN =
  name : types.fixed {value : 'Super-Jovian (Methuselah)' }
  type : types.fixed {value : 'Gas' }
  radius : types.range 
    from    : 80000 / astronomy.EARTH_RADIUS
    to      : 120000 / astronomy.EARTH_RADIUS
  gravity_x : types.range
    from    : 3.0
    to      : 6.0
  atmosphere : types.select_type_create_instance [
    atmosphere_types.THICK_ATMOSPHERE
    atmosphere_types.VERY_THICK_ATMOSPHERE
  ] 
  distance : types.method
    method : astronomy.distance_of_planet      
  temperature : types.method
    method  : astronomy.temperature_of_planet 
  orbital_period : types.method
    method : astronomy.orbital_period_of_planet  
  density : types.range
    from    : 1.0
    to      : 3.0
  mass : types.method
    method : astronomy.mass_of_planet
  gravity : types.method
    method : astronomy.gravity_of_planet 
  moons : types.select_list
    size  : types.rnd_variable
      min   : 5
      max   : 20
    item  : types.select_one JOVIAN_MOON_DISTRIBUTION 

module.exports = 
  ASTEROID_BELT : ASTEROID_BELT
  ASTEROID : ASTEROID
  SUB_LUNAR : SUB_LUNAR
  LUNAR : LUNAR
  SUPER_LUNAR : SUPER_LUNAR
  SUB_TERRAN : SUB_TERRAN
  TERRAN : TERRAN
  SUPER_TERRAN : SUPER_TERRAN
  SUB_JOVIAN : SUB_JOVIAN
  JOVIAN : JOVIAN
  SUPER_JOVIAN : SUPER_JOVIAN




