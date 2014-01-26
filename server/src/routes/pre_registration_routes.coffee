Lead = require '../domain/admin/lead'

errors = require '../support/errors'
reply_with = require '../support/reply_with'
generate_token = require '../support/generate_token'


module.exports = (app,auth,dbs,route_name) ->

  app.get route_name+'/register', (req,res) ->


    generate_token [req.body.email],(ex,token) -> 
      lead = new Lead
        email : req.body.email
        motivation : req.body.motivation
        validated : false
        validation_token : token 
      
      lead.Save (err,saved) ->  
      
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


