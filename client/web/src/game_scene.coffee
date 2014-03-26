define ['underscore','THREE'],(_,THREE) ->
  
  class GameObject
    constructor : (@object,@icon) ->
      @v = new THREE.Vector3()
      @last_update = ""
      @target = null
      @vector_to_target = new THREE.Vector3()

    set_target : (target) ->
      call_backend set_target,() ->
        @target = target

    set_velocity : (velocity) ->
      call_backend set_velocity,() ->
        @velocity = velocity

    update : () ->
      

    synch : (position,velocity) ->

  class GameScene
    constructor : (@width,@height) ->
      @renderer = new THREE.WebGLRenderer()
      @renderer.setSize(width,height) 
      @renderer.setClearColor( 0x000000, 1) 
      @renderer.autoClear = false

      @projector = new THREE.Projector()
      @visual = 
        scene : new THREE.Scene()
        camera : new THREE.PerspectiveCamera(60, @width / @height, 0.01, 100000) 
      @overlay = 
        scene : new THREE.Scene()
        camera :  new THREE.OrthographicCamera( - @width / 2, @width / 2, @height / 2, - @height / 2, 0.01, 100000 )
      @objects = []
      @focus = null


      @visual.camera.position.z = 130

    attach_to_element : (element) ->
      element.append @renderer.domElement    

    set_camera_focus : (object) ->
      if @focus?
        @focus.remove(@visual.camera)
      @focus = object
      @focus.add(@visual.camera)

    add : (object) ->
      @objects.push(object)
      @visual.scene.add(object.object)
      if object.icon?
        @overlay.scene.add(object.icon)  

    # Make a note of static and non static objects sothat we only update objects that has moved
    #
    update_overlay : () ->
      for object in @objects 
        if object.icon?
          debugger
          v = @projector.projectVector(object.object.position.clone(),@visual.camera)
          if v.z > 0
            object.icon.position.x = (@width/2)*v.x
            object.icon.position.y = (@height/2)*v.y
            object.icon.position.z = -20

    render : () ->
      @renderer.clear()
      @renderer.render @visual.scene, @visual.camera

      @update_overlay()
        
      @renderer.clearDepth()
      @renderer.render @overlay.scene, @overlay.camera

    animate : () ->
      requestAnimationFrame @.animate.bind(@)
      @render() 


  ret_val = 
    GameScene : GameScene
    GameObject : GameObject