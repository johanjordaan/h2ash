require.config
  paths : 
      'jquery'   : '../bower_components/jquery/jquery.min'
      'bootstrap'  : '../bower_components/bootstrap/dist/js/bootstrap.min'
      'angular'  : '../bower_components/angular/angular'
      'angular-route'  : '../bower_components/angular-route/angular-route'
      'domReady' : '../bower_components/requirejs-domready/domReady',
      'underscore' : '../bower_components/underscore/underscore'
      'trig' : '../js/utils/trig'
      'THREE' : '../bower_components/three.js/three.min'
      'movement' : '../js/utils/movement'

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
    'THREE' :
      exports : 'THREE' 

define ['jquery','bootstrap','underscore','require','angular','angular-route','trig'
        ,'./directives/draggable','./directives/window','./directives/workspace'
        ,'./directives/widget','THREE','./services/api','./services/renderers'
        ,'./controllers/galaxy','./controllers/planet']
      , ($,bootstrap,_,require,angular,angular_route,trig,draggable,window,workspace
          ,widget,THREE,api,renderers,galaxy_controller,planet_controller) ->
  
  angular.module('app',['ngRoute'])
    .config ($routeProvider) ->
      $routeProvider
      .when '/',
        templateUrl : 'partials/workspaces/login_workspace.html'
      .when '/pre_registration',
        templateUrl : 'partials/workspaces/pre_registration_workspace.html'
      .when '/pre_registration/validated',
        templateUrl : 'partials/workspaces/pre_registration_validated_workspace.html'
      .when '/main',
        templateUrl : 'partials/workspaces/main_workspace.html'
      .otherwise
        redirectTo : '/'
    .value 'auth',
      authenticated : false
      token : ''
    .service('backend',api)
    .service('renderers',renderers)
    .directive('draggable',draggable) 
    .directive('window',window)
    .directive('workspace',workspace)
    .directive('widget',widget)
    .controller 'leads_controller',($scope,$timeout,backend)->
      $scope.leads = []
      #for i in _.range(20)
      #  $scope.leads.push
      #    email : 'email'+i
      #    motivation : 'halloooeee '+i
      #    validated : true
      backend.get_leads $scope,{}
      ,(leads) ->
        $scope.leads = leads 
    .controller('galaxy_controller',galaxy_controller)
    .controller('planet_controller',planet_controller)
    .controller 'about_controller',($scope)->
      #alert 'loading about controller'
      $scope.xxx = 'Here'
      $scope.say_it = (what) ->
        $scope.xxx = what
        alert 'I was told to say -> '+what
    .controller 'login_controller',($scope,$location,backend,auth) ->  
      $scope.login = () ->
        backend.login $scope,
          email : $scope.$$childHead.email
          password : $scope.$$childHead.password
        ,(authenticated) ->
          if authenticated 
            $location.path '/main'

      $scope.pre_register = () ->       
        $location.path '/pre_registration'
    .controller 'pre_registration_controller',($scope,$location,$timeout,backend) ->
      $scope.finished = false
      $scope.register = () ->
        backend.pre_register $scope,
          email : $scope.$$childHead.email 
          motivation : $scope.$$childHead.motivation 
        ,(success) ->
          if success
            $scope.finished = true
    .run (renderers) ->
      renderers.run()

  require ['domReady!'], (document) ->
    angular.bootstrap document,['app']
    $('body').css('background-image', "url('/images/ClientBackground.jpg')")

