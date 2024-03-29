// Generated by CoffeeScript 1.6.3
(function() {
  var Agent, AgentSchema, Corporation, mongoose;

  mongoose = require('mongoose');

  Corporation = require('./corporation');

  AgentSchema = mongoose.Schema({
    corporation: {
      type: mongoose.Schema.ObjectId,
      ref: 'Corporation'
    },
    name: String,
    surname: String
  });

  Agent = mongoose.model('Agent', AgentSchema);

  module.exports = Agent;

}).call(this);
