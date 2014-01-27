express = require 'express'

handle_CORS = require './support/handle_CORS'

config = (app) ->
 
  app.set 'port', process.env.PORT || 3000
  #app.set 'views', __dirname + '/views'
  #app.set 'view engine', 'jade'
  #app.use express.favicon()
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser('someVerySecretSecret123%%%4')
  app.use express.session()
  app.use handle_CORS
  app.use app.router
  #app.use express.static(path.join(__dirname, 'public'))
  #app.use express.static(path.join(__dirname, 'bower_components'))

  if ('development' == app.get('env'))
    app.use(express.errorHandler())  
 
module.exports = config