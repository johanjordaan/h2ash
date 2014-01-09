trig = require '../utils/trig'
nox = require '../nox/nox'

planet_types = require './planet_types'
astronomy = require './astronomy'
star_name_gen = require './star_name_gen'


PositionTemplate = nox.create_template 'PositionTemplate',
  r : nox.rnd { min : 0, max : 100 * astronomy.LY }
  theta : nox.rnd { min : 0, max : 180 }
  phi : nox.rnd { min : 0, max : 360 }
  cc : nox.method
    method : (p) ->
      sc = trig.make_sc p.r,trig.deg2rad(p.theta),trig.deg2rad(p.phi)
      return trig.sc2cc sc 
  quadrant : "Gamma"
  sector : "Delta"
  region : ""
      


StarTemplate = nox.create_template 'StarTemplate',
  name : nox.method
    method : star_name_gen.generate_name
  class : "star class" 
  age : 10  
  position : nox.select_one 
    values : [PositionTemplate]
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
  class : 'White Dwarf'
  temperature : { min : 6000   ,max : 30000 }
  luminosity :  { min : 10e-4  ,max : 10e-2 }
  planets :
    count : { max : 2 }
    values : [
      nox.probability .2 , planet_types.ASTEROID_BELT
      nox.probability .8 , planet_types.ASTEROID
    ]

M_CLASS = nox.extend_template StarTemplate,'M_CLASS',
  class : 'M Class'
  temperature : { min : 2000   ,max : 4000 }
  luminosity :  { min : 10e-4  ,max : 10e-2 }
  planets :
    count : { max : 12 }

K_CLASS = nox.extend_template StarTemplate,'K_CLASS',
  class : 'K Class'
  temperature : { min : 4000   ,max : 5000 }
  luminosity :  { min : 10e-2  ,max : 0.1 }
  planets :
    count : { max : 12 }

G_CLASS = nox.extend_template StarTemplate,'G_CLASS',
  class : 'G Class'
  temperature : { min : 5000   ,max : 6000 }
  luminosity :  { min : 0.1    ,max : 4 }
  planets :
    count : { max : 12 }

F_CLASS = nox.extend_template StarTemplate,'F_CLASS',
  class : 'F Class'
  temperature : { min : 6000   ,max : 7000 }
  luminosity :  { min : 4      ,max : 12 }
  planets :
    count : { max : 18 }

A_CLASS = nox.extend_template StarTemplate,'A_CLASS',
  class : 'A Class'
  temperature : { min : 7000   ,max : 15000 }
  luminosity :  { min : 12     ,max : 10e3 }
  planets :
    count : { max : 18 }

B_CLASS = nox.extend_template StarTemplate,'B_CLASS',
  class : 'B Class'
  temperature : { min : 15000   ,max : 25000 }
  luminosity :  { min : 10e3    ,max : 10e4 }
  planets :
    count : { max : 18 }

O_CLASS = nox.extend_template StarTemplate,'O_CLASS',
  class : 'O Class'
  temperature : { min : 25000   ,max : 40000 }
  luminosity :  { min : 10e4    ,max : 10e6 }
  planets :
    count : { max : 18 }

RED_GIANT = nox.extend_template StarTemplate,'RED_GIANT',
  class : 'Red Giant'
  temperature : { min : 3000    ,max : 4000 }
  luminosity :  { min : 1       ,max : 10e3 }
  planets :
    count : { max : 18 }

RED_SUPER_GIANT = nox.extend_template StarTemplate,'RED_SUPER_GIANT',
  class : 'Red Super Giant'
  temperature : { min : 2500    ,max : 3500 }
  luminosity :  { min : 10e4    ,max : 10e5 }
  planets :
    count : { max : 18 }

BLUE_SUPER_GIANT = nox.extend_template StarTemplate,'BLUE_SUPER_GIANT',
  class : 'Blue Super Giant'
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


