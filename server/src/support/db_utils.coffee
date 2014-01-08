_ = require 'underscore'
mongoose = require 'mongoose'

open_db = (db_name,schemas_to_register,on_open) ->
  conn = mongoose.createConnection db_name

  db_context = 
    conn : conn

  for key in _.keys(schemas_to_register)
    db_context[key] = conn.model key,schemas_to_register[key]

  conn.on 'error', console.error.bind(console, 'connection error:')
  conn.once 'open', () -> on_open(db_context)
  return db_context

module.exports = 
  open_db : open_db