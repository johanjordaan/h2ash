define ['underscore','THREE','OrbitControls','movement'],(_,THREE,OrbitControls,movement) ->
  
  class GameIcon
    constructor : (@object) ->


  class GameObject
    constructor : (@name,@object,icon,@update_fn) ->
      if icon?
        @icon = new GameIcon(icon)  
      
      direction = new THREE.Vector3(0,0,-1)  
      max_speed = 100 # 1 m per second
      max_angular_speed = Math.PI/4  #180 deg per second
      now = Date.now()
      @movement = new movement.Movable(@object.position,direction,max_speed,max_angular_speed,now)
      @movement.set_speed(100)
      @movement.set_angular_speed(Math.PI/4)

    update : (date) ->


    update : () ->
      @movement.update(Date.now())
      #@object.position.copy(@movement.position)
      #if @movement.target_position? 
      #  @object.lookAt @movement.target_position.clone().negate()

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
      x = e.target.event.layerX - (@width / 2)
      y = e.target.event.layerY - (@height / 2)
      # tan(fov/2) = width/2 / depth
      z =  (@width / 2) / Math.tan(@visual.camera.fov / 180 * Math.PI) 
      v = new THREE.Vector3(x, -y , -z)
      direction = v.clone().normalize().applyQuaternion(@visual.camera.quaternion)
      @active_object.movement.set_target_position(direction.multiplyScalar(1000))

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
          
          if v.z < 1
            object.icon.object.visible = true
            object.icon.object.position.set( (@width/2)*v.x, (@height/2)*v.y, -1 )
          else
            object.icon.object.visible = false

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