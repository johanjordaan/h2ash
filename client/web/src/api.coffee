define [],() ->
  return ($http,auth) ->
    pre_register : (data) ->
      $http
      .post('/api/pre_registration/register',data)
      .error (data, status, headers, config) ->
        return data
      .success (data, status, headers, config) ->
        return data   
    login : (data,cb) ->
      $http
      .post('/api/authentication/login',data)
      .error (data, status, headers, config) ->
        auth.authenticated = false
        auth.token = ''
        cb false
      .success (data, status, headers, config) ->
        auth.authenticated = data.error_code == 0   
        if auth.authenticated
          auth.token = data.auth_token
        else 
          auth.token = ''
        cb auth.authenticated  