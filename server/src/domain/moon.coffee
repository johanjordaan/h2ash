mongoose = require 'mongoose'

MoonSchema = mongoose.Schema
  _id :
    type : String
    required : true

  planet :
    type: String
    ref: 'Planet'

  name : String
  radius : Number
  atmosphere:
    name : String
    pressure : Number
  distance : Number
  temperature : Number
  orbital_period : Number
  density : Number
  mass : Number
  gravity : Number


module.exports = MoonSchema
