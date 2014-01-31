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
        ,'./ng-directives/ng-draggable','./ng-directives/ng-window','./ng-directives/ng-workspace'
        ,'./ng-directives/ng-widget' ]
      , ($,bootstrap,_,require,angular,angular_route,trig,draggable,window,workspace,widget) ->
        
  angular.module('app',['ngRoute'])
    .config ($routeProvider) ->
      $routeProvider
      .when '/',
        templateUrl : 'partials/workspaces/login_workspace.html'
      .when '/pre_registration',
        templateUrl : 'partials/workspaces/pre_registration_workspace.html'
      .when '/pre_registration/validated',
        templateUrl : 'partials/workspaces/pre_registration_validated_workspace.html'
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
    .directive('widget',widget)
    .controller 'about_controller',($scope)->
      #alert 'loading about controller'
      $scope.xxx = 'Here'
      $scope.say_it = (what) ->
        $scope.xxx = what
        alert 'I was told to say -> '+what
    .controller 'login_controller',($scope,$location) ->  
      $scope.pre_register = () ->       
        $location.path '/pre_registration'
    .controller 'pre_registration_controller',($scope,$location,$timeout,backend) ->
      $scope.finished = false
      $scope.register = () ->
        $scope.$$childHead.add_error 'Invalid Password'
        $scope.error = true
        $scope.error_message = "Invalid password"
        $scope.finished = true

        #backend.register
        #  email : 'djjordaan@gmail.com'
        #  motivation : 'bacause'
        #.then (data) ->
        #  $scope.finished = true


  require ['domReady!'], (document) ->
    angular.bootstrap document,['app']
    #$('body').css('background-image', "url('http://www.h2ash.com/wp-content/uploads/2014/01/ClientBackground.jpg')")

