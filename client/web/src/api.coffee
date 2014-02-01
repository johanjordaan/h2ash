define [],() ->
  return ($http,auth) ->
    pre_register : (scope,data,cb) ->
      scope.error = false
      scope.error_message = ''

      $http
      .post('/api/pre_registration/register',data)
      .error (data, status, headers, config) ->
        scope.error = true
        scope.error_message = status
        cb false
      .success (data, status, headers, config) ->
        if data.error_code != 0
          scope.error = true
          scope.error_message = data.error_message
          cb false
        else
          cb true


    # ----------------------    
    # data : dictionary of post data
    # cb   : (error_code,error_message,authenticated)
    login : (scope,data,cb) ->
      scope.error = false
      scope.error_message = ''

      $http
      .post('/api/authentication/login',data)
      .error (data, status, headers, config) ->
        auth.authenticated = false
        auth.token = ''
        scope.error = true
        scope.error_message = status
        cb false
      .success (data, status, headers, config) ->
        auth.authenticated = data.error_code == 0   
        if auth.authenticated
          auth.token = data.auth_token
        else 
          auth.token = ''
          scope.error = true
          scope.error_message = data.error_message
        cb auth.authenticated  