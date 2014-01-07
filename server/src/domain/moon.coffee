mongoose = require 'mongoose'

MoonSchema = mongoose.Schema
  planet :
    type: mongoose.Schema.ObjectId 
    ref: 'Planet'

  name : String
  radius : Number
  #atmospehere:
  distance : Number
  temperature : Number
  orbital_period : Number
  density : Number
  mass : Number
  gravity : Number

Moon = mongoose.model 'Moon', MoonSchema

module.exports = Moon
