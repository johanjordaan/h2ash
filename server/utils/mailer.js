// Generated by CoffeeScript 1.6.3
(function() {
  var nodemailer, send_mail, smtpTransport, _;

  _ = require('underscore');

  nodemailer = require('nodemailer');

  smtpTransport = nodemailer.createTransport('Zoho', {
    auth: {
      user: 'admin@h2ash.com',
      pass: 'GingGangGong?'
    }
  });

  send_mail = function(to, template, data, cb) {
    var mailOptions;
    mailOptions = {
      from: "h2ash <admin@h2ash.com>",
      to: "djjordaan@gmail.com",
      subject: _.template(template.subject, data),
      text: _.template(template.text, data),
      html: _.template(template.html, data)
    };
    return smtpTransport.sendMail(mailOptions, function(err, res) {
      cb(err);
      return smtpTransport.close();
    });
  };

  module.exports = {
    send_mail: send_mail
  };

}).call(this);