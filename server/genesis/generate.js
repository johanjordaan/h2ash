// Generated by CoffeeScript 1.6.3
(function() {
  var MoonSchema, PlanetSchema, StarSchema, astronomy, async, atmosphere_types, db_utils, h2ash_stars, mem, mongoose, moon_types, nox, planet_types, star_types, _;

  _ = require('underscore');

  async = require('async');

  mongoose = require('mongoose');

  nox = require('../nox/nox');

  mem = require('../utils/memory');

  StarSchema = require('../domain/star');

  PlanetSchema = require('../domain/planet');

  MoonSchema = require('../domain/moon');

  astronomy = require('./astronomy');

  moon_types = require('./moon_types');

  planet_types = require('./planet_types');

  star_types = require('./star_types');

  atmosphere_types = require('./atmosphere_types');

  db_utils = require('../support/db_utils');

  h2ash_stars = {};

  async.parallel([
    function(cb) {
      return h2ash_stars = db_utils.open_db("mongodb://localhost/h2ash_stars", {
        'Star': StarSchema,
        'Planet': PlanetSchema,
        'Moon': MoonSchema
      }, function(db_context) {
        console.log('Database opened...');
        return db_context.conn.db.dropDatabase(function() {
          console.log('Database dropped...');
          return cb(null, '');
        });
      });
    }
  ], function() {
    var DEFAULT_SOLAR_SYSTEM, STAR_TYPE_DISTRIBUTION, batch, batch_size, current_count, generate, habitable, habitable_moons, habitable_planets, habitable_solar_systems, higest_habitable_count, last_batch, last_batch_saved, mem_used, most_habitable_ss, save_stars, stars, start, target_count, total_moons, total_planets, total_solar_systems;
    console.log('All databases open ...');
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
    start = new Date;
    stars = [];
    mem_used = 0;
    target_count = 1000;
    current_count = 0;
    batch = [];
    batch_size = 100;
    last_batch_saved = true;
    last_batch = false;
    save_stars = function(offset, stars, cb) {
      var i, ii, iii, moons, planets, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
      planets = [];
      moons = [];
      _ref = _.range(stars.length);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        i = _ref[_i];
        nox.de_nox(stars[i]);
        stars[i]._id = i + offset;
        _ref1 = _.range(stars[i].planets.length);
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          ii = _ref1[_j];
          stars[i].planets[ii]._id = i + offset + '_' + ii;
          stars[i].planets[ii].star = i + offset;
          planets.push(stars[i].planets[ii]);
          _ref2 = _.range(stars[i].planets[ii].moons.length);
          for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
            iii = _ref2[_k];
            stars[i].planets[ii].moons[iii]._id = i + offset + '_' + ii + '_' + iii;
            stars[i].planets[ii].moons[iii].planet = i + offset + '_' + ii;
            moons.push(stars[i].planets[ii].moons[iii]);
          }
        }
      }
      return h2ash_stars.Star.create(stars, function(err) {
        if (err) {
          return cb(err, null);
        } else {
          return h2ash_stars.Planet.create(planets, function(err) {
            if (err) {
              return cb(err, null);
            } else {
              return h2ash_stars.Moon.create(moons, function(err) {
                if (err) {
                  return cb(err, null);
                } else {
                  return cb(null, arguments);
                }
              });
            }
          });
        }
      });
    };
    generate = function() {
      var current_batch_size, i, ss, _i, _len, _ref;
      if (last_batch_saved) {
        last_batch = current_count >= (target_count - batch_size);
        current_batch_size = batch_size;
        if (last_batch) {
          current_batch_size = target_count - current_count;
        }
        console.log("Generating batch ...");
        _ref = _.range(current_batch_size);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          i = _ref[_i];
          ss = nox.construct_template(DEFAULT_SOLAR_SYSTEM);
          batch.push(ss.star);
        }
        console.log("Batch generating finished");
        last_batch_saved = false;
        console.log("Saving batch ... " + current_count + " (" + batch.length + ") ");
        save_stars(current_count, batch, function(err, res) {
          if (err) {
            return console.log(err);
          } else {
            last_batch_saved = true;
            console.log("Batch saved ...");
            batch = [];
            current_count += current_batch_size;
            if (last_batch) {
              h2ash_stars.conn.close();
              return console.log("End : ", new Date());
            }
          }
        });
        if (!last_batch) {
          return generate();
        }
      } else {
        return setTimeout(function() {
          return generate();
        }, 100);
      }
    };
    console.log("Start : ", new Date());
    return generate();
  });

  /*
  
        for i in _.range(ss_count)
          if !batch_saved
            continue
  
          ss = nox.construct_template DEFAULT_SOLAR_SYSTEM
          
          if batch.length<batch_size
            batch.push ss.star
          else
            batch_saved = false
            console.log "Saving batch ... "
            for star in batch
              delete star._parent
              delete star.planets          
            Star.create batch, (err,res) ->
              console.log 'Here...'  
              if(err)
                console.log err
              else
                batch_saved = true
                console.log "Batch saved ..."
                batch = []
  
  
  
  
          #mem_used += mem.rough_size_of_object ss
          if i%(ss_count*.01) == 0
            perc_done = (i/ss_count)*100
            console.log "#{perc_done}% - [#{i}]" #" : memory used [#{mem_used}]"
          total_habitable_count = 0
          h_count = 0
          total_solar_systems += 1
  
          #stars[stars.length] = ss.star
  
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
        end = new Date()
  
  
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
        console.log "Start : #{start}"
        console.log "End : #{end}" 
        console.log "------------------ Stats [end]  -----------------------"
  
        # Save partial batches and close db
        #
        db.close()
  
        start_save = new Date()
        console.log 'Saving',start_save
  
        for star in stars
          delete star._parent
          delete star.planets
  
        Star.create stars, (err,res) ->
          end_save = new Date()
          if(err)
            console.log err,end_save
          else   
            console.log "Saved stars #{ss_count}...",end_save
  
  
  
          db.close()
  */


}).call(this);
