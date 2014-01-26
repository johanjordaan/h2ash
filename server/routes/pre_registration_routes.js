// Generated by CoffeeScript 1.6.3
(function() {
  var Lead, errors, generate_token, reply_with;

  Lead = require('../domain/admin/lead');

  errors = require('../support/errors');

  reply_with = require('../support/reply_with');

  generate_token = require('../support/generate_token');

  module.exports = function(app, auth, dbs, route_name) {
    app.get(route_name + '/register', function(req, res) {
      return generate_token([req.body.email], function(ex, token) {
        var lead;
        lead = new Lead({
          email: req.body.email,
          motivation: req.body.motivation,
          validated: false,
          validation_token: token
        });
        return lead.Save(function(err, saved) {
          return reply_with(req, res, errors.OK);
        });
      });
    });
    return app.get(route_name + '/validate/:validation_token', function(req, res) {
      return dbs.h2ash_admin.Lead.findOne({
        validated: false,
        validation_token: req.params.validation_token
      }).exec(function(err, lead) {
        if ((!err) && (lead != null)) {
          console.log('Registration token found');
          lead.validated = true;
          return lead.save(function(err, saved) {
            console.log("Lead validated");
            return reply_with(req, res, errors.OK);
          });
        } else {
          console.log("Token not found. Returning OK to client.");
          return reply_with(req, res, errors.OK);
        }
      });
    });
  };

}).call(this);
