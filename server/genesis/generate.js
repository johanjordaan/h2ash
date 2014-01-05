// Generated by CoffeeScript 1.6.3
(function() {
  var DEFAULT_SOLAR_SYSTEM, STAR_TYPE_DISTRIBUTION, atmosphere_types, h_count, habitable, habitable_moon_perc, habitable_moons, habitable_planet_perc, habitable_planets, habitable_solar_systems, higest_habitable_count, i, moon, moon_types, moons_per_planet, most_habitable_ss, nox, planet, planet_types, planets_per_ss, ss, ss_count, star_types, total_habitable_count, total_moons, total_planets, total_solar_systems, _, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;

  _ = require('underscore');

  nox = require('../nox/nox');

  moon_types = require('./moon_types');

  planet_types = require('./planet_types');

  star_types = require('./star_types');

  atmosphere_types = require('./atmosphere_types');

  STAR_TYPE_DISTRIBUTION = [nox.probability(0.01, star_types.DWARF), nox.probability(0.70, star_types.M_CLASS), nox.probability(0.13, star_types.K_CLASS), nox.probability(0.09, star_types.G_CLASS), nox.probability(0.01, star_types.F_CLASS), nox.probability(0.01, star_types.A_CLASS), nox.probability(0.01, star_types.B_CLASS), nox.probability(0.01, star_types.O_CLASS), nox.probability(0.01, star_types.RED_GIANT), nox.probability(0.01, star_types.RED_SUPER_GIANT), nox.probability(0.01, star_types.BLUE_SUPER_GIANT)];

  DEFAULT_SOLAR_SYSTEM = nox.create_template('DEFAULT_SOLAR_SYSTEM', {
    name: 'Default',
    star: nox.select_one({
      values: STAR_TYPE_DISTRIBUTION
    })
  });

  total_planets = 0;

  total_solar_systems = 0;

  habitable_planets = 0;

  habitable_solar_systems = 0;

  habitable_moons = 0;

  total_moons = 0;

  higest_habitable_count = 0;

  most_habitable_ss = {};

  habitable = function(o) {
    if (o.temperature > (270 - 20) && o.temperature < (370 - 50)) {
      if (o.type === 'Rock') {
        if (o.atmosphere.pressure > -1 && o.atmosphere.pressure < 2) {
          if (o.gravity > 0.6 && o.gravity < 1.4) {
            return true;
          }
        }
      }
    }
    return false;
  };

  ss_count = 10000;

  _ref = _.range(ss_count);
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    i = _ref[_i];
    ss = nox.construct_template(DEFAULT_SOLAR_SYSTEM);
    total_habitable_count = 0;
    h_count = 0;
    total_solar_systems += 1;
    _ref1 = ss.star.planets;
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      planet = _ref1[_j];
      total_planets++;
      if (habitable(planet)) {
        h_count += 1;
        total_habitable_count += 1;
      }
      _ref2 = planet.moons;
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        moon = _ref2[_k];
        total_moons += 1;
        if (habitable(moon)) {
          habitable_moons += 1;
          total_habitable_count += 1;
        }
      }
    }
    habitable_planets += h_count;
    if (h_count > 0) {
      habitable_solar_systems += 1;
    }
    if (total_habitable_count > higest_habitable_count) {
      higest_habitable_count = total_habitable_count;
      most_habitable_ss = ss;
    }
  }

  habitable_planet_perc = (habitable_planets / total_planets) * 100;

  habitable_moon_perc = (habitable_moons / total_moons) * 100;

  moons_per_planet = total_moons / total_planets;

  planets_per_ss = total_planets / ss_count;

  console.log("------------------ Stats [start] -----------------------");

  console.log("Higest number of habitable places : " + higest_habitable_count);

  console.log("Total Solar Systems : " + total_solar_systems);

  console.log("Habitable Solar Systems : " + habitable_solar_systems);

  console.log("Total Planets : " + total_planets);

  console.log("Habitable Planets : " + habitable_planets);

  console.log("Total Moons : " + total_moons);

  console.log("Habitable Moons : " + habitable_moons);

  console.log("---");

  console.log("Habitable Planet % : " + habitable_planet_perc);

  console.log("Habitable Moons % : " + habitable_moon_perc);

  console.log("Avg Moons per Planet : " + moons_per_planet);

  console.log("Avg Planets per Solar System : " + planets_per_ss);

  console.log("------------------ Stats [end]  -----------------------");

}).call(this);
