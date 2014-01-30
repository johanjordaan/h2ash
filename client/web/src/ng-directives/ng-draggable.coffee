define ['angular'],(angular) ->
  return ($document) ->
    return (scope,element,attr) ->
      startX = 0
      startY = 0
      x = 0
      y = 0
  
      angular.element(element.context.parentNode).css
        position: 'relative'
        cursor: 'pointer'

      element.on 'mousedown', (event) ->
        event.preventDefault()
        startX = event.pageX - x
        startY = event.pageY - y
        $document.on 'mousemove', mousemove
        $document.on 'mouseup', mouseup
 
      mousemove = (event)->
        y = event.pageY - startY
        x = event.pageX - startX
        angular.element(element.context.parentNode).css
          top  : y + 'px',
          left :  x + 'px'
 
      mouseup = () ->
        $document.unbind 'mousemove', mousemove
        $document.unbind 'mouseup', mouseup


