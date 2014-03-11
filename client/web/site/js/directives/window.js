// Generated by CoffeeScript 1.6.3
(function() {
  define(['jquery', 'angular'], function($, angular) {
    return function() {
      return {
        require: '^workspace',
        restrict: 'A',
        transclude: true,
        link: function(scope, element, attrs, parent_controller) {
          var r;
          scope.dismiss_error = function() {
            var scope_error_message;
            scope.error = false;
            return scope_error_message = '';
          };
          parent_controller.add_window(scope);
          scope.title = attrs.title;
          scope.closed = attrs.closed;
          r = $('div[renderer]');
          if (scope.add_renderer_to != null) {
            scope.add_renderer_to(angular.element(r[0]));
          }
          angular.element(element[0].parentNode).css({
            position: 'absolute',
            left: attrs.left,
            top: attrs.top,
            width: attrs.width
          });
          return scope.toggle = function() {
            return scope.closed = !scope.closed;
          };
        },
        templateUrl: 'partials/window.html'
      };
    };
  });

}).call(this);
