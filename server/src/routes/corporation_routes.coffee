Corporation = require '../domain/corporation'

module.exports = (app,auth) ->

  # Get corporations for the auth_user
  #
  app.post '/get/corporations', auth, (req,res) ->
    reply_with req,res,errors.OK

  # Create a new corporation for the auth_user
  #   
  app.post '/create/corporation', auth, (req,res) ->
    reply_with req,res,errors.OK

  # Rename a corporation
  #  
  app.post '/rename/corporation', auth, (req,res) ->
    reply_with req,res,errors.OK

  # Delete the corporation for the auth_user
  # 
  app.post '/delete/corporation', auth, (req,res) ->
    reply_with req,res,errors.OK
