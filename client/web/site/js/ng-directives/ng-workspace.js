// Generated by CoffeeScript 1.6.3
(function() {
  define(['jquery', 'angular'], function($, angular) {
    return function($compile, $http) {
      return {
        restrict: 'E',
        transclude: true,
        scope: {},
        controller: function($scope, $http, $compile) {
          $scope.windows = [];
          this.add_window = function(window) {
            return $scope.windows.push(window);
          };
        },
        link: function(scope, element, attrs) {
          scope.add_window = function(url) {
            $http.get(url).then(function(result) {
              return element.append($compile(result.data)(scope));
            });
          };
          return scope.add_error = function(message) {
            return scope.error_message = message;
          };
        },
        templateUrl: 'partials/workspace.html'
      };
    };
  });

}).call(this);
