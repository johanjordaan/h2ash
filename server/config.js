// Generated by CoffeeScript 1.6.3
(function() {
  "use strict";
  var config, express, handle_CORS;

  express = require('express');

  handle_CORS = require('./support/handle_CORS');

  config = function(app) {
    app.set('port', process.env.PORT || 3000);
    app.use(express.logger('dev'));
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express.cookieParser('someVerySecretSecret123%%%4'));
    app.use(express.session());
    app.use(handle_CORS);
    app.use(app.router);
    if ('development' === app.get('env')) {
      return app.use(express.errorHandler());
    }
  };

  module.exports = config;

}).call(this);
