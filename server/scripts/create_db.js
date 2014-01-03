// Generated by CoffeeScript 1.6.3
(function() {
  var Actor, User, admin_actor, admin_user, async, db, mongoose;

  mongoose = require('mongoose');

  async = require('async');

  User = require('../domain/user');

  Actor = require('../domain/actor');

  mongoose.connect('mongodb://localhost/h2ash');

  admin_actor = new Actor({
    name: 'q'
  });

  admin_user = new User({
    email: 'admin@h2ash.com',
    password: '123',
    actors: [admin_actor],
    admin: true,
    validated: true,
    registration_token: "",
    token: ""
  });

  db = mongoose.connection;

  db.on('error', console.error.bind(console, 'connection error:'));

  db.once('open', function() {
    return mongoose.connection.db.dropDatabase(function() {
      return async.series([
        function(cb) {
          return admin_actor.save(function(err, saved) {
            return cb(null, 1);
          });
        }, function(cb) {
          return admin_user.save(function(err, saved) {
            if (err) {
              console.log(err);
            } else {
              console.log('Admin user saved.');
            }
            return User.findOne({
              email: /admin@h2ash.com/
            }).populate('actors').exec(function(err, found) {
              if (err) {
                console.log(err);
              } else {
                console.log(found.check_password('1234'));
                console.log(found.check_password('123'));
                console.log(found.actors[0].name);
              }
              db.close();
              return cb(null, 2);
            });
          });
        }
      ]);
    });
  });

}).call(this);
