# TODO : 
# Rings
# Giant clasification
# Prety printing

_ = require 'underscore'

types = require './types'

# Planet types
#
moon_types = require './moon_types'
planet_types = require './planet_types'
star_types = require './star_types'

return


atmosphere_types = require './atmosphere_types'

# Start probability chart
#
STAR_TYPE_DISTRIBUTION = [
  { probability : 0.01, type : star_types.DWARF }
  { probability : 0.70, type : star_types.M_CLASS }
  { probability : 0.13, type : star_types.K_CLASS }
  { probability : 0.09, type : star_types.G_CLASS }
  { probability : 0.01, type : star_types.F_CLASS }
  { probability : 0.01, type : star_types.A_CLASS } 
  { probability : 0.01, type : star_types.B_CLASS }
  { probability : 0.01, type : star_types.O_CLASS }
  { probability : 0.01, type : star_types.RED_GIANT } 
  { probability : 0.01, type : star_types.RED_SUPER_GIANT }
  { probability : 0.01, type : star_types.BLUE_SUPER_GIANT }
]

DEFAULT_SOLAR_SYSTEM =
  name : types.fixed { value : 'Default' }
  star : types.select_type_create_instance STAR_TYPE_DISTRIBUTION


#console.log types.construct(atmosphere_types.NORMAL_ATMOSPHERE)
#console.log types.construct(star_types.M_CLASS)
#console.log types.construct(planet_types.ASTEROID_BELT)
#console.log types.construct(planet_types.TERRAN)

#console.log types.construct(star_types.RED_SUPER_GIANT)
#console.log types.construct(moon_types.ASTEROID)
#console.log types.construct(star_types.DWARF)

#console.log types.construct DEFAULT_SOLAR_SYSTEM

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


for i in _.range(100000)
  ss = types.construct DEFAULT_SOLAR_SYSTEM
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

console.log most_habitable_ss
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



### Table 6
Pressure
-4 Vacuum of space
-2 Aircraft altitudes
-1 Top of Mount Everest
0 0 to 8000 ft above sea level
2 2000 ft below sea level
4 Mariana Trench
6 Surface of Jupiter
10 Black hole
###

### Table 7
Size 1 or 2: -4
Size 3: -4 to -2
Size 4: -4 to -1
Size 5: -2 to 1
Size 6: -1 to 2
Size 7: 1 to 4
Size 8: 2 to 5
Size 9: 4 to 7
Size 10: 5 to 8
### 

### Table 8 - 1d6 -3
-2 Inert gasses
0 Earth's atmosphere
2 Volcanic Ash
3 Chemical weapons
###




