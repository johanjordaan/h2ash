define [],() ->
  return () ->
    require     : '^workspace'
    restrict    : 'A'
    transclude  : true
    scope       : 
      title   : '@'
      closed  : '@'
      width   : '@'
      left    : '@'
      top     : '@'
      add_error : '&'
    link : (scope,element,attrs,parent_controller) ->
      parent_controller.add_window scope
      element.css
        position  : 'absolute'
        left      : scope.left
        top       : scope.top 
        width     : scope.width
      scope.toggle = () ->
        scope.closed = !scope.closed


    ,templateUrl: 'partials/window.html'