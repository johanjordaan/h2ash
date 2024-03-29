_ = require 'underscore'
nox = require '../nox/nox'
astronomy = require './astronomy'
moon_types = require './moon_types'
atmosphere_types = require './atmosphere_types'

planet_template = nox.create_template 'planet_template',
  name : "name"
  type : "type"
  radius : nox.rnd { min : 0, max : 0 }
  atmosphere : nox.select_one
    values : [atmosphere_types.NO_ATMOSPHERE]
  distance : nox.method
    method  : astronomy.distance_of_planet  
  temperature : nox.method
    method  : astronomy.temperature_of_planet
  orbital_period : nox.method
    method : astronomy.orbital_period_of_planet 
  density : nox.rnd { min : 0, max : 0 } 
  mass : nox.method
    method : astronomy.mass_of_planet
  gravity : nox.method
    method : astronomy.gravity_of_planet  
  moons : nox.select
    count : nox.rnd_int { min : 0 , max : 0 }
    values : []

ASTEROID_BELT = nox.extend_template planet_template,'ASTEROID_BELT',
  name : 'Asteroid Belt'
  type : 'Asteroid Belt'
  radius : { min : 0/astronomy.EARTH_RADIUS , max : 1600/astronomy.EARTH_RADIUS  }
  atmosphere : 
    values : [ atmosphere_types.NO_ATMOSPHERE ]
  density : { min : 2.5 , max : 9.0 }  
  moons : []

ASTEROID = nox.extend_template planet_template,'ASTEROID',
  name : 'Asteroid'
  type : 'Asteroid'
  radius : { min : 400/astronomy.EARTH_RADIUS , max : 800/astronomy.EARTH_RADIUS  }
  atmosphere : 
    values : [ atmosphere_types.NO_ATMOSPHERE ]
  density : { min : 2.5 , max : 9.0 }  
  moons : []

SUB_LUNAR = nox.extend_template planet_template,'SUB_LUNAR',
  name : 'Sub-lunar (Pluto, Eris)'
  type : 'Rock'
  radius : { min : 800/astronomy.EARTH_RADIUS , max : 1600/astronomy.EARTH_RADIUS  }
  atmosphere : 
    values : [ 
      atmosphere_types.NO_ATMOSPHERE 
      atmosphere_types.VERY_THIN_ATMOSPHERE  
    ]
  density : { min : 2.5 , max : 9.0 }  
  moons :
    count : { max : 3 }
    values : [ 
      'ASTEROID_MOON' 
    ]

LUNAR = nox.extend_template planet_template,'LUNAR',
  name : 'Lunar (Earths Moon)'
  type : 'Rock'
  radius : { min : 1600/astronomy.EARTH_RADIUS , max : 2400/astronomy.EARTH_RADIUS  }
  atmosphere : 
    values : [ 
      atmosphere_types.NO_ATMOSPHERE
      atmosphere_types.VERY_THIN_ATMOSPHERE
      atmosphere_types.THIN_ATMOSPHERE
      atmosphere_types.NORMAL_ATMOSPHERE
    ]
  density : { min : 2.5 , max : 9.0 }  
  moons :
    count : { max : 3 }
    values : [ 
      'ASTEROID_MOON'  
    ]


SUPER_LUNAR = nox.extend_template planet_template,'SUPER_LUNAR',
  name : 'Super-Lunar (Mars, Mercury)'
  type : 'Rock'
  radius : { min : 2400/astronomy.EARTH_RADIUS , max : 4000/astronomy.EARTH_RADIUS  }
  atmosphere : 
    values : [ 
      atmosphere_types.NO_ATMOSPHERE
      atmosphere_types.VERY_THIN_ATMOSPHERE
      atmosphere_types.THIN_ATMOSPHERE
      atmosphere_types.NORMAL_ATMOSPHERE
      atmosphere_types.THICK_ATMOSPHERE
    ]
  density : { min : 2.5 , max : 9.0 }  
  moons :
    count : { max : 3 }
    values : [ 
      'ASTEROID_MOON' 
    ]

