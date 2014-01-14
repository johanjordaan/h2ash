// Generated by CoffeeScript 1.6.3
(function() {
  var MoonSchema, PlanetSchema, StarSchema, UserSchema, admin_auth, app, async, auth, db_utils, do_auth, errors, express, h2ash_auth, h2ash_stars, handleCORS, http, mem, mongoose, reply_with, test_mode, _;

  express = require('express');

  http = require('http');

  _ = require('underscore');

  async = require('async');

  mongoose = require('mongoose');

  mem = require('./utils/memory');

  errors = require('./support/errors');

  db_utils = require('./support/db_utils');

  UserSchema = require('./domain/user');

  StarSchema = require('./domain/star');

  PlanetSchema = require('./domain/planet');

  MoonSchema = require('./domain/moon');

  app = express();

  handleCORS = function(req, res, next) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE,OPTIONS');
    res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Content-Length, X-Requested-With');
    if ('OPTIONS' === req.method) {
      res.send(200);
    }
    return next();
  };

  app.set('port', process.env.PORT || 3000);

  app.use(express.logger('dev'));

  app.use(express.bodyParser());

  app.use(express.methodOverride());

  app.use(express.cookieParser('someVerySecretSecret123%%%4'));

  app.use(express.session());

  app.use(handleCORS);

  app.use(app.router);

  if ('development' === app.get('env')) {
    app.use(express.errorHandler());
  }

  test_mode = false;

  h2ash_auth = {};

  h2ash_stars = {};

  async.parallel([
    function(cb) {
      return h2ash_stars = db_utils.open_db("mongodb://localhost/h2ash_stars", {
        'Star': StarSchema,
        'Planet': PlanetSchema,
        'Moon': MoonSchema
      }, function(db_context) {
        console.log('Database opened...');
        return cb(null, '');
      });
    }, function(cb) {
      return h2ash_auth = db_utils.open_db("mongodb://localhost/h2ash", {
        'User': UserSchema
      }, function(db_context) {
        console.log('Database opened...');
        return cb(null, '');
      });
    }
  ], function() {
    console.log('All databases open ...');
    return http.createServer(app).listen(app.get('port'), function() {
      return console.log('Express(h2ash) server listening on port ' + app.get('port'));
    });
  });

  do_auth = function(req, res, next, admin) {
    console.log("Running auth... [admin=" + admin + "] " + req.body.auth_email);
    if ((req.body.auth_token == null) || req.body.auth_token === "") {
      console.log('Here');
      res.json(errors.NOT_AUTHED);
      return;
    }
    if ((req.body.auth_email == null) || req.body.auth_email === "") {
      console.log('Here 2');
      res.json(errors.NOT_AUTHED);
      return;
    }
    return h2ash_auth.User.findOne({
      email: req.body.auth_email,
      token: req.body.auth_token
    }).exec(function(err, user) {
      if ((!err) && (user != null)) {
        console.log('Found ...');
        if (admin && !user.admin) {
          consoe.log('Admin right required');
          res.json(errors.NOT_AUTHED);
          return;
        }
        return user.generate_token(function() {
          return user.save(function(err, saved) {
            req.auth_user = saved;
            return next();
          });
        });
      } else {
        console.log('Not Found ...');
        return res.json(errors.NOT_AUTHED);
      }
    });
  };

  auth = function(req, res, next) {
    return do_auth(req, res, next, false);
  };

  admin_auth = function(req, res, next) {
    return do_auth(req, res, next, true);
  };

  reply_with = function(req, res, error, data) {
    var reply;
    reply = _.extend({}, error);
    if (data != null) {
      reply = _.extend(reply, data);
    }
    if (req.auth_user != null) {
      reply.auth_token = req.auth_user.token;
    }
    return res.json(reply);
  };

  app.post('/start_testing_session', admin_auth, function(req, res) {
    return h2ash_auth.conn.close(function() {
      return h2ash_auth = db_utils.open_db("mongodb://localhost/h2ash_test", {
        'User': UserSchema
      }, function(db_context) {
        console.log('Test Database opened...');
        return db_context.conn.db.dropDatabase(function() {
          var admin_user;
          console.log('Test Database dropped...');
          test_mode = true;
          console.log('Creating test admin');
          admin_user = new db_context.User({
            email: 'admin@h2ash.com',
            password: '123',
            admin: true,
            validated: true,
            registration_token: "",
            token: ""
          });
          return admin_user.save(function(err, saved) {
            console.log('Admin user saved');
            delete req.auth_user;
            return reply_with(req, res, errors.OK);
          });
        });
      });
    });
  });

  app.post('/end_testing_session', function(req, res) {
    return h2ash_auth.conn.close(function() {
      return h2ash_auth = db_utils.open_db("mongodb://localhost/h2ash", {
        'User': UserSchema
      }, function(db_context) {
        console.log('Database opened...');
        test_mode = false;
        delete req.auth_user;
        return reply_with(req, res, errors.OK);
      });
    });
  });

  app.post('/login', function(req, res) {
    return h2ash_auth.User.findOne({
      email: req.body.email
    }).exec(function(err, user) {
      if ((!err) && (user != null)) {
        if (!user.validated) {
          reply_with(req, res, errors.USER_NOT_VALIDATED);
          return;
        }
        if (user.check_password(req.body.password)) {
          return user.generate_token(function() {
            return user.save(function(err, saved) {
              req.auth_user = saved;
              console.log('Logged in OK');
              return reply_with(req, res, errors.OK);
            });
          });
        } else {
          return reply_with(req, res, errors.INVALID_CREDENTIALS);
        }
      } else {
        return reply_with(req, res, errors.INVALID_CREDENTIALS);
      }
    });
  });

  app.post('/logout', auth, function(req, res) {
    req.auth_user.token = "";
    return req.auth_user.save(function(err, saved) {
      delete req.auth_user;
      return reply_with(req, res, errors.OK);
    });
  });

  app.post('/overview', auth, function(req, res) {
    return reply_with(req, res, errors.OK, {
      action_points: 10
    });
  });

  app.post('/register', function(req, res) {
    return h2ash_auth.User.findOne({
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
        new_user = new h2ash_auth.User({
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

  app.get('/validate/:registration_token', function(req, res) {
    return h2ash_auth.User.findOne({
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

  require('./routes/corporation_routes')(app, auth);

  app.post('/status', function(req, res) {
    return reply_with(req, res, errors.OK, {
      status: 'OK'
    });
  });

  app.get('/get_stars', function(req, res) {
    var starDB;
    starDB = mongoose.createConnection('mongodb://localhost/authors');
    return h2ash_stars.Star.find().select('name wavelength position.cc.x position.cc.y position.cc.z').exec(function(err, loaded) {
      return reply_with(req, res, errors.OK, {
        err: err,
        status: 'OK',
        stars: loaded
      });
    });
  });

  /*
  # REST  
  #
  app.get '/projects', auth, (req,res) ->
    console.log req.session.user.projects
    res.json req.session.user.projects
  
  app.get '/categories', (req,res) ->
    ret_val = [{key:'option_1',value:'option_1_value'},{key:'option_2',value:'option_2_value'}]
    res.json(ret_val);
  
  app.get '/sub_categories/:category', (req,res) ->
    console.log req.params.category
    if req.params.category == 'option_1'
      ret_val = [{key:'option_1',value:'option_1_value_1'},{key:'option_2',value:'option_1_value_2'}]
    if req.params.category == 'option_2'
      ret_val = [{key:'option_1',value:'option_2_value_1'},{key:'option_2',value:'option_2_value_2'}]
    res.json(ret_val);
  
  
  
  app.post '/models', (req,res) ->
    new_map = mapper.create mapper_maps.map_map,req.body
    store.save local_store,js_store,mapper_maps.map_map,new_map,(saved_map)->
      res.json(saved_map)   
  
  app.get '/models', (req,res) ->
    store.load_all local_store,js_store,mapper_maps.map_map,(loaded_maps) ->
      ##console.log loaded_maps
      res.json(loaded_maps)
  
  app.delete '/models', (req,res) ->
    console.log req.query.id
    res.json({})
  */


}).call(this);
