types = require './types'
planet_types = require './planet_types'

astronomy = require './astronomy'

# Add lifetime and age
# Add position : Solar systems are globular clusters with stars concentrated 
#  in center of cluster

DEFAULT_PLANET_LIST = [
  { probability : 1/10, type : planet_types.ASTEROID_BELT }
  { probability : 1/10, type : planet_types.SUB_LUNAR }
  { probability : 1/10, type : planet_types.LUNAR }
  { probability : 1/10, type : planet_types.SUPER_LUNAR }
  { probability : 1/10, type : planet_types.SUB_TERRAN }
  { probability : 1/10, type : planet_types.TERRAN }
  { probability : 1/10, type : planet_types.SUPER_TERRAN }
  { probability : 1/10, type : planet_types.SUB_JOVIAN }
  { probability : 1/10, type : planet_types.JOVIAN }
  { probability : 1/10, type : planet_types.SUPER_JOVIAN }
]

DWARF_PLANET_LIST = [
  { probability : 2/10, type : planet_types.ASTEROID_BELT }
  { probability : 8/10, type : planet_types.ASTEROID }
]

# Star types
#
DWARF = 
  name      : types.fixed {value : 'White Dwarf' } 
  color     : types.select_one ['White']
  temperature  : types.range
    from        : 6000
    to          : 30000
  luminosity : types.range
    from        : 10e-4
    to          : 10e-2
  radius : types.method
    method : astronomy.radius_of_star         
  mass : types.method
    method : astronomy.mass_of_star 
  planets   : types.select_list 
    size        : types.rnd_variable
       min        : 0
       max        : 2 
    item        : types.select_one DWARF_PLANET_LIST 


M_CLASS = 
  name      : types.fixed {value : 'M Class' }
  color     : types.select_one ['Red']
  temperature  : types.range
    from        : 2000
    to          : 4000
  luminosity : types.range
    from        : 10e-4
    to          : 10e-2
  radius : types.method
    method : astronomy.radius_of_star         
  mass : types.method
    method : astronomy.mass_of_star  
  planets   : types.select_list 
    size        : types.rnd_variable 
      min           : 0
      max           : 12
      distribution  : 2 
    item        : types.select_one DEFAULT_PLANET_LIST


K_CLASS = 
  name      : types.fixed {value : 'K Class' }
  color     : types.select_one ['Orange'] 
  temperature  : types.range
    from        : 4000
    to          : 5000
  luminosity : types.range
    from        : 10e-2
    to          : 0.1
  radius : types.method
    method : astronomy.radius_of_star         
  mass : types.method
    method : astronomy.mass_of_star  
  planets   : types.select_list 
    size        : types.rnd_variable 
      min           : 0
      max           : 12
      distribution  : 2 
    item        : types.select_one DEFAULT_PLANET_LIST

G_CLASS =
  name      : types.fixed {value : 'G Class' }
  color     : types.select_one ['Yellow']
  temperature  : types.range
    from        : 5000
    to          : 6000
  luminosity : types.range
    from        : 0.1
    to          : 4
  radius : types.method
    method : astronomy.radius_of_star         
  mass : types.method
    method : astronomy.mass_of_star  
  planets   : types.select_list 
    size        : types.rnd_variable 
      min           : 0
      max           : 12
      distribution  : 2 
    item        : types.select_one DEFAULT_PLANET_LIST

F_CLASS = 
  name      : types.fixed {value : 'F Class' }
  color     : types.select_one ['White']
  temperature  : types.range
    from        : 6000
    to          : 7000
  luminosity : types.range
    from        : 4
    to          : 12
  radius : types.method
    method : astronomy.radius_of_star         
  mass : types.method
    method : astronomy.mass_of_star  
  planets   : types.select_list 
    size        : types.rnd_variable
      min           : 0
      max           : 18
      distribution  : 3 
    item        : types.select_one DEFAULT_PLANET_LIST

