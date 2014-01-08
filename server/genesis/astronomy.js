// Generated by CoffeeScript 1.6.3
(function() {
  var AU, G, LY, Ls_Sun, Mp_Earth, Ms_Sun, PI, Rp_Earth, Rs_Sun, SecondsPerYear, Wiens_Constant, color_from_wavelength, distance_of_moon, distance_of_planet, g_Earth, gravity_of_moon, gravity_of_planet, mass_of_moon, mass_of_planet, mass_of_star, orbital_period_of_moon, orbital_period_of_planet, radius_of_star, sigma, temperature_of_moon, temperature_of_planet, wavelength_from_temperature, _;

  _ = require('underscore');

  PI = Math.PI;

  G = 6.67e-11;

  AU = 149597871;

  LY = 9.4605284e12;

  sigma = 5.670373e-8;

  Ls_Sun = 3.839e26;

  Ms_Sun = 1.989e30;

  Rs_Sun = 695500;

  Rp_Earth = 6371;

  Mp_Earth = 5.972e24;

  g_Earth = -9.81;

  SecondsPerYear = 31556926;

  Wiens_Constant = 0.0029;

  radius_of_star = function(star) {
    var Ls, Lse, Rs, Ts;
    Lse = star.luminosity;
    Ts = star.temperature;
    Ls = Lse * Ls_Sun;
    Rs = Math.pow(Ls / (4 * PI * sigma * Math.pow(Ts, 4)), 0.5) / 1000;
    return Rs / Rs_Sun;
  };

  mass_of_star = function(star) {
    var Mse, Rse;
    Rse = star.radius;
    Mse = Math.exp(Math.log(Rse) / 0.8);
    return Mse;
  };

  distance_of_planet = function(planet) {
    var index, ret_val;
    index = 0;
    if ((planet._index != null)) {
      index = planet._index;
    }
    ret_val = _.random(0.1 * AU, 0.3 * AU) * Math.pow(2, index);
    return ret_val / AU;
  };

  distance_of_moon = function(o) {
    var index, ret_val;
    index = 0;
    if ((o._index != null)) {
      index = o._index;
    }
    ret_val = _.random(300000, 400000) * Math.pow(2, index);
    return ret_val / AU;
  };

  temperature_of_planet = function(planet) {
    var Ls, Lse, Tp, alpha, atmospheric_modifier, d;
    if (!(planet._parent != null)) {
      return 0;
    }
    alpha = 0;
    atmospheric_modifier = planet.atmosphere.temperature_modifier;
    Lse = planet._parent.luminosity;
    d = planet.distance * AU;
    Ls = Lse * Ls_Sun;
    Tp = Math.pow(Ls * (1 - alpha) / (16 * PI * Math.pow(d * 1000, 2) * sigma), 0.25);
    return Tp * atmospheric_modifier;
  };

  temperature_of_moon = function(moon) {
    var Ls, Lse, Tp, alpha, atmospheric_modifier, d;
    if (!(moon._parent != null)) {
      return 0;
    }
    if (!(moon._parent._parent != null)) {
      return 0;
    }
    alpha = 0;
    atmospheric_modifier = moon.atmosphere.temperature_modifier;
    Lse = moon._parent._parent.luminosity;
    d = moon._parent.distance * AU;
    Ls = Lse * Ls_Sun;
    Tp = Math.pow(Ls * (1 - alpha) / (16 * PI * Math.pow(d * 1000, 2) * sigma), 0.25);
    Tp = Tp * atmospheric_modifier;
    return Tp;
  };

  orbital_period_of_planet = function(planet) {
    var Ms, T, a;
    if (!(planet._parent != null)) {
      return 0;
    }
    Ms = planet._parent.mass * Ms_Sun;
    a = planet.distance * AU * 1000;
    T = 2 * PI * Math.sqrt(Math.pow(a, 3) / (G * Ms));
    return T / SecondsPerYear;
  };

  orbital_period_of_moon = function(moon) {
    return 0;
  };

  mass_of_planet = function(planet) {
    var density, mass, radius, volume;
    density = planet.density;
    radius = planet.radius * Rp_Earth * 1000 * 100;
    volume = (4 / 3) * PI * Math.pow(radius, 3);
    mass = density * volume;
    mass = mass / 1000;
    return mass / Mp_Earth;
  };

  gravity_of_planet = function(planet) {
    var M, g, r;
    M = planet.mass * Mp_Earth;
    r = planet.radius * Rp_Earth * 1000;
    g = -G * M / (r * r);
    return g / g_Earth;
  };

  mass_of_moon = function(moon) {
    var density, mass, radius, volume;
    density = moon.density;
    radius = moon.radius * Rp_Earth * 1000 * 100;
    volume = (4 / 3) * PI * Math.pow(radius, 3);
    mass = density * volume;
    mass = mass / 1000;
    return mass / Mp_Earth;
  };

  gravity_of_moon = function(moon) {
    var M, g, r;
    M = moon.mass * Mp_Earth;
    r = moon.radius * Rp_Earth * 1000;
    g = -G * M / (r * r);
    return g / g_Earth;
  };

  wavelength_from_temperature = function(star) {
    var Ts;
    Ts = star.temperature;
    return (Wiens_Constant / Ts) * 1e9;
  };

  color_from_wavelength = function(star) {
    var between, wl;
    wl = star.wavelength;
    between = function(value, lower, mid, upper) {
      if (lower) {
        lower = mid - (mid - lower) / 2;
      }
      if (upper) {
        upper = mid + (upper - mid) / 2;
      }
      if ((lower != null) && (upper != null)) {
        return value >= lower && value <= upper;
      } else if ((lower != null) && (upper == null)) {
        return value >= lower;
      } else if ((lower == null) && upper) {
        return value <= upper;
      } else {
        return false;
      }
    };
    if (between(wl, null, 72.5, 145)) {
      return "Blue";
    }
    if (between(wl, 72.5, 145, 290)) {
      return "Light-Blue";
    }
    if (between(wl, 145, 290, 387)) {
      return "White";
    }
    if (between(wl, 290, 387, 527)) {
      return "Yellow-White";
    }
    if (between(wl, 387, 527, 725)) {
      return "Yellow";
    }
    if (between(wl, 527, 725, 966)) {
      return "Orange";
    }
    if (between(wl, 725, 966)) {
      return "Red";
    }
  };

  module.exports = {
    AU: AU,
    LY: LY,
    SOLAR_MASS: Ms_Sun,
    SOLAR_RADIUS: Rs_Sun,
    EARTH_RADIUS: Rp_Earth,
    radius_of_star: radius_of_star,
    mass_of_star: mass_of_star,
    distance_of_planet: distance_of_planet,
    distance_of_moon: distance_of_moon,
    temperature_of_planet: temperature_of_planet,
    temperature_of_moon: temperature_of_moon,
    orbital_period_of_planet: orbital_period_of_planet,
    orbital_period_of_moon: orbital_period_of_moon,
    mass_of_planet: mass_of_planet,
    gravity_of_planet: gravity_of_planet,
    mass_of_moon: mass_of_moon,
    gravity_of_moon: gravity_of_moon,
    wavelength_from_temperature: wavelength_from_temperature,
    color_from_wavelength: color_from_wavelength
  };

}).call(this);
