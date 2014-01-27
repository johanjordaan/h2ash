_ = require 'underscore'
should = require('chai').should()
expect = require('chai').expect
request = require 'supertest'
mongoose = require 'mongoose'


app_setup = require '../app'
  

describe 'Pre-Registration', ->
  app = {}  
  dbs = {}

  before (done) ->
    app_setup true,(test_app,test_dbs) ->
      app = test_app
      dbs = test_dbs
      done()

  #beforeEach (done) ->
  #  console.log "Hallo"
  #  done()    

  describe 'register', ->
    it 'should create a new lead in the admin database', (done) ->
      request(app)
        .post("/pre_registration/register")
        .send( { email : 'me@here.com', motivation : 'Because I like space games.'} )
        .end (err,res) ->
          res.status.should.equal 200
          json = JSON.parse(res.text)
          json.error_code.should.equal 0
          json.error_message.should.equal ''
          
          dbs.h2ash_admin.Lead.find
            email : 'me@here.com'
          .exec (err,res) ->
            should.exist res
            res.length.should.equal 1
            res[0].email.should.equal 'me@here.com'
            res[0].should.have.property('validation_token').with.length(256/4)
            done()

    it 'should not add duplicates', (done) ->
      request(app)
        .post("/pre_registration/register")
        .send( { email : 'me@here.com', motivation : 'Because I like space games.'} )
        .end (err,res) ->
          res.status.should.equal 200
          json = JSON.parse(res.text)
          #json.error_code.should.equal 1
          #json.error_message.should.equal 'xxx'
          
          dbs.h2ash_admin.Lead.find
            email : 'me@here.com'
          .exec (err,res) ->
            should.exist res
            res.length.should.equal 1
            
            #res.email.should.equal 'me@here.com'
            #res.should.have.property('validation_token').with.length(256/4)
            done()


