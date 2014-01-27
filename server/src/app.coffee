"use strict"

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

StarSchema = require './domain/star'
PlanetSchema = require './domain/planet'
MoonSchema = require './domain/moon'

UserSchema = require './domain/user'

LeadSchema = require './domain/admin/lead'

app = express()

require('./config') app

dbs = {}
status = "Live"

dont_drop_list = ['h2ash_stars']

make_db_name = (name,test_mode) ->
  db_name = "mongodb://localhost/"+name 
  if test_mode
    db_name = db_name + "_test"
  return db_name  

setup = (test_mode,cb) ->
  if test_mode
    status = "Test"

  async.parallel [
    (cb) ->
      db_name = "h2ash_stars"
      dbs.h2ash_stars = db_utils.open_db make_db_name(db_name,test_mode), 
        'Star' : StarSchema
        'Planet' : PlanetSchema
        'Moon' : MoonSchema
        , (db_context) ->
          console.log "Database opened...[#{db_context.conn.name}]" 
          if test_mode && db_name not in dont_drop_list
            db_context.conn.db.dropDatabase () ->
              console.log "Database dropped...[#{db_context.conn.name}]" 
              cb(null,'')
          else
            cb(null,'')
    ,(cb) ->
      db_name = "h2ash_auth"
      dbs.h2ash_auth = db_utils.open_db make_db_name("h2ash_auth",test_mode), 
        'User' : UserSchema
        , (db_context) ->
          console.log "Database opened...[#{db_context.conn.name}]"
          if test_mode && db_name not in dont_drop_list
            db_context.conn.db.dropDatabase () ->
              console.log "Database dropped...[#{db_context.conn.name}]" 
              cb(null,'')
          else
            cb(null,'')
    ,(cb) ->
      db_name = "h2ash_admin"
      dbs.h2ash_admin = db_utils.open_db make_db_name("h2ash_admin",test_mode), 
        'Lead' : LeadSchema
        , (db_context) ->
          console.log "Database opened...[#{db_context.conn.name}]"
          if test_mode && db_name not in dont_drop_list
            db_context.conn.db.dropDatabase () ->
              console.log "Database dropped...[#{db_context.conn.name}]" 
              cb(null,'')
          else
            cb(null,'')
  ],() ->
    console.log 'All databases open ...'

    require('./routes/pre_registration_routes') app,dbs,'/pre_registration'
    require('./routes/registration_routes') app,dbs,'/registration'
    require('./routes/authentication_routes') app,dbs,'/authentication'
    
    if test_mode? && test_mode
      require('./routes/test_routes') app,dbs,'/test'

    console.log 'All routes loaded ...'

    cb(app,dbs)

module.exports = setup


app.get '/status', (req,res) ->
  reply_with req,res,errors.OK,
    status : status
###
app.post '/overview', auth_filters.auth, (req, res) ->
  reply_with req, res, errors.OK,
    action_points : 10




app.get '/get_stars', (req,res) ->
  h2ash_stars.Star.find()
  .select('name wavelength position.cc.x position.cc.y position.cc.z')
  .exec (err,loaded) ->
    reply_with req,res,errors.OK,
      err : err
      status : 'OK'
      stars : loaded
###




