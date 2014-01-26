mongoose = require 'mongoose'

LeadSchema = mongoose.Schema
  email : String
  motivation : String
  validated : Boolean
  validation_token : String
  date : 
    type: Date
    default: Date.now

module.exports = LeadSchema
