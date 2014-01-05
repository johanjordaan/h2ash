_ = require 'underscore'
nox = require '../nox/nox'
astronomy = require './astronomy'
atmosphere_types = require './atmosphere_types'
planet_types = require './planet_types'

moon_template = nox.create_template 'moon_template',
  mass : nox.method
    method : astronomy.mass_of_moon
  gravity : nox.method
    method : astronomy.gravity_of_moon 
  distance : nox.method
    method  : astronomy.distance_of_moon  
  temperature : nox.method
    method : astronomy.temperature_of_moon
  orbital_period : nox.method
    method : astronomy.orbital_period_of_moon 

ASTEROID_MOON = nox.extend_template planet_types.ASTEROID,'ASTEROID_MOON',moon_template,{ remove : ['moons'] }
SUB_LUNAR_MOON = nox.extend_template planet_types.SUB_LUNAR,'SUB_LUNAR_MOON',moon_template,{ remove : ['moons'] }
LUNAR_MOON = nox.extend_template planet_types.LUNAR,'LUNAR_MOON',moon_template,{ remove : ['moons'] }
SUPER_LUNAR_MOON = nox.extend_template planet_types.SUPER_LUNAR,'SUPER_LUNAR_MOON',moon_template,{ remove : ['moons'] }
SUB_TERRAN_MOON = nox.extend_template planet_types.SUB_TERRAN,'SUB_TERRAN_MOON',moon_template,{ remove : ['moons'] }
TERRAN_MOON = nox.extend_template planet_types.TERRAN,'TERRAN_MOON',moon_template,{ remove : ['moons'] }
SUPER_TERRAN_MOON = nox.extend_template planet_types.SUPER_TERRAN,'TERRAN_LUNAR_MOON',moon_template,{ remove : ['moons'] }

module.exports = 
  ASTEROID_MOON : ASTEROID_MOON
  SUB_LUNAR_MOON : SUB_LUNAR_MOON
  LUNAR_MOON : LUNAR_MOON
  SUPER_LUNAR_MOON : SUPER_LUNAR_MOON
  SUB_TERRAN_MOON : SUB_TERRAN_MOON
  TERRAN_MOON : TERRAN_MOON
  SUPER_TERRAN_MOON : SUPER_TERRAN_MOON



