nox = require '../nox/nox'

planet_types = require './planet_types'
astronomy = require './astronomy'

# Add lifetime and age
# Add position : Solar systems are globular clusters with stars concentrated 
#  in center of cluster
# Add check for stars in the instability sector of the HR graph

StarTemplate = nox.create_template 'StarTemplate',
  name : "name"
  color_x : "color"
  temperature : nox.rnd {}
  wavelength : nox.method
    method : astronomy.wavelength_from_temperature
  color : nox.method
    method : astronomy.color_from_wavelength
  luminosity : nox.rnd {}
  radius : nox.method
    method : astronomy.radius_of_star
  mass : nox.method
    method : astronomy.mass_of_star 
  planets : nox.select
    count : nox.rnd_int { min : 0 , max : 12 , normal : true }
    values : [ 
      nox.probability .1 , planet_types.ASTEROID_BELT
      nox.probability .1 , planet_types.SUB_LUNAR
      nox.probability .1 , planet_types.LUNAR
      nox.probability .1 , planet_types.SUPER_LUNAR
      nox.probability .1 , planet_types.SUB_TERRAN
      nox.probability .1 , planet_types.TERRAN
      nox.probability .1 , planet_types.SUPER_TERRAN
      nox.probability .1 , planet_types.SUB_JOVIAN
      nox.probability .1 , planet_types.JOVIAN
      nox.probability .1 , planet_types.SUPER_JOVIAN
    ]

DWARF = nox.extend_template StarTemplate,'DWARF',
  name : 'White Dwarf'
  color_x : 'White'
  temperature : { min : 6000   ,max : 30000 }
  luminosity :  { min : 10e-4  ,max : 10e-2 }
  planets :
    count : { max : 2 }
    values : [
      nox.probability .2 , planet_types.ASTEROID_BELT
      nox.probability .8 , planet_types.ASTEROID
    ]

M_CLASS = nox.extend_template StarTemplate,'M_CLASS',
  name : 'M Class'
  color_x : 'Red'
  temperature : { min : 2000   ,max : 4000 }
  luminosity :  { min : 10e-4  ,max : 10e-2 }
  planets :
    count : { max : 12 }

K_CLASS = nox.extend_template StarTemplate,'K_CLASS',
  name : 'K Class'
  color_x : 'Orange'
  temperature : { min : 4000   ,max : 5000 }
  luminosity :  { min : 10e-2  ,max : 0.1 }
  planets :
    count : { max : 12 }

G_CLASS = nox.extend_template StarTemplate,'G_CLASS',
  name : 'G Class'
  color_x : 'Yellow'
  temperature : { min : 5000   ,max : 6000 }
  luminosity :  { min : 0.1    ,max : 4 }
  planets :
    count : { max : 12 }

F_CLASS = nox.extend_template StarTemplate,'F_CLASS',
  name : 'F Class'
  color_x : 'White'
  temperature : { min : 6000   ,max : 7000 }
  luminosity :  { min : 4      ,max : 12 }
  planets :
    count : { max : 18 }

A_CLASS = nox.extend_template StarTemplate,'A_CLASS',
  name : 'A Class'
  color_x : 'Blue-White'
  temperature : { min : 7000   ,max : 15000 }
  luminosity :  { min : 12     ,max : 10e3 }
  planets :
    count : { max : 18 }

B_CLASS = nox.extend_template StarTemplate,'B_CLASS',
  name : 'B Class'
  color_x : 'Blue'
  temperature : { min : 15000   ,max : 25000 }
  luminosity :  { min : 10e3    ,max : 10e4 }
  planets :
    count : { max : 18 }

O_CLASS = nox.extend_template StarTemplate,'O_CLASS',
  name : 'O Class'
  color_x : 'Blue'
  temperature : { min : 25000   ,max : 40000 }
  luminosity :  { min : 10e4    ,max : 10e6 }
  planets :
    count : { max : 18 }

RED_GIANT = nox.extend_template StarTemplate,'RED_GIANT',
  name : 'Red Giant'
  color_x : 'Red'
  temperature : { min : 3000    ,max : 4000 }
  luminosity :  { min : 1       ,max : 10e3 }
  planets :
    count : { max : 18 }

RED_SUPER_GIANT = nox.extend_template StarTemplate,'RED_SUPER_GIANT',
  name : 'Red Super Giant'
  color_x : 'Red'
  temperature : { min : 2500    ,max : 3500 }
  luminosity :  { min : 10e4    ,max : 10e5 }
  planets :
    count : { max : 18 }

BLUE_SUPER_GIANT = nox.extend_template StarTemplate,'BLUE_SUPER_GIANT',
  name : 'Blue Super Giant'
  color_x : 'Blue'
  temperature : { min : 8000    ,max : 10000 }
  luminosity :  { min : 10e4    ,max : 10e6 }
  planets :
    count : { max : 18 }

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


