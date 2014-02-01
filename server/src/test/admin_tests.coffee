_ = require 'underscore'
should = require('chai').should()
expect = require('chai').expect
request = require 'supertest'
mongoose = require 'mongoose'
async = require 'async'

app_setup = require '../app'
errors = require '../support/errors'
  
describe 'Admin process', ->
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

        ,(cb) ->
          lead = dbs.h2ash_admin.Lead
            email : 'lead1@here.com'
            motivation : 'I like games'
            validated : false

          lead.save (err,res) ->
            cb(null,'')
        
        ,(cb) ->
          lead = dbs.h2ash_admin.Lead
            email : 'lead2@here.com'
            motivation : 'Let me test ....'
            validated : true

          lead.save (err,res) ->
            cb(null,'')

        ], () ->
          done()

  describe 'get_leads', ->
    it 'should load all the leads', (done) ->
      token = ''
      async.series [
        (cb) ->
          request(app)
          .post("/authentication/login")
          .send 
            email : 'admin@h2ash.com'
            password : '123'
          .end (err,res) ->
            json = JSON.parse(res.text)
            token = json.auth_token
            cb null,''
        ,(cb) ->
          request(app)
          .post("/admin/get_leads")
          .send  
            auth_email : 'admin@h2ash.com'
            auth_token : token
          .end (err,res) ->
            res.status.should.equal 200
            json = JSON.parse(res.text)
            json.error_code.should.equal errors.OK.error_code
            json.error_message.should.equal errors.OK.error_message
            
            json.leads.length.should.equal 2

            done()
            cb null,''
      ] 

      
