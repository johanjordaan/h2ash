async = require 'async'

UserSchema = require '../domain/user'
db_utils = require '../support/db_utils'

dbs = {}
async.parallel [
  (cb)->
    dbs.h2ash_auth = db_utils.open_db "mongodb://localhost/h2ash_auth", 
      'User' : UserSchema
      , (db_context) ->
        console.log "Database opened...[#{db_context.conn.name}]"
        db_context.conn.db.dropDatabase () ->
          console.log "Database dropped...[#{db_context.conn.name}]" 
          cb(null,'')
],() ->
  admin_user = new dbs.h2ash_auth.User
    email : 'admin@h2ash.com'
    password : '123'
    admin : true
    validated : true
    registration_token : ""
    token : ""

  admin_user.save (err,saved_user) ->
    if err
      console.log err
    else
      console.log "Saved user [#{saved_user.email}]"

    dbs.h2ash_auth.conn.close()  