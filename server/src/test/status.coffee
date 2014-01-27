_ = require 'underscore'
should = require('chai').should()
expect = require('chai').expect
request = require 'supertest'

app_setup = require '../app'
  

describe 'Connectors', ->
  app = {}  

  before (done) ->
    app_setup true,(local_app) ->
      app = local_app
      done()

  describe 'create', ->
    it "???????", (done) ->

      request(app)
        .post("/status")
        .send( {} )
        .expect(404, { }, done )

  describe 'create', ->
    it "should return a 400 error if there is no type specified", (done) ->
      
      request(app)
        .get("/status")
        .send( {} )
        .expect(200)
        .expect (res) ->
          res.text.status.should.equal "OK"

        .end (err,res) ->
          done()
