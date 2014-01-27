errors = require '../support/errors'
reply_with = require '../support/reply_with'
generate_token = require '../support/generate_token'
auth_filters = require '../support/auth_filters'

module.exports = (app,dbs,route_name) ->
  app.post route_name+'/login', (req,res) ->
    dbs.h2ash_auth.User.findOne 
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

  app.post route_name+'/logout', auth_filters.auth, (req, res) ->
    req.auth_user.token = ""
    req.auth_user.save (err,saved) ->
      delete req.auth_user
      reply_with req, res, errors.OK

  console.log "authentication routes loaded to [#{route_name}]"