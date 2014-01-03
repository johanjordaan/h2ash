express = require 'express'
http = require 'http' 
#path = require 'path'
mongoose = require 'mongoose'

__ = require 'underscore'

errors = require './support/errors'

User = require './domain/user'

app = express()

app.set 'port', process.env.PORT || 3000
#app.set 'views', __dirname + '/views'
#app.set 'view engine', 'jade'
#app.use express.favicon()
app.use express.logger('dev')
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser('someVerySecretSecret123%%%4')
app.use express.session()
app.use app.router
#app.use express.static(path.join(__dirname, 'public'))
#app.use express.static(path.join(__dirname, 'bower_components'))


if ('development' == app.get('env'))
  app.use(express.errorHandler())  

# Connect to the database
#
mongoose.connect 'mongodb://localhost/h2ash'
db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')
db.once 'open', () ->
  console.log 'DB Open...'  

test_mode = false;  


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

  User.findOne
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

# This method handles the construction of return messages. It handles the errors codes
# as well as the tokens etc
#
reply_with = (req,res,error,data) ->
  reply = __.extend {},error
  if data?
    reply = __.extend reply,data
    
  if req.auth_user?
    reply.auth_token = req.auth_user.token
  
  console.log reply
  res.json reply 

# Admin Actions
#
app.post '/start_testing_session', admin_auth, (req,res) ->
  db.close () ->
    mongoose.connect 'mongodb://localhost/h2ash_test'
    db = mongoose.connection
    db.on 'error', console.error.bind(console, 'connection error:')
    db.once 'open', () ->
      mongoose.connection.db.dropDatabase () ->
        console.log 'Test DB Open'
        console.log 'Creating test admin'
        test_mode = true;
        
        # Create a new admin user for the test session
        #
        admin_user = new User
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
  db.close  () ->
    mongoose.connect 'mongodb://localhost/h2ash'
    db = mongoose.connection
    db.on 'error', console.error.bind(console, 'connection error:')
    db.once 'open', () ->
      console.log 'Live DB Open'
      test_mode = false
      delete req.auth_user
      reply_with req,res,errors.OK

# Actions
#
app.post '/login', (req,res) ->
  User.findOne 
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
  User.findOne
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
      new_user = new User
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
  User.findOne
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
require('./routes/corporation_routes') app,auth


app.post '/status', (req,res) ->
  reply_with req,res,errors.OK,
    status : 'OK'



###
# REST  
#
app.get '/projects', auth, (req,res) ->
  console.log req.session.user.projects
  res.json req.session.user.projects

app.get '/categories', (req,res) ->
  ret_val = [{key:'option_1',value:'option_1_value'},{key:'option_2',value:'option_2_value'}]
  res.json(ret_val);

app.get '/sub_categories/:category', (req,res) ->
  console.log req.params.category
  if req.params.category == 'option_1'
    ret_val = [{key:'option_1',value:'option_1_value_1'},{key:'option_2',value:'option_1_value_2'}]
  if req.params.category == 'option_2'
    ret_val = [{key:'option_1',value:'option_2_value_1'},{key:'option_2',value:'option_2_value_2'}]
  res.json(ret_val);



app.post '/models', (req,res) ->
  new_map = mapper.create mapper_maps.map_map,req.body
  store.save local_store,js_store,mapper_maps.map_map,new_map,(saved_map)->
    res.json(saved_map)   

app.get '/models', (req,res) ->
  store.load_all local_store,js_store,mapper_maps.map_map,(loaded_maps) ->
    ##console.log loaded_maps
    res.json(loaded_maps)

app.delete '/models', (req,res) ->
  console.log req.query.id
  res.json({})
###    


http.createServer(app).listen app.get('port'), () ->
  console.log('Express(h2ash) server listening on port ' + app.get('port'))

