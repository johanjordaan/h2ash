# TODO : 
# Rings
# Giant clasification
# Prety printing

_ = require 'underscore'
nox = require '../nox/nox'

moon_types = require './moon_types'
planet_types = require './planet_types'
star_types = require './star_types'
atmosphere_types = require './atmosphere_types'

# Start probability chart
#
STAR_TYPE_DISTRIBUTION = [
  nox.probability 0.01, star_types.DWARF
  nox.probability 0.70, star_types.M_CLASS
  nox.probability 0.13, star_types.K_CLASS
  nox.probability 0.09, star_types.G_CLASS
  nox.probability 0.01, star_types.F_CLASS
  nox.probability 0.01, star_types.A_CLASS 
  nox.probability 0.01, star_types.B_CLASS
  nox.probability 0.01, star_types.O_CLASS
  nox.probability 0.01, star_types.RED_GIANT 
  nox.probability 0.01, star_types.RED_SUPER_GIANT
  nox.probability 0.01, star_types.BLUE_SUPER_GIANT
]

DEFAULT_SOLAR_SYSTEM = nox.create_template 'DEFAULT_SOLAR_SYSTEM',
  name : 'Default'
  star : nox.select_one
    values : STAR_TYPE_DISTRIBUTION


#console.log types.construct(atmosphere_types.NORMAL_ATMOSPHERE)
#console.log types.construct(star_types.M_CLASS)
#console.log types.construct(planet_types.ASTEROID_BELT)
#console.log types.construct(planet_types.TERRAN)

#console.log types.construct(star_types.RED_SUPER_GIANT)
#console.log types.construct(moon_types.ASTEROID)
#console.log types.construct(star_types.DWARF)

#ss = nox.construct_template DEFAULT_SOLAR_SYSTEM
#console.log ss.star.planets

#console.log nox.construct_template moon_types.LUNAR_MOON
#console.log nox.construct_template moon_types.ASTEROID_MOON

#_.random = (min,max) ->
#  return max
#console.log star_types.M_CLASS.planets.count  
#console.log star_types.M_CLASS.planets.count.run()

#x = nox.construct_template star_types.M_CLASS
#console.log x
#console.log star_types.M_CLASS.planets.count.max,x.luminosity
#for planet in x.planets
#  console.log planet._index,planet.name,planet.atmosphere.name,planet.temperature   
#  for moon in planet.moons
#    console.log '   ',moon._index,moon.atmosphere.name,moon.temperature,moon._parent._parent.luminosity 
#    if !moon._parent._parent.luminosity?
#      console.log moon
#
#return

total_planets = 0
total_solar_systems = 0
habitable_planets = 0
habitable_solar_systems = 0
habitable_moons = 0
total_moons = 0
higest_habitable_count = 0
most_habitable_ss = {}

habitable = (o) ->
  if o.temperature > (270-20) && o.temperature < (370-50)
    if o.type == 'Rock'
      if o.atmosphere.pressure > -1 and o.atmosphere.pressure < 2
        if o.gravity >0.6 and o.gravity < 1.4
          return true
  return false

ss_count = 10000
for i in _.range(ss_count)
  ss = nox.construct_template DEFAULT_SOLAR_SYSTEM
  total_habitable_count = 0
  h_count = 0
  total_solar_systems += 1

  for planet in ss.star.planets
    total_planets++
    if(habitable(planet))
      h_count += 1
      total_habitable_count +=1

    for moon in planet.moons
      total_moons += 1
      if(habitable(moon))
        habitable_moons += 1
        total_habitable_count +=1

  habitable_planets += h_count;
  if(h_count>0)
    habitable_solar_systems += 1 

  if(total_habitable_count>higest_habitable_count)
    higest_habitable_count = total_habitable_count  
    most_habitable_ss = ss



habitable_planet_perc = (habitable_planets/total_planets)*100
habitable_moon_perc = (habitable_moons/total_moons)*100

moons_per_planet = total_moons/total_planets
planets_per_ss = total_planets/ss_count

#console.log most_habitable_ss
console.log "------------------ Stats [start] -----------------------"
console.log "Higest number of habitable places : #{higest_habitable_count}"
console.log "Total Solar Systems : #{total_solar_systems}"
console.log "Habitable Solar Systems : #{habitable_solar_systems}"
console.log "Total Planets : #{total_planets}"
console.log "Habitable Planets : #{habitable_planets}"
console.log "Total Moons : #{total_moons}"
console.log "Habitable Moons : #{habitable_moons}"
console.log "---"
console.log "Habitable Planet % : #{habitable_planet_perc}"
console.log "Habitable Moons % : #{habitable_moon_perc}"
console.log "Avg Moons per Planet : #{moons_per_planet}"
console.log "Avg Planets per Solar System : #{planets_per_ss}"
console.log "------------------ Stats [end]  -----------------------"




