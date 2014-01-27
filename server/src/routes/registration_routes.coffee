errors = require '../support/errors'
reply_with = require '../support/reply_with'
generate_token = require '../support/generate_token'

module.exports = (app,dbs,route_name) ->
  app.post route_name+'/register', (req,res) ->
    dbs.h2ash_auth.User.findOne
      email : req.body.email
    .exec (err,user) ->
      # If the user exists and has been validated then return an error
      #
      if (!err) and (user?) and (user.validated)
        console.log "User #{req.body.email} already exists"
        # User already exists
        #
        reply_with req, res, errors.DUPLICATE_USER
      
      # If the user exists but has not been validated then update the existing user
      #    
      else if(!err) and (user?) and (!user.validated)
        user.generate_registration_token () ->
          if test_mode
            user.registration_token = req.body.email
          user.save (err,saved) ->
            console.log 'new user saved (Updated)'
            reply_with req, res, errors.OK

      # If the user does not exist the create a new user
      #        
      else if(!err) and !(user?) 
        # The user does not exist so create it
        #
        console.log 'creating new user'
        new_user = new dbs.h2ash_auth.User
          email : req.body.email
          password : req.body.password
          validated : false

        new_user.generate_registration_token () ->
          if test_mode
            new_user.registration_token = req.body.email
          new_user.save (err,saved) ->
            console.log 'new user saved'
            reply_with req, res, errors.OK

  # This has to be a get in order for the user to able to simply click on a link
  # 
  app.get route_name+'/validate/:registration_token', (req,res) ->
    dbs.h2ash_auth.User.findOne
      registration_token : req.params.registration_token
    .exec (err,user) ->
      if(!err) and (user?)
        console.log 'Registration token found'
        user.validated = true
        user.registration_token = ""
        user.save (err,saved) ->
          console.log "User validated"
          reply_with req, res, errors.OK
      else
        console.log "Token not found. Returning OK to client."
        reply_with req, res, errors.OK

  console.log "registration routes loaded to [#{route_name}]"