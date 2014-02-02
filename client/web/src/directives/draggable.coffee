define ['angular'],(angular) ->
  return ($document) ->
    return (scope,element,attr) ->
      xOffset = yOffset = 0
  
      angular.element(element.context.parentNode.parentNode.parentNode.parentNode).css
        position: 'absolute'
        cursor: 'pointer'

      element.on 'mousedown', (event) ->
        event.preventDefault()
        xOffset = event.offsetX
        yOffset = event.offsetY
        $document.on 'mousemove', mousemove
        $document.on 'mouseup', mouseup
 
      mousemove = (event)->
        x = event.pageX - xOffset
        y = event.pageY - yOffset
        angular.element(element.context.parentNode.parentNode.parentNode.parentNode).css
          top  : y + 'px',
          left :  x + 'px'
 
      mouseup = () ->
        $document.unbind 'mousemove', mousemove
        $document.unbind 'mouseup', mouseup


