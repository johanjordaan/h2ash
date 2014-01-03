mongoose = require 'mongoose'

async = require 'async'

User = require '../domain/user'
Actor = require '../domain/actor'

mongoose.connect 'mongodb://localhost/h2ash'

admin_actor = new Actor
  name : 'q'

admin_user = new User
  email : 'admin@h2ash.com'
  password : '123'
  actors : [admin_actor]
  admin : true
  validated : true
  registration_token : ""
  token : ""

db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')
db.once 'open', () ->
  mongoose.connection.db.dropDatabase () ->

    async.series [ 
      (cb) -> 
        admin_actor.save (err,saved) ->   
          cb(null,1)
      ,(cb) ->    
        admin_user.save (err,saved) ->
          if(err)
            console.log err
          else
            console.log 'Admin user saved.'
          User.findOne
            email : /admin@h2ash.com/
          .populate('actors')
          .exec (err,found) ->
              if(err)
                console.log err
              else  
                console.log found.check_password '1234'  
                console.log found.check_password '123'  
                console.log found.actors[0].name

              db.close()
              cb(null,2)
      ]        


