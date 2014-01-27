express = require 'express'
http = require 'http' 
#path = require 'path'

_ = require 'underscore'
async = require 'async'
mongoose = require 'mongoose'

mem = require './utils/memory'

errors = require './support/errors'
db_utils = require './support/db_utils'
reply_with = require './support/reply_with'

UserSchema = require './domain/user'
LeadSchema = require './domain/admin/lead'

StarSchema = require './domain/star'
PlanetSchema = require './domain/planet'
MoonSchema = require './domain/moon'


app = express()

require('./config') app



# Connect to the database
#
test_mode = false;  
h2ash_auth = {}     # TODO : Factor these out ...
h2ash_stars = {}
dbs = {}
async.parallel [
  (cb) ->
    h2ash_stars = dbs.h2ash_stars = db_utils.open_db "mongodb://localhost/h2ash_stars", 
      'Star' : StarSchema
      'Planet' : PlanetSchema
      'Moon' : MoonSchema
      , (db_context) ->
        console.log 'Database opened...[h2ash_stars]' 
        cb(null,'')
  ,(cb) ->
    h2ash_auth = dbs.h2ash_auth = db_utils.open_db "mongodb://localhost/h2ash", 
      'User' : UserSchema
      , (db_context) ->
        console.log 'Database opened...[h2ash_auth]'
        cb(null,'')
  ,(cb) ->
    dbs.h2ash_admin = db_utils.open_db "mongodb://localhost/h2ash_admin", 
      'Lead' : LeadSchema
      , (db_context) ->
        console.log 'Database opened...[h2ash_admin]'
        cb(null,'')
],() ->
  console.log 'All databases open ...'
  http.createServer(app).listen app.get('port'), () ->
    console.log('Express(h2ash) server listening on port ' + app.get('port'))

# This is my auth filter. It checks the current token and validates
# it. It further creates a new token for the next request. If the token 
# invalid it returns the default json action requireing the client to logon 
# again.
# If a user has been found it is added to the res object to be used later
#
do_auth = (req,res,next,admin) ->
  console.log "Running auth... [admin=#{admin}] #{req.body.auth_email}"
  if !req.body.auth_token? or req.body.auth_token == ""
    console.log 'Here'
    res.json errors.NOT_AUTHED
    return
  
  if !req.body.auth_email? or req.body.auth_email == ""
    console.log 'Here 2'
    res.json errors.NOT_AUTHED
    return

  h2ash_auth.User.findOne
    email : req.body.auth_email
    token : req.body.auth_token 
  .exec (err,user) ->
    if(!err) and (user?)
      console.log 'Found ...'

      if admin and !user.admin
        consoe.log 'Admin right required'
        res.json errors.NOT_AUTHED
        return

      user.generate_token () ->
        user.save (err,saved) ->
          req.auth_user = saved
          next()
    else
      console.log 'Not Found ...'    
      res.json errors.NOT_AUTHED


auth = (req, res, next) ->
  do_auth req,res,next,false

admin_auth = (req, res, next) ->
  do_auth req,res,next,true


# Admin Actions
#
app.post '/start_testing_session', admin_auth, (req,res) ->
  h2ash_auth.conn.close () ->
    h2ash_auth = db_utils.open_db "mongodb://localhost/h2ash_test", 
      'User' : UserSchema
      , (db_context) ->
        console.log 'Test Database opened...'
        db_context.conn.db.dropDatabase () ->
          console.log 'Test Database dropped...'
          test_mode = true;

          console.log 'Creating test admin'
          
          # Create a new admin user for the test session
          #
          admin_user = new db_context.User
            email : 'admin@h2ash.com'
            password : '123'
            admin : true
            validated : true
            registration_token : ""
            token : ""
          admin_user.save (err,saved) ->
            console.log 'Admin user saved'  
            delete req.auth_user
            reply_with req,res,errors.OK
            

app.post '/end_testing_session', (req,res) ->
  h2ash_auth.conn.close () ->
    h2ash_auth = db_utils.open_db "mongodb://localhost/h2ash", 
      'User' : UserSchema
      , (db_context) ->
        console.log 'Database opened...'
        test_mode = false
        delete req.auth_user
        reply_with req,res,errors.OK

# Actions
#
app.post '/login', (req,res) ->
  h2ash_auth.User.findOne 
    email : req.body.email
  .exec (err,user) ->
    if (!err) and (user?)
      if !user.validated 
        reply_with req,res,errors.USER_NOT_VALIDATED
        return

      if user.check_password req.body.password
        user.generate_token () ->
          user.save (err,saved) ->
            req.auth_user = saved
            console.log 'Logged in OK'
            reply_with req, res, errors.OK
      else
        reply_with req, res, errors.INVALID_CREDENTIALS
    else        
      reply_with req, res, errors.INVALID_CREDENTIALS

app.post '/logout', auth, (req, res) ->
  req.auth_user.token = ""
  req.auth_user.save (err,saved) ->
    delete req.auth_user
    reply_with req, res, errors.OK

app.post '/overview', auth, (req, res) ->
  reply_with req, res, errors.OK,
    action_points : 10


app.post '/register', (req,res) ->
  h2ash_auth.User.findOne
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
      new_user = new h2ash_auth.User
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
app.get '/validate/:registration_token', (req,res) ->
  h2ash_auth.User.findOne
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


#require('./routes/authentication_routes') app,auth
#require('./routes/registration_routes') app,auth
require('./routes/pre_registration_routes') app,auth,dbs,'/pre_registration'
require('./routes/corporation_routes') app,auth

app.post '/status', (req,res) ->
  reply_with req,res,errors.OK,
    status : 'OK'

app.get '/get_stars', (req,res) ->
  starDB = mongoose.createConnection 'mongodb://localhost/authors'


  h2ash_stars.Star.find()
  .select('name wavelength position.cc.x position.cc.y position.cc.z')
  .exec (err,loaded) ->
    reply_with req,res,errors.OK,
      err : err
      status : 'OK'
      stars : loaded



