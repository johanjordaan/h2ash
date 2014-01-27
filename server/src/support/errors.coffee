error_list = 
  OK :
    error_code : 0
    error_message : ''
  
  INVALID_CREDENTIALS :
    error_code : 1
    error_message : 'Invalid credentials'

  NOT_AUTHED :
    error_code : 2
    error_message : 'Not authed'

  DUPLICATE_USER :
    error_code : 3
    error_message : 'This user alread exists'

  USER_NOT_VALIDATED :
    error_code : 4
    error_message : 'This user has not been validated'

  LEAD_EXISTS : 
    error_code : 5
    error_message : 'This email address has already been registered and validated.'

  LEAD_NOT_VALIDATED :
    error_code : 6
    error_message : 'This email address has already been registered. A new validation token has been sent.'  

module.exports = error_list