_ = require 'underscore'

# This method handles the construction of return messages. It handles the errors codes
# as well as the tokens etc
#
reply_with = (req,res,error,data) ->
  reply = _.extend {},error
  if data?
    reply = _.extend reply,data
    
  if req.auth_user?
    reply.admin = req.auth_user.admin
    reply.auth_token = req.auth_user.token
  
  #console.log mem.rough_size_of_object reply
  
  res.json reply 

module.exports = reply_with