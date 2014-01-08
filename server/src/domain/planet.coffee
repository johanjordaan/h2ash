mongoose = require 'mongoose'

PlanetSchema = mongoose.Schema
  _id :
    type : String
    required : true

  star :
    type: String 
    ref: 'Star'

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
  moons : [
    type : String
    ref: 'Moon'
  ]


Planet = mongoose.model 'Planet', PlanetSchema

module.exports = Planet