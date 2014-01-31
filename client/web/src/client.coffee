require.config
  paths : 
      'jquery'   : '../bower_components/jquery/jquery.min'
      'bootstrap'  : '../bower_components/bootstrap/dist/js/bootstrap.min'
      'angular'  : '../bower_components/angular/angular'
      'angular-route'  : '../bower_components/angular-route/angular-route'
      'domReady' : '../bower_components/requirejs-domready/domReady',
      'underscore' : '../bower_components/underscore/underscore'
      'trig' : '../js/utils/trig'

  shim :  
    'bootstrap' :
      exports : 'bootstrap'
      deps : ['jquery']
    'angular' : 
      exports : 'angular'
    'angular-route' : 
      deps : ['angular']
    'underscore' :
      exports : '_'
    'trig' :
      exports : 'trig' 


define ['jquery','bootstrap','underscore','require','angular','angular-route','trig'
        ,'./ng-directives/ng-draggable','./ng-directives/ng-window','./ng-directives/ng-workspace' ]
      , ($,bootstrap,_,require,angular,angular_route,trig,draggable,window,workspace) ->
        
  angular.module('app',['ngRoute'])
    .config ($routeProvider) ->
      $routeProvider
      .when '/',
        controller : 'LoginController'
        templateUrl : 'partials/client/login.html'
      .when '/pre_registration',
        controller : 'PreRegistrationController'
        templateUrl : 'partials/client/pre_registration.html'
      .when '/pre_registration/validated',
        controller : 'DefaultController'
        templateUrl : 'partials/client/pre_registration_validated.html'
      .otherwise
        redirectTo : '/'
    .factory 'backend',($http) ->
      register : (data) ->
        $http
        .post('/api/pre_registration/register',data)
        .then (result) ->
          return result.data   
    .directive('draggable',draggable) 
    .directive('window',window)
    .directive('workspace',workspace)
    .controller 'about_controller',($scope)->
      #alert 'loading about controller'
      $scope.xxx = 'Here'
      $scope.say_it = (what) ->
        alert 'I was told to say -> '+what
    .controller 'DefaultController',($scope,$location) ->
      console.log 'x'
    .controller 'LoginController',($scope,$location) ->  
      $scope.pre_register = () ->       
        $location.path '/pre_registration'
    .controller 'PreRegistrationController',($scope,$location,$timeout,backend) ->
      $scope.finished = false
      $scope.submit_pre_registration = () ->
        $scope.$$childHead.add_error 'Invalid Password'
        $scope.error = true
        $scope.error_message = "Invalid password"

        #backend.register
        #  email : 'djjordaan@gmail.com'
        #  motivation : 'bacause'
        #.then (data) ->
        #  $scope.finished = true


  require ['domReady!'], (document) ->
    angular.bootstrap document,['app']
    #$('body').css('background-image', "url('http://www.h2ash.com/wp-content/uploads/2014/01/ClientBackground.jpg')")

