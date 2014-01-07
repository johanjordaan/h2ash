mongoose = require 'mongoose'

Planet = require './planet'

StarSchema = mongoose.Schema
  name : String
  temperature : Number
  wavelength : Number
  color : String
  luminosity : Number
  radius : Number
  mass : Number
  planets : [
    type: mongoose.Schema.ObjectId 
    ref: 'Planet'
  ]

Star = mongoose.model 'Star', StarSchema

module.exports = Star
