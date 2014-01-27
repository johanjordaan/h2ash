async = require 'async'
mongoose = require 'mongoose'

errors = require '../support/errors'
reply_with = require '../support/reply_with'
generate_token = require '../support/generate_token'
auth_filters = require '../support/auth_filters'

UserSchema = require '../domain/user'

module.exports = (app,dbs,route_name) ->
  app.post route_name+'/start_testing_session', auth_filters.admin_auth, (req,res) ->
    dbs.h2ash_auth.conn.close () ->
      dbs.h2ash_auth = db_utils.open_db "mongodb://localhost/h2ash_test", 
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
              

  app.post route_name+'/end_testing_session', (req,res) ->
    dbs.h2ash_auth.conn.close () ->
      dbs.h2ash_auth = db_utils.open_db "mongodb://localhost/h2ash", 
        'User' : UserSchema
        , (db_context) ->
          console.log 'Database opened...'
          test_mode = false
          delete req.auth_user
          reply_with req,res,errors.OK


  console.log "test routes loaded to [#{route_name}]"