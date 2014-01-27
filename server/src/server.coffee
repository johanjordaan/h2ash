"use strict"

_ = require 'underscore'
http = require 'http' 

app_setup = require './app'

test_mode = false
args = process.argv.splice 2
if '-t' in args
  test_mode = true

app_setup test_mode,(app,dbs) ->
  http.createServer(app).listen app.get('port'), () ->
    console.log('Express(h2ash) server listening on port ' + app.get('port'))