define [],() ->

  clear_error = (scope) ->
    scope.error = false
    scope.error_message = ''

  set_error = (scope,message) ->  
    scope.error = true
    scope.error_message = message

  return ($http,auth) ->
    # ----------------------    
    # data : dictionary of post data
    # cb   : (success:boolean)
    pre_register : (scope,data,cb) ->
      clear_error scope

      $http
      .post('/api/pre_registration/register',data)
      .error (data, status, headers, config) ->
        set_error scope,status
        cb false
      .success (data, status, headers, config) ->
        if data.error_code != 0
          set_error scope,data.error_message
          cb false
        else
          cb true

    # ----------------------    
    # data : dictionary of post data
    # cb   : (authenticated:boolean)
    login : (scope,data,cb) ->
      clear_error scope

      $http
      .post('/api/authentication/login',data)
      .error (data, status, headers, config) ->
        auth.authenticated = false
        auth.token = ''
        set_error scope,status
        cb false
      .success (data, status, headers, config) ->
        auth.authenticated = data.error_code == 0   
        if auth.authenticated
          auth.token = data.auth_token
        else 
          auth.token = ''
          set_error scope,data.error_message
          
        cb auth.authenticated  