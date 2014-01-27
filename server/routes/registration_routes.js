// Generated by CoffeeScript 1.6.3
(function() {
  var errors, generate_token, reply_with;

  errors = require('../support/errors');

  reply_with = require('../support/reply_with');

  generate_token = require('../support/generate_token');

  module.exports = function(app, dbs, route_name) {
    app.post(route_name + '/register', function(req, res) {
      return dbs.h2ash_auth.User.findOne({
        email: req.body.email
      }).exec(function(err, user) {
        var new_user;
        if ((!err) && (user != null) && user.validated) {
          console.log("User " + req.body.email + " already exists");
          return reply_with(req, res, errors.DUPLICATE_USER);
        } else if ((!err) && (user != null) && (!user.validated)) {
          return user.generate_registration_token(function() {
            if (test_mode) {
              user.registration_token = req.body.email;
            }
            return user.save(function(err, saved) {
              console.log('new user saved (Updated)');
              return reply_with(req, res, errors.OK);
            });
          });
        } else if ((!err) && !(user != null)) {
          console.log('creating new user');
          new_user = new dbs.h2ash_auth.User({
            email: req.body.email,
            password: req.body.password,
            validated: false
          });
          return new_user.generate_registration_token(function() {
            if (test_mode) {
              new_user.registration_token = req.body.email;
            }
            return new_user.save(function(err, saved) {
              console.log('new user saved');
              return reply_with(req, res, errors.OK);
            });
          });
        }
      });
    });
    app.get(route_name + '/validate/:registration_token', function(req, res) {
      return dbs.h2ash_auth.User.findOne({
        registration_token: req.params.registration_token
      }).exec(function(err, user) {
        if ((!err) && (user != null)) {
          console.log('Registration token found');
          user.validated = true;
          user.registration_token = "";
          return user.save(function(err, saved) {
            console.log("User validated");
            return reply_with(req, res, errors.OK);
          });
        } else {
          console.log("Token not found. Returning OK to client.");
          return reply_with(req, res, errors.OK);
        }
      });
    });
    return console.log("registration routes loaded to [" + route_name + "]");
  };

}).call(this);
