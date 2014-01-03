Agent = require '../domain/agent'

module.exports = (app,auth) ->

  # This is all relative to the current corporation
  #
  app.post '/get/agents', auth, (req,res) ->
    reply_with req,res,errors.OK

  app.post '/create/agent', auth, (req,res) ->
    reply_with req,res,errors.OK

  app.post '/update/agent', auth, (req,res) ->
    reply_with req,res,errors.OK

  app.post '/delete/agent', auth, (req,res) ->
    reply_with req,res,errors.OK