SUB_TERRAN = nox.extend_template planet_template,'SUB_TERRAN',
  name : 'Sub-Terran (Venus)'
  type : 'Rock'
  radius : { min : 4000/astronomy.EARTH_RADIUS , max : 6400/astronomy.EARTH_RADIUS  }
  atmosphere : 
    values : [ 
      atmosphere_types.NO_ATMOSPHERE
      atmosphere_types.VERY_THIN_ATMOSPHERE
      atmosphere_types.THIN_ATMOSPHERE
      atmosphere_types.NORMAL_ATMOSPHERE
      atmosphere_types.THICK_ATMOSPHERE
    ]
  density : { min : 2.5 , max : 9.0 }  
  moons :
    count : { max : 4 }
    values : [ 
      'ASTEROID_MOON'  
      'SUB_LUNAR_MOON' 
    ]

TERRAN = nox.extend_template planet_template,'TERRAN',
  name : 'Terran (Earth)'
  type : 'Rock'
  radius : { min : 6400/astronomy.EARTH_RADIUS , max : 8000/astronomy.EARTH_RADIUS  }
  atmosphere : 
    values : [ 
      atmosphere_types.NO_ATMOSPHERE
      atmosphere_types.VERY_THIN_ATMOSPHERE
      atmosphere_types.THIN_ATMOSPHERE
      atmosphere_types.NORMAL_ATMOSPHERE
      atmosphere_types.THICK_ATMOSPHERE
    ]
  density : { min : 2.5 , max : 9.0 }  
  moons :
    count : { max : 4 }
    values : [ 
      'ASTEROID_MOON'  
      'SUB_LUNAR_MOON' 
      'LUNAR_MOON'     
    ]

SUPER_TERRAN = nox.extend_template planet_template,'SUPER_TERRAN',
  name : 'Super-Terran (Gliese 581 c)'
  type : 'Rock'
  radius : { min : 8000/astronomy.EARTH_RADIUS , max : 16000/astronomy.EARTH_RADIUS  }
  atmosphere : 
    values : [ 
      atmosphere_types.NO_ATMOSPHERE
      atmosphere_types.VERY_THIN_ATMOSPHERE
      atmosphere_types.THIN_ATMOSPHERE
      atmosphere_types.NORMAL_ATMOSPHERE
      atmosphere_types.THICK_ATMOSPHERE
    ]
  density : { min : 2.5 , max : 9.0 }  
  moons :
    count : { max : 5 }
    values : [ 
      'ASTEROID_MOON'  
      'SUB_LUNAR_MOON' 
      'LUNAR_MOON'  
      'SUPER_LUNAR_MOON'    
    ]

jovian_template = nox.extend_template planet_template,'jovian_template',
  type : 'Gas'
  atmosphere : 
    values : [ 
      atmosphere_types.THICK_ATMOSPHERE
      atmosphere_types.VERY_THICK_ATMOSPHERE
    ]
  density : { min : 1.0 , max : 3.0 }
  moons :
    count : { min : 5 , max : 20 }
    values : [
      nox.probability .5 , 'ASTEROID_MOON'
      nox.probability .1 , 'SUB_LUNAR_MOON'
      nox.probability .1 , 'LUNAR_MOON'
      nox.probability .1 , 'SUPER_LUNAR_MOON'
      nox.probability .1 , 'SUB_TERRAN_MOON'
      nox.probability .1 , 'TERRAN_MOON'
    ]  

SUB_JOVIAN = nox.extend_template jovian_template,'SUB_JOVIAN',
  name : 'Sub-Jovian (Uranus, Neptune)'
  radius : { min : 16000/astronomy.EARTH_RADIUS , max : 40000/astronomy.EARTH_RADIUS }

JOVIAN = nox.extend_template jovian_template,'JOVIAN',
  name : 'Jovian (Jupiter, Saturn)'
  radius : { min : 40000/astronomy.EARTH_RADIUS , max : 80000/astronomy.EARTH_RADIUS }

SUPER_JOVIAN = nox.extend_template jovian_template,'SUPER_JOVIAN',
  name : 'Super-Jovian (Methuselah)'
  radius : { min : 80000/astronomy.EARTH_RADIUS , max : 120000/astronomy.EARTH_RADIUS }

module.exports = 
  planet_template : planet_template
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




