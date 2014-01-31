// Generated by CoffeeScript 1.6.3
(function() {
  require.config({
    paths: {
      'jquery': '../bower_components/jquery/jquery.min',
      'bootstrap': '../bower_components/bootstrap/dist/js/bootstrap.min',
      'angular': '../bower_components/angular/angular',
      'angular-route': '../bower_components/angular-route/angular-route',
      'domReady': '../bower_components/requirejs-domready/domReady',
      'underscore': '../bower_components/underscore/underscore',
      'trig': '../js/utils/trig'
    },
    shim: {
      'bootstrap': {
        exports: 'bootstrap',
        deps: ['jquery']
      },
      'angular': {
        exports: 'angular'
      },
      'angular-route': {
        deps: ['angular']
      },
      'underscore': {
        exports: '_'
      },
      'trig': {
        exports: 'trig'
      }
    }
  });

  define(['jquery', 'bootstrap', 'underscore', 'require', 'angular', 'angular-route', 'trig', './ng-directives/ng-draggable', './ng-directives/ng-window', './ng-directives/ng-workspace'], function($, bootstrap, _, require, angular, angular_route, trig, draggable, window, workspace) {
    angular.module('app', ['ngRoute']).config(function($routeProvider) {
      return $routeProvider.when('/', {
        controller: 'LoginController',
        templateUrl: 'partials/client/login.html'
      }).when('/pre_registration', {
        controller: 'PreRegistrationController',
        templateUrl: 'partials/client/pre_registration.html'
      }).when('/pre_registration/validated', {
        controller: 'DefaultController',
        templateUrl: 'partials/client/pre_registration_validated.html'
      }).otherwise({
        redirectTo: '/'
      });
    }).factory('backend', function($http) {
      return {
        register: function(data) {
          return $http.post('/api/pre_registration/register', data).then(function(result) {
            return result.data;
          });
        }
      };
    }).directive('draggable', draggable).directive('window', window).directive('workspace', workspace).controller('about_controller', function($scope) {
      $scope.xxx = 'Here';
      return $scope.say_it = function(what) {
        return alert('I was told to say -> ' + what);
      };
    }).controller('DefaultController', function($scope, $location) {
      return console.log('x');
    }).controller('LoginController', function($scope, $location) {
      return $scope.pre_register = function() {
        return $location.path('/pre_registration');
      };
    }).controller('PreRegistrationController', function($scope, $location, $timeout, backend) {
      $scope.finished = false;
      return $scope.submit_pre_registration = function() {
        $scope.$$childHead.add_error('Invalid Password');
        $scope.error = true;
        return $scope.error_message = "Invalid password";
      };
    });
    return require(['domReady!'], function(document) {
      return angular.bootstrap(document, ['app']);
    });
  });

}).call(this);
