_ = require 'underscore' 

PI = Math.PI
G = 6.67e-11                               # Gravitational constant : N*(m.kg)^2 
AU = 149597871                             # Astronomical Unit : Km
LY = 9.4605284e12                 # Lightyear defined in km     
sigma = 5.670373e-8                        # Stefan-Boltzmann Konstant : W/(m^2*K^4)

Ls_Sun = 3.839e26                          # Luminosity of the Sun        
Ms_Sun = 1.989e30                           # Mass of sun : Kg
Rs_Sun = 695500                            # Radius of sum : Km

Rp_Earth = 6371                             # radius of earth : Km
Mp_Earth = 5.972e24                         # Mass of earth in kg 
g_Earth = -9.81                              # Acc fo gravity : m/s^2

SecondsPerYear = 31556926

Wiens_Constant = 0.0029                   # in m * K   


#WaterFreezingPoint:273.15
#WaterBoilingPoint:373.15

# Assumes the Lse - Luminosity reltive to sun exixst in o
# Assumes Ts - Temperature in Kelvin exists in o
# 
# Result is in radiums relative to sun
radius_of_star = (star) ->
  Lse = star.luminosity
  Ts = star.temperature

  Ls = Lse * Ls_Sun     # L of Sun multiplied with the L relative to Sun
  Rs = Math.pow( Ls/(4*PI*sigma*Math.pow(Ts,4)),0.5)/1000;
  return Rs/Rs_Sun  

mass_of_star = (star) ->
  Rse = star.radius
  #Rs = Math.pow(M,0.8)
  # Note log m^n = n * log m
  # log Rs = log M^0.8
  # log Rs = 0.8 * log M
  # log Rs/0.8 = log M
  # M = exp( log Rs/0.8 )
  Mse = Math.exp( Math.log(Rse)/0.8 )
  return Mse

# This does a simple 1.5-2.5 times the distance of the previous planet
#
# Result is in AU's
distance_of_planet = (planet) ->
  index = 0
  if(planet._index?)
    index = planet._index 

  ret_val = _.random(0.1*AU,0.3*AU)*Math.pow(2,index) 
  return ret_val/AU

# Result is in AU
distance_of_moon = (o) ->
  index = 0
  if(o._index?)
    index = o._index 
  ret_val = _.random(300000,400000)*Math.pow(2,index) 
  return ret_val/AU


# Assumes Lse is set on o
# Assumes d is set on o - in Km
# Assumes R is set in o - not used ??
temperature_of_planet = (planet) ->
  if !(planet._parent?)
    return 0

  alpha = 0   # from athmosphere?
  atmospheric_modifier = planet.atmosphere.temperature_modifier
  Lse = planet._parent.luminosity
  d = planet.distance * AU

  Ls = Lse * Ls_Sun
  Tp = Math.pow((Ls*(1-alpha)/(16*PI*Math.pow(d*1000,2)*sigma)),0.25);
  return Tp * atmospheric_modifier

temperature_of_moon = (moon) ->
  if !(moon._parent?)
    return 0
  if !(moon._parent._parent?)
    return 0  

  alpha = 0   # from athmosphere?
  atmospheric_modifier = moon.atmosphere.temperature_modifier
  Lse = moon._parent._parent.luminosity
  d = moon._parent.distance * AU

  Ls = Lse * Ls_Sun
  Tp = Math.pow((Ls*(1-alpha)/(16*PI*Math.pow(d*1000,2)*sigma)),0.25);
  Tp = Tp * atmospheric_modifier

  #if _.isNaN(Tp)
  #  console.log moon._parent._parent.name,moon._parent._parent.luminosity
  return Tp



# Relative to eart year ie 1 is 1 eart year
orbital_period_of_planet = (planet) ->
  if !(planet._parent?)
    return 0

  Ms = planet._parent.mass * Ms_Sun
  a = planet.distance * AU * 1000


  # Orbitalperiod for eliptal corbi is:
  # T = 2*PI * Sqrt(a^3/G*M)
  # T in second
  # a in meters lenth of semi major axis
  # G = Gravitational constant and M is mass of star

  T = (2*PI*Math.sqrt(Math.pow(a,3)/(G*Ms) ))  
  return T/SecondsPerYear

orbital_period_of_moon = (moon) ->
  return 0

mass_of_planet = (planet) ->
  density = planet.density # in g/cm3
  radius = planet.radius * Rp_Earth * 1000 * 100 # in cm
  volume = (4/3)*PI*Math.pow(radius,3) # in cm3
  mass  = density * volume # in g
  mass = mass / 1000 # kg
  return mass / Mp_Earth  # Result relative to earth mass  

gravity_of_planet = (planet) ->
  M = planet.mass * Mp_Earth
  r = planet.radius * Rp_Earth * 1000

  g = -G*M/(r*r)
  return g/g_Earth    #Result relative to earth gravity 

mass_of_moon = (moon) ->
  density = moon.density # in g/cm3
  radius = moon.radius * Rp_Earth * 1000 * 100 # in cm
  volume = (4/3)*PI*Math.pow(radius,3) # in cm3
  mass  = density * volume # in g
  mass = mass / 1000 # kg
  return mass / Mp_Earth  # Result relative to earth mass  


gravity_of_moon = (moon) ->
  

  M = moon.mass * Mp_Earth
  r = moon.radius * Rp_Earth * 1000

  g = -G*M/(r*r)
  return g/g_Earth    #Result relative to earth gravity 


# This implements Wien's law
# Peak Intensity (lambda_max ) in m = 0.0029 m*K / T in Kelvin
# result in nm
wavelength_from_temperature = (star) ->
  Ts = star.temperature
  return (Wiens_Constant / Ts) * 1e9

# Input wavelength in nm
# base on : astro.unl.edu
# Blue        : 72.5
# Light-Blue  : 145
# White       : 290
# Yellow-White: 387
# Yellow      : 527
# Orange      : 725
# Red         : 966 
color_from_wavelength = (star) ->
  wl = star.wavelength

  between = (value,lower,mid,upper) ->
    if lower
      lower = mid - (mid - lower)/2
    if upper
      upper = mid + (upper - mid)/2

    if lower? && upper?
      return value >= lower && value <= upper  
    else if lower? && !upper?
      return value >= lower
    else if !lower? && upper
      return value <= upper
    else 
      return false

  if between(wl,null,72.5,145) 
    return "Blue"
  if between(wl,72.5,145,290) 
    return "Light-Blue"
  if between(wl,145,290,387) 
    return "White"
  if between(wl,290,387,527) 
    return "Yellow-White"
  if between(wl,387,527,725) 
    return "Yellow"
  if between(wl,527,725,966) 
    return "Orange"
  if between(wl,725,966) 
    return "Red"    


module.exports =
  AU : AU
  LY : LY
  SOLAR_MASS : Ms_Sun
  SOLAR_RADIUS : Rs_Sun
  EARTH_RADIUS : Rp_Earth



  radius_of_star : radius_of_star
  mass_of_star : mass_of_star
  distance_of_planet : distance_of_planet
  distance_of_moon : distance_of_moon
  temperature_of_planet : temperature_of_planet
  temperature_of_moon : temperature_of_moon
  orbital_period_of_planet : orbital_period_of_planet
  orbital_period_of_moon : orbital_period_of_moon
  mass_of_planet : mass_of_planet
  gravity_of_planet : gravity_of_planet
  mass_of_moon : mass_of_moon
  gravity_of_moon : gravity_of_moon
  wavelength_from_temperature : wavelength_from_temperature
  color_from_wavelength : color_from_wavelength



