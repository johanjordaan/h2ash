// Generated by CoffeeScript 1.6.3
(function() {
  var Planet, Star, StarSchema, mongoose;

  mongoose = require('mongoose');

  Planet = require('./planet');

  StarSchema = mongoose.Schema({
    _id: {
      type: String,
      required: true
    },
    name: String,
    temperature: Number,
    wavelength: Number,
    color: String,
    luminosity: Number,
    radius: Number,
    mass: Number,
    planets: [
      {
        type: String,
        ref: 'Planet'
      }
    ]
  });

  Star = mongoose.model('Star', StarSchema);

  module.exports = Star;

}).call(this);