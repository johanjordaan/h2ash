mongoose = require 'mongoose'
crypto = require 'crypto'

Actor = require './actor'

UserSchema = mongoose.Schema
  email : String
  password : String
  actors : [
    type: mongoose.Schema.ObjectId 
    ref: 'Actor'
  ],
  token : String
  registration_token : String
  validated : Boolean
  admin : Boolean

UserSchema.methods.check_password = (provided_password) ->
  @password == provided_password

UserSchema.methods.generate_token = (cb) ->
  that = this
  crypto.randomBytes 256,(ex,buff) ->
    hash = crypto.createHash('sha256')
    hash.update that.password
    hash.update buff
    that.token = hash.digest('hex')
    console.log "New token generated [#{that.token}]"
    cb()

UserSchema.methods.generate_registration_token = (cb) ->
  that = this
  crypto.randomBytes 256,(ex,buff) ->
    hash = crypto.createHash('sha256')
    hash.update that.password
    hash.update buff
    that.registration_token = hash.digest('hex')
    console.log "New registration token generated [#{that.registration_token}]"
    cb()

module.exports = UserSchema
