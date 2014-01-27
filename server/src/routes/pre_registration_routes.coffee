errors = require '../support/errors'
reply_with = require '../support/reply_with'
generate_token = require '../support/generate_token'

Lead = require '../domain/admin/lead'


module.exports = (app,dbs,route_name) ->

  app.post route_name+'/register', (req,res) ->

    email = req.body.email

    dbs.h2ash_admin.Lead.findOne 
      email : email
    .exec (err,lead) ->
      if err
        console.log '------------',err

      if (!err) and (lead)
        if lead.validated
          # User has already validated and is on the list
          console.log '------ Validated user'
        else
          # User has not been validated, generate a new token and resend
          console.log '------ UnValidated user'
      else 
        # The user does not exist 
        console.log '------ User does not exist'       



    generate_token ['req.body.email'],(ex,token) -> 
      lead = new dbs.h2ash_admin.Lead
        email : req.body.email
        motivation : req.body.motivation
        validated : false
        validation_token : token 
      
      lead.save (err,saved) ->  
      
        # Send the registration email
        #

        reply_with req,res,errors.OK

  app.get route_name+'/validate/:validation_token', (req,res) ->

    dbs.h2ash_admin.Lead.findOne
      validated : false
      validation_token : req.params.validation_token
    .exec (err,lead) ->
      if(!err) and (lead?)
        console.log 'Registration token found'
        lead.validated = true
        lead.save (err,saved) ->
          console.log "Lead validated"
          reply_with req, res, errors.OK
      else
        console.log "Token not found. Returning OK to client."
        reply_with req, res, errors.OK

  console.log "pre-registration routes loaded to [#{route_name}]"


