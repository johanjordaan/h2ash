mongoose = require 'mongoose'

StarSchema = mongoose.Schema
  _id :
    type : String
    required : true
  position :
    r : Number
    theta : Number
    phi : Number
    cc : 
      x : Number
      y : Number
      z : Number
  name : String
  class : String
  temperature : Number
  wavelength : Number
  color : String
  luminosity : Number
  radius : Number
  mass : Number
  lifetime : Number
  planets : [
    type : String
    ref: 'Planet'
  ]

module.exports = StarSchema
