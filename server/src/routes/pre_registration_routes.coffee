errors = require '../support/errors'
reply_with = require '../support/reply_with'
generate_token = require '../support/generate_token'

mailer = require '../utils/mailer'
mail_templates = require '../support/mail_templates'

Lead = require '../domain/admin/lead'


module.exports = (app,dbs,route_name) ->

  app.post route_name+'/register', (req,res) ->

    email = req.body.email
    motivation = req.body.motivation

    dbs.h2ash_admin.Lead.findOne 
      email : email
    .exec (err,lead) ->
      if err
        console.log '------------',err

      if (!err) and (lead) and lead.validated
        reply_with req,res,errors.LEAD_EXISTS
      else  
        lead_existed = lead?
        if !lead_existed 
          lead = new dbs.h2ash_admin.Lead
            email : email
            motivation : motivation
            validated : false

        generate_token [email],(ex,token) -> 
          lead.validation_token = token

          mailer.send_mail 'djjordaan@gmail.com',mail_templates.pre_registration,
            link : 'http://secure.h2ash.com/api/pre_registration/validate/'
            token : token
          ,(err) ->
            console.log 'mail sent... pre-registration'
            if err?
              console.log err
              reply_with req,res,errors.LEAD_NOT_VALIDATED
            else
              lead.save (err,saved) ->  
                if lead_existed 
                  reply_with req,res,errors.LEAD_NOT_VALIDATED
                else 
                  reply_with req,res,errors.OK

  app.get route_name+'/validate/:validation_token', (req,res) ->

    ## This needs redirect to /#/pre_registration/validated

    dbs.h2ash_admin.Lead.findOne
      validated : false
      validation_token : req.params.validation_token
    .exec (err,lead) ->
      if(!err) and (lead?)
        console.log 'Registration token found'
        lead.validated = true
        lead.validation_token = ''
        lead.save (err,saved) ->
          console.log "Lead validated"
          res.redirect '/#/pre_registration/validated'
      else
        console.log "Token not found. Returning OK to client."
        res.redirect '/#/pre_registration/validated'

  console.log "pre-registration routes loaded to [#{route_name}]"


