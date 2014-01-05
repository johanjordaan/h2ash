nox = require '../nox/nox'

atmosphere_template = nox.create_template 'atmosphere_template',
  name : "name"
  pressure : nox.rnd
    min : 0
    max : 0 
  temperature_modifier : 0

NO_ATMOSPHERE = nox.extend_template atmosphere_template,'NO_ATMOSPHERE', 
  name : 'No Atmosphere'
  pressure : -4
  temperature_modifier : 1

VERY_THIN_ATMOSPHERE = nox.extend_template atmosphere_template,'VERY_THIN_ATMOSPHERE', 
  name : 'Very Thin Atmosphere'
  pressure : { min : -3 , max : -2}
  temperature_modifier : 1.2

THIN_ATMOSPHERE = nox.extend_template atmosphere_template,'THIN_ATMOSPHERE', 
  name : 'Thin Atmosphere'
  pressure : { min : -2 , max : -1}
  temperature_modifier : 1.5

NORMAL_ATMOSPHERE = nox.extend_template atmosphere_template,'NORMAL_ATMOSPHERE', 
  name : 'Earth Standard Atmosphere'
  pressure : { min : -1 , max : 2}
  temperature_modifier : 3

THICK_ATMOSPHERE = nox.extend_template atmosphere_template,'THICK_ATMOSPHERE', 
  name : 'Thick Atmosphere'
  pressure : { min : 2 , max : 4}
  temperature_modifier : 4

VERY_THICK_ATMOSPHERE = nox.extend_template atmosphere_template,'VERY_THICK_ATMOSPHERE', 
  name : 'Very Thick Atmosphere'
  pressure : { min : 4 , max : 7}
  temperature_modifier : 8

module.exports = 
  NO_ATMOSPHERE : NO_ATMOSPHERE
  VERY_THIN_ATMOSPHERE : VERY_THIN_ATMOSPHERE
  THIN_ATMOSPHERE : THIN_ATMOSPHERE
  NORMAL_ATMOSPHERE : NORMAL_ATMOSPHERE
  THICK_ATMOSPHERE : THICK_ATMOSPHERE
  VERY_THICK_ATMOSPHERE : VERY_THICK_ATMOSPHERE
