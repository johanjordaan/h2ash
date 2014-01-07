mongoose = require 'mongoose'

PlanetSchema = mongoose.Schema
  star :
    type: mongoose.Schema.ObjectId 
    ref: 'Star'

  name : String
  radius : Number
  #atmospehere:
  distance : Number
  temperature : Number
  orbital_period : Number
  density : Number
  mass : Number
  gravity : Number
  moons : [
    type: mongoose.Schema.ObjectId 
    ref: 'Moon'
  ]


Planet = mongoose.model 'Planet', PlanetSchema

module.exports = Planet
