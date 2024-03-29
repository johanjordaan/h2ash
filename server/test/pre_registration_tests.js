// Generated by CoffeeScript 1.6.3
(function() {
  var app_setup, errors, expect, mongoose, request, should, _;

  _ = require('underscore');

  should = require('chai').should();

  expect = require('chai').expect;

  request = require('supertest');

  mongoose = require('mongoose');

  app_setup = require('../app');

  errors = require('../support/errors');

  describe('Pre-Registration process', function() {
    var app, dbs;
    app = {};
    dbs = {};
    before(function(done) {
      return app_setup(true, function(test_app, test_dbs) {
        app = test_app;
        dbs = test_dbs;
        return done();
      });
    });
    describe('registration', function() {
      it('should create a new lead in the admin database', function(done) {
        return request(app).post("/pre_registration/register").send({
          email: 'me@here.com',
          motivation: 'Because I like space games.'
        }).end(function(err, res) {
          var json;
          res.status.should.equal(200);
          json = JSON.parse(res.text);
          json.error_code.should.equal(errors.OK.error_code);
          json.error_message.should.equal(errors.OK.error_message);
          return dbs.h2ash_admin.Lead.find({
            email: 'me@here.com'
          }).exec(function(err, leads) {
            should.exist(leads);
            leads.length.should.equal(1);
            leads[0].email.should.equal('me@here.com');
            leads[0].should.have.property('validation_token')["with"].length(256 / 4);
            return done();
          });
        });
      });
      return it('should not add duplicates', function(done) {
        return request(app).post("/pre_registration/register").send({
          email: 'me@here.com',
          motivation: 'Because I like space games.'
        }).end(function(err, res) {
          var json;
          res.status.should.equal(200);
          json = JSON.parse(res.text);
          json.error_code.should.equal(errors.LEAD_NOT_VALIDATED.error_code);
          json.error_message.should.equal(errors.LEAD_NOT_VALIDATED.error_message);
          return dbs.h2ash_admin.Lead.find({
            email: 'me@here.com'
          }).exec(function(err, leads) {
            should.exist(leads);
            leads.length.should.equal(1);
            leads[0].email.should.equal('me@here.com');
            leads[0].should.have.property('validation_token')["with"].length(256 / 4);
            return done();
          });
        });
      });
    });
    return describe('validation', function() {
      it('should respond with an 302 to thankyou if the token cannot be found', function(done) {
        return request(app).get("/pre_registration/validate/xxx").end(function(err, res) {
          res.status.should.equal(302);
          return done();
        });
      });
      it('should validate the lead associated with the token and resond with a 302 to thankyou', function(done) {
        return dbs.h2ash_admin.Lead.findOne({
          email: 'me@here.com'
        }).exec(function(err, lead) {
          return request(app).get("/pre_registration/validate/" + lead.validation_token).end(function(err, res) {
            res.status.should.equal(302);
            return dbs.h2ash_admin.Lead.findOne({
              email: 'me@here.com'
            }).exec(function(err, validated_lead) {
              validated_lead.validated.should.equal(true);
              validated_lead.validation_token.should.equal('');
              return done();
            });
          });
        });
      });
      return it('should return with 302 thankyou if en empty validation token is supplied', function(done) {
        return request(app).get("/pre_registration/validate/%20").end(function(err, res) {
          res.status.should.equal(302);
          return done();
        });
      });
    });
  });

}).call(this);
