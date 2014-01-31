define [],() ->
  return () ->
    require     : '^workspace'
    restrict    : 'A'
    transclude  : true
    link : (scope,element,attrs,parent_controller) ->
      parent_controller.add_window scope
      scope.title = attrs.title
      element.css
        position  : 'absolute'
        left      : attrs.left
        top       : attrs.top 
        width     : attrs.width
      scope.toggle = () ->
        scope.closed = !scope.closed

    ,templateUrl: 'partials/window.html'