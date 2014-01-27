handle_CORS = (req,res,next) ->
  res.header 'Access-Control-Allow-Origin','*'
  res.header 'Access-Control-Allow-Methods','GET,POST,PUT,DELETE,OPTIONS'
  res.header 'Access-Control-Allow-Headers','Content-Type, Authorization, Content-Length, X-Requested-With'

  if 'OPTIONS' == req.method
    res.send 200

  next()

module.exports = handle_CORS