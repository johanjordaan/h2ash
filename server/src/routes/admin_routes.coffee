errors = require '../support/errors'
reply_with = require '../support/reply_with'
generate_token = require '../support/generate_token'

module.exports = (app,dbs,auth_filters,route_name) ->
  app.post route_name+'/get_leads', auth_filters.admin_auth,  (req,res) ->
    dbs.h2ash_admin.Lead.find() 
    .select('email motivation validated')
    .exec (err,leads) ->
      reply_with req,res,errors.OK,
        leads : leads

  console.log "admin routes loaded to [#{route_name}]"