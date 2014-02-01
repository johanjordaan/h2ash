// Generated by CoffeeScript 1.6.3
(function() {
  define(['jquery', 'angular'], function($, angular) {
    return function() {
      return {
        require: '^workspace',
        restrict: 'A',
        transclude: true,
        link: function(scope, element, attrs, parent_controller) {
          scope.dismiss_error = function() {
            var scope_error_message;
            scope.error = false;
            return scope_error_message = '';
          };
          parent_controller.add_window(scope);
          scope.title = attrs.title;
          scope.closed = attrs.closed;
          element.find('.panel-body').append("<div id='" + attrs.canvas + "'></div>");
          if (scope.add_frame != null) {
            scope.add_frame();
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