A_CLASS = 
  name      : types.fixed {value : 'A Class' }
  color     : types.select_one ['Blue-White'] 
  temperature  : types.range
    from        : 7000
    to          : 15000
  luminosity : types.range
    from        : 12
    to          : 10e3
  radius : types.method
    method : astronomy.radius_of_star         
  mass : types.method
    method : astronomy.mass_of_star  
  planets   : types.select_list 
    size        : types.rnd_variable
      min           : 0
      max           : 18
      distribution  : 3
    item        : types.select_one DEFAULT_PLANET_LIST

B_CLASS = 
  name      : types.fixed {value : 'B Class' }
  color     : types.select_one ['Blue'] 
  temperature  : types.range
    from        : 15000
    to          : 25000
  luminosity : types.range
    from        : 10e3
    to          : 10e4
  radius : types.method
    method : astronomy.radius_of_star         
  mass : types.method
    method : astronomy.mass_of_star  
  planets   : types.select_list 
    size        : types.rnd_variable
      min           : 0
      max           : 18
      distribution  : 3
    item        : types.select_one DEFAULT_PLANET_LIST

O_CLASS = 
  name      : types.fixed {value : 'B Class' }
  color     : types.select_one ['Blue'] 
  temperature  : types.range
    from        : 25000
    to          : 40000
  luminosity : types.range
    from        : 10e4
    to          : 10e6
  radius : types.method
    method : astronomy.radius_of_star         
  mass : types.method
    method : astronomy.mass_of_star  
  planets   : types.select_list 
    size        : types.rnd_variable
      min           : 0
      max           : 18
      distribution  : 3
    item        : types.select_one DEFAULT_PLANET_LIST

RED_GIANT = 
  name      : types.fixed {value : 'Red Giant' }
  color     : types.select_one ['RED'] 
  temperature  : types.range
    from        : 3000
    to          : 4000
  luminosity : types.range
    from        : 1
    to          : 10e3
  radius : types.method
    method : astronomy.radius_of_star         
  mass : types.method
    method : astronomy.mass_of_star  
  planets   : types.select_list 
    size        : types.rnd_variable
      min           : 0
      max           : 18
      distribution  : 3
    item        : types.select_one DEFAULT_PLANET_LIST

RED_SUPER_GIANT = 
  name      : types.fixed {value : 'Red Super Giant' }
  color     : types.select_one ['RED'] 
  temperature  : types.range
    from        : 2500
    to          : 3500
  luminosity : types.range
    from        : 10e4
    to          : 10e5
  radius : types.method
    method : astronomy.radius_of_star         
  mass : types.method
    method : astronomy.mass_of_star  
  planets   : types.select_list 
    size        : types.rnd_variable
      min           : 0
      max           : 18
      distribution  : 3
    item        : types.select_one DEFAULT_PLANET_LIST

BLUE_SUPER_GIANT = 
  name      : types.fixed {value : 'Blue Super Giant' }
  color     : types.select_one ['Blue'] 
  temperature  : types.range
    from        : 8000
    to          : 10000
  luminosity : types.range
    from        : 10e4
    to          : 10e6
  radius : types.method
    method : astronomy.radius_of_star         
  mass : types.method
    method : astronomy.mass_of_star  
  planets   : types.select_list 
    size        : types.rnd_variable
      min           : 0
      max           : 18
      distribution  : 3
    item        : types.select_one DEFAULT_PLANET_LIST

module.exports = 
  DWARF : DWARF
  M_CLASS : M_CLASS
  K_CLASS : K_CLASS
  G_CLASS : G_CLASS
  F_CLASS : F_CLASS
  A_CLASS : A_CLASS
  B_CLASS : B_CLASS
  O_CLASS : O_CLASS
  RED_GIANT : RED_GIANT
  RED_SUPER_GIANT : RED_SUPER_GIANT
  BLUE_SUPER_GIANT : BLUE_SUPER_GIANT




