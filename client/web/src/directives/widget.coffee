define [],() ->
  return () ->
    require     : '^workspace'
    restrict    : 'E'
    transclude  : true
    link : (scope,element,attrs,parent_controller) ->
      parent_controller.add_window_from_url attrs.url
    ,template: '...'