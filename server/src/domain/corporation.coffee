mongoose = require 'mongoose'

User = require './user'

CorporationSchema = mongoose.Schema
  user : { 
    type: mongoose.Schema.ObjectId 
    ref: 'User'
  }
  name : String
  ceo : String

Corporation = mongoose.model 'Corporation', CorporationSchema

module.exports = Corporation
