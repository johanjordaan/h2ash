_ = require 'underscore'
should = require('chai').should()
expect = require('chai').expect
request = require 'supertest'
mongoose = require 'mongoose'


app_setup = require '../app'
errors = require '../support/errors'
  
describe 'Pre-Registration process', ->
  app = {}  
  dbs = {}

  before (done) ->
    app_setup true,(test_app,test_dbs) ->
      app = test_app
      dbs = test_dbs
      done()

  describe 'registration', ->
    it 'should create a new lead in the admin database', (done) ->
      request(app)
        .post("/pre_registration/register")
        .send( { email : 'me@here.com', motivation : 'Because I like space games.'} )
        .end (err,res) ->
          res.status.should.equal 200
          json = JSON.parse(res.text)
          json.error_code.should.equal errors.OK.error_code
          json.error_message.should.equal errors.OK.error_message
          
          dbs.h2ash_admin.Lead.find
            email : 'me@here.com'
          .exec (err,leads) ->
            should.exist leads
            leads.length.should.equal 1
            leads[0].email.should.equal 'me@here.com'
            leads[0].should.have.property('validation_token').with.length(256/4)
            done()

    it 'should not add duplicates', (done) ->
      request(app)
        .post("/pre_registration/register")
        .send( { email : 'me@here.com', motivation : 'Because I like space games.'} )
        .end (err,res) ->
          res.status.should.equal 200
          json = JSON.parse(res.text)
          json.error_code.should.equal errors.LEAD_NOT_VALIDATED.error_code
          json.error_message.should.equal errors.LEAD_NOT_VALIDATED.error_message
          
          dbs.h2ash_admin.Lead.find
            email : 'me@here.com'
          .exec (err,leads) ->
            should.exist leads
            leads.length.should.equal 1
            leads[0].email.should.equal 'me@here.com'
            leads[0].should.have.property('validation_token').with.length(256/4)
            done()

  describe 'validation', ->
    it 'should respond with an ok if the token cannot be found', (done) ->
      request(app)
      .get("/pre_registration/validate/xxx")
      .end (err,res) ->
        res.status.should.equal 200  
        json = JSON.parse res.text
        json.error_code.should.equal errors.OK.error_code
        json.error_message.should.equal errors.OK.error_message
        done()

    it 'should validate the lead associated with the token', (done) ->
      dbs.h2ash_admin.Lead.findOne
        email : 'me@here.com'
      .exec (err,lead) ->
        request(app)
        .get("/pre_registration/validate/#{lead.validation_token}")
        .end (err,res) ->
          res.status.should.equal 200  
          json = JSON.parse res.text
          json.error_code.should.equal errors.OK.error_code
          json.error_message.should.equal errors.OK.error_message

          dbs.h2ash_admin.Lead.findOne
            email : 'me@here.com'
          .exec (err,validated_lead) ->
            validated_lead.validated.should.equal true
            validated_lead.validation_token.should.equal ''
            done()

    it 'should return with ok if en empty validation token is supplied', (done) ->
      request(app)
      .get("/pre_registration/validate/%20")
      .end (err,res) ->
        res.status.should.equal 200  
        json = JSON.parse res.text
        json.error_code.should.equal errors.OK.error_code
        json.error_message.should.equal errors.OK.error_message
        done()






