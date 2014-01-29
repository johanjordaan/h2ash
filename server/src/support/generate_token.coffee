crypto = require 'crypto'

generate_token = (data,cb)->
   crypto.randomBytes 256,(ex,buff) ->
    hash = crypto.createHash('sha256')
    for item in data
      hash.update item
    hash.update buff
    token = hash.digest('hex')
    #console.log "New token generated [#{token}]"
    cb(null,token)

module.exports = generate_token