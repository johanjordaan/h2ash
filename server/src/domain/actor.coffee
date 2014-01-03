mongoose = require 'mongoose'

ActorSchema = mongoose.Schema
  race : String         # Human, Klingons, Borg, 
  clan : String         
  faction : String      
  
  name : String
  surname : String      # From clan list

  skills : []           # List of skills the user has

  assignment : []

  location : []

Actor = mongoose.model 'Actor', ActorSchema

module.exports = Actor