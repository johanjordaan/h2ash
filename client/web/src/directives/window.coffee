define ['jquery','angular'],($,angular) ->
  return () ->
    require     : '^workspace'
    restrict    : 'A'
    transclude  : true
    link : (scope,element,attrs,parent_controller) ->
      
      scope.dismiss_error = () ->
        scope.error = false
        scope_error_message = ''

      parent_controller.add_window scope
      scope.title = attrs.title 
      scope.closed = attrs.closed

      r = $('div[renderer]')

      if scope.add_renderer_to?
        #if attrs.canvas?
          #element.find('.panel-body').append("<div id='#{attrs.canvas}'></div>")
        scope.add_renderer_to angular.element(r[0])
      
      angular.element(element[0].parentNode).css
        position  : 'absolute'
        left      : attrs.left
        top       : attrs.top 
        width     : attrs.width

      scope.toggle = () ->
        scope.closed = !scope.closed

    ,templateUrl: 'partials/window.html'