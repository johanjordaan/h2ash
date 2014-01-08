_ = require 'underscore'
async = require 'async'

nox = require '../nox/nox'
mem = require '../utils/memory'



mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/h2ash_stars'
db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')
db.once 'open', () ->
  mongoose.connection.db.dropDatabase () ->

    Star = require '../domain/star'
    Planet = require '../domain/planet'
    Moon = require '../domain/moon'




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

      Star.create stars, (err) ->
        if err
          cb err,null
        else
          Planet.create planets, (err) ->  
            if err
              cb err,null
            else
              Moon.create moons, (err) ->
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
              db.close()
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
    save_stars = (stars) ->    
      create_children_for_parent = (children_key,db_class,parent,index) ->
        return (cb) ->
          list = if children_key? then parent[children_key] else parent
          db_class.create list, (err) ->
            if err
              console.log '----->',children_key,err,arguments
            else
              saved_items = []
              for key in _.keys(arguments)[1..]
                saved_items.push arguments[key] 
              if children_key?
                parent[children_key] = saved_items
            cb(null,1)
       
      create_moons_for_planet = _.partial(create_children_for_parent,'moons',Moon)
      create_planets_for_star = _.partial(create_children_for_parent,'planets',Planet)
      create_star = _.partial(create_children_for_parent,null,Star) 

      async.series [
        # 1) Save all the moons, planets and stars
        #
        (cb) ->  
          create_moons = []    
          for star in stars
            create_moons  = create_moons.concat _.map(star.planets,create_moons_for_planet) 

          async.series create_moons, () ->
            console.log "Saved moons from [#{create_moons.length}] planets"

            create_planets = _.map(stars,create_planets_for_star) 
            
            async.series create_planets, () ->   
              console.log "Saved planets from [#{create_planets.length}] stars"

              create_stars = _.map(stars,create_star)

              async.series create_stars, () ->
                console.log "Saved [#{create_stars.length}] stars"

                cb null,1
        ,(cb) ->
          db.close()
          cb(null,'')
      ]          

    save_stars stars           

    return
###

    #asyn.series [
    #  (cb) ->
    #]    


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
###

###
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



