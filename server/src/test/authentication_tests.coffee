_ = require 'underscore'
should = require('chai').should()
expect = require('chai').expect
request = require 'supertest'
mongoose = require 'mongoose'
async = require 'async'

app_setup = require '../app'
errors = require '../support/errors'
  
describe 'Authentication process', ->
  app = {}  
  dbs = {}

  before (done) ->
    app_setup true,(test_app,test_dbs) ->
      app = test_app
      dbs = test_dbs

      async.series [
        (cb) ->
          admin = dbs.h2ash_auth.User
            email : 'admin@h2ash.com'
            password : '123'
            admin : true
            validated : true
            registration_token : ""
            token : ""

          admin.save (err,res) ->
            cb(null,'')

        ], () ->
          done()

  describe 'login', ->
    it 'should not provide a token if the username and password is not correct', (done) ->
      request(app)
        .post("/authentication/login")
        .send( { email : 'some_user@there.com', password : 'xxxx'} )
        .end (err,res) ->
          res.status.should.equal 200
          json = JSON.parse(res.text)
          json.error_code.should.equal errors.INVALID_CREDENTIALS.error_code
          json.error_message.should.equal errors.INVALID_CREDENTIALS.error_message
          expect(json.token).to.not.exist
          done()
    
    it 'should not provide a token if the password is not correct', (done) ->
      request(app)
        .post("/authentication/login")
        .send( { email : 'admin@h2ash.com', password : 'xxxx'} )
        .end (err,res) ->
          res.status.should.equal 200
          json = JSON.parse(res.text)
          json.error_code.should.equal errors.INVALID_CREDENTIALS.error_code
          json.error_message.should.equal errors.INVALID_CREDENTIALS.error_message
          expect(json.token).to.not.exist
          done()

    it 'should provide a token in response to a user and password', (done) ->
      request(app)
        .post("/authentication/login")
        .send( { email : 'admin@h2ash.com', password : '123'} )
        .end (err,res) ->
          res.status.should.equal 200
          json = JSON.parse(res.text)
          json.error_code.should.equal errors.OK.error_code
          json.error_message.should.equal errors.OK.error_message
          json.admin.should.equal true
          done()

