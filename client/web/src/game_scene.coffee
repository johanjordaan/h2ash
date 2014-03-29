define ['underscore','THREE','OrbitControls'],(_,THREE,OrbitControls) ->
  
  class GameIcon
    constructor : (@object) ->


  class GameObject
    constructor : (@name,@object,icon,@update_fn) ->
      if icon?
        @icon = new GameIcon(icon)  
      
      @v = new THREE.Vector3()
      @last_update = ""
      @target = null
      @vector_to_target = new THREE.Vector3()

    set_direction : (@direction) ->  

    set_target : (target) ->
      call_backend set_target,() ->
        @target = target

    set_velocity : (velocity) ->
      call_backend set_velocity,() ->
        @velocity = velocity

    update : () ->
      if @direction?
        debugger
        @object.position.add(@direction.clone().multiplyScalar(1))

      if @update_fn?
        @update_fn()
      
    orbit_target_at : (target,distance) ->


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

      @controls = new THREE.OrbitControls( @visual.camera, @renderer.domElement );
      @controls.addEventListener('change', @render.bind(@) );

      #@controls.addEventListener 'mousedown',(e) ->
      #  e.target.enabled = true
      #  if e.target.event.layerX < 50 && e.target.event.layerX < 50
      #    e.target.enabled = false
      #    #alert e.type+"  "+e.target.event.layerX

      @controls.addEventListener 'mouseup',(e) ->
        e.target.enabled = true

      axisHelper = new THREE.AxisHelper( 500 );
      @visual.scene.add( axisHelper );

      @controls.addEventListener 'mousedblclick', @dbl_click.bind(@)

    dbl_click : (e) ->
      x = (e.target.event.layerX/@width) * 2 - 1
      y = -((e.target.event.layerY/@height) * 2 - 1)
      v = new THREE.Vector3(x, y , 0)
      direction = @projector.unprojectVector(v.clone(),@visual.camera.clone()).negate().normalize()
      @active_object.set_direction(direction)


    attach_to_element : (element) ->
      element.append @renderer.domElement    

    set_camera_focus : (go) ->
      if @focus?
        @focus.remove(@visual.camera)
      @focus = go
      @focus.object.add(@visual.camera)

    set_active_object : (@active_object) ->

    add : (go,parent_go) ->
      @objects.push(go)
      if parent_go?
        parent_go.object.add(go.object)
      else  
        @visual.scene.add(go.object)
      
      if go.icon?                         # Surely all objects need icons ?
        @overlay.scene.add(go.icon.object)  

    # Make a note of static and non static objects sothat we only update objects that has moved
    #
    update_overlay : () ->
      camera_direction = new THREE.Vector3( 0, 0, -1 )
      camera_direction.applyMatrix4( @visual.camera.matrixWorld ).normalize()
      camera_position = new THREE.Vector3( 0, 0, 0 )
      camera_position.applyMatrix4( @visual.camera.matrixWorld )

      for object in @objects
        if object.icon?
          
          object_position = new THREE.Vector3( 0, 0, 0 )
          object_position.applyMatrix4(object.object.matrixWorld)
          camera_object_vector = object_position.clone().sub(camera_position)
          camera_object_direction = camera_object_vector.normalize()
          
          v = @projector.projectVector(object_position.clone(),@visual.camera)
          object.icon.object.position.set( (@width/2)*v.x, (@height/2)*v.y, -20 )

    render : () ->
      @renderer.clear()
      @renderer.render @visual.scene, @visual.camera

      @update_overlay()
        
      @renderer.clearDepth()
      @renderer.render @overlay.scene, @overlay.camera

    animate : () ->
      requestAnimationFrame @.animate.bind(@)
      for object in @objects
        object.update()
      @render() 


  ret_val = 
    GameScene : GameScene
    GameObject : GameObject
    GameIcon : GameIcon