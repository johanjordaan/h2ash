_ = require 'underscore'
async = require 'async'
mongoose = require 'mongoose'

nox = require '../nox/nox'
mem = require '../utils/memory'

StarSchema = require '../domain/star'
PlanetSchema = require '../domain/planet'
MoonSchema = require '../domain/moon'

astronomy = require './astronomy'

moon_types = require './moon_types'
planet_types = require './planet_types'
star_types = require './star_types'
atmosphere_types = require './atmosphere_types'

db_utils = require '../support/db_utils'

h2ash_stars = {}
async.parallel [
  (cb) ->
    h2ash_stars = db_utils.open_db "mongodb://localhost/h2ash_stars", 
      'Star' : StarSchema
      'Planet' : PlanetSchema
      'Moon' : MoonSchema
      , (db_context) ->
        console.log 'Database opened...'
        db_context.conn.db.dropDatabase () ->
          console.log 'Database dropped...'
          cb(null,'')
],() ->
  console.log 'All databases open ...'



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


  SOLAR_SYSTEM = nox.create_template 'SOLAR_SYSTEM',
    name : 'some arb solar system'
    star : nox.select_one
      values : STAR_TYPE_DISTRIBUTION

  save_stars = (offset,stars,last_batch,cb) ->  
    planets = []
    moons = []
    for i in _.range(stars.length)
      nox.de_nox stars[i]
      stars[i]._id = i+offset
      for ii in _.range(stars[i].planets.length)
        stars[i].planets[ii]._id = i+offset+'_'+ii
        stars[i].planets[ii].star = i+offset
        planets.push stars[i].planets[ii]
        for iii in _.range(stars[i].planets[ii].moons.length)
          stars[i].planets[ii].moons[iii]._id = i+offset+'_'+ii+'_'+iii
          stars[i].planets[ii].moons[iii].planet = i+offset+'_'+ii
          moons.push stars[i].planets[ii].moons[iii]

    h2ash_stars.Star.create stars, (err) ->
      if err
        cb err,null
      else
        h2ash_stars.Planet.create planets, (err) ->  
          if err
            cb err,null
          else
            h2ash_stars.Moon.create moons, (err) ->
              if err
                cb err,null
              else            
                if last_batch
                  console.log 'closing db'
                  h2ash_stars.conn.close()
                cb null,arguments

  GALAXY = nox.create_template 'GALAXY',
    name : 'a galaxy (it might be far far away)'
    stars : nox.select_batched
      count : 1000000
      values : STAR_TYPE_DISTRIBUTION
      batch_size : 10000
      batch_cb : (batch_size,batch_number,last_batch,current_batch,cb) ->
        console.log batch_size,batch_number,last_batch,current_batch.length

        console.log "Saving batch ... #{batch_number}"
        #save_stars batch_size*(batch_number-1),current_batch,last_batch,(err,res) ->
        #  if(err)
        #    console.log err
        #  else
        #    console.log "Batch saved ...#{batch_number}"
        #  cb()
        cb()

  g = nox.construct_template GALAXY      

  console.log g.stars.length
  return


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

  start = new Date
  stars = []
  mem_used = 0

  target_count = 100
  current_count = 0
  batch = []
  batch_size = 10
  last_batch_saved = true
  last_batch = false

  save_stars = (offset,stars,cb) ->  
    planets = []
    moons = []
    for i in _.range(stars.length)
      nox.de_nox stars[i]
      stars[i]._id = i+offset
      for ii in _.range(stars[i].planets.length)
        stars[i].planets[ii]._id = i+offset+'_'+ii
        stars[i].planets[ii].star = i+offset
        planets.push stars[i].planets[ii]
        for iii in _.range(stars[i].planets[ii].moons.length)
          stars[i].planets[ii].moons[iii]._id = i+offset+'_'+ii+'_'+iii
          stars[i].planets[ii].moons[iii].planet = i+offset+'_'+ii
          moons.push stars[i].planets[ii].moons[iii]

    h2ash_stars.Star.create stars, (err) ->
      if err
        cb err,null
      else
        h2ash_stars.Planet.create planets, (err) ->  
          if err
            cb err,null
          else
            h2ash_stars.Moon.create moons, (err) ->
              if err
                cb err,null
              else            
                cb null,arguments

  generate = () ->
    if last_batch_saved
      last_batch = current_count>=(target_count-batch_size)
      current_batch_size = batch_size
      if last_batch
        current_batch_size = target_count - current_count  

      console.log "Generating batch ..."
      for i in _.range(current_batch_size)
          ss = nox.construct_template DEFAULT_SOLAR_SYSTEM
          batch.push ss.star
      console.log "Batch generating finished"


      last_batch_saved = false
      console.log "Saving batch ... #{current_count} (#{batch.length}) "
      save_stars current_count,batch,(err,res) ->
        if(err)
          console.log err
        else
          last_batch_saved = true
          console.log "Batch saved ..."
          batch = []
          current_count += current_batch_size
          if last_batch
            h2ash_stars.conn.close()
            console.log "End : ",new Date() 
      if !last_batch      
        generate()
    else    
      setTimeout () -> 
        generate()
      ,100      


  console.log "Start : ",new Date()
  generate()





###

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
  ###



