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


define ['jquery','bootstrap','underscore','require','angular','angular-route','trig']
      , ($,bootstrap,_,require,angular,angular_route,trig) ->
        
  angular.module('app',['ngRoute'])
    .config ($routeProvider) ->
      $routeProvider
      .when '/',
        controller : 'LoginController'
        templateUrl : 'partials/client/login.html'
      .when '/pre_registration',
        controller : 'PreRegistrationController'
        templateUrl : 'partials/client/pre_registration.html'
      .otherwise
        redirectTo : '/'
    .controller 'LoginController',($scope,$location) ->  
      $scope.pre_register = () ->       
        $location.path '/pre_registration'
    .controller 'PreRegistrationController',($scope,$location,$timeout) ->
      $scope.finished = false
      $scope.submit_pre_registration = () ->
        
        $scope.error = true
        $scope.error_message = "Invalid password"

        $timeout () ->
          alert 'Hallo'
          $scope.finished = true
          $scope.error_message = 'xxx'
        ,1000
        #$location.path '/'  


  require ['domReady!'], (document) ->
    angular.bootstrap document,['app']
    $('body').css('background-image', "url('http://www.h2ash.com/wp-content/uploads/2014/01/ClientBackground.jpg')");

