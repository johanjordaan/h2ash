define ['underscore','THREE','OrbitControls'],(_,THREE,OrbitControls) ->
  
  class GameObject
    constructor : (@name,@object,@icon,@update_fn) ->
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

      @controls.addEventListener 'mousedown',(e) ->
        e.target.enabled = true
        if e.target.event.layerX < 50 && e.target.event.layerX < 50
          e.target.enabled = false
          #alert e.type+"  "+e.target.event.layerX

      @controls.addEventListener 'mouseup',(e) ->
        e.target.enabled = true

    attach_to_element : (element) ->
      element.append @renderer.domElement    

    set_camera_focus : (go) ->
      if @focus?
        @focus.remove(@visual.camera)
      @focus = go
      @focus.object.add(@visual.camera)

    add : (go) ->
      @objects.push(go)
      @visual.scene.add(go.object)
      if go.icon?                         # Surely all objects need icons ?
        @overlay.scene.add(go.icon)  

    # Make a note of static and non static objects sothat we only update objects that has moved
    #
    update_overlay : () ->
      camera_vector = new THREE.Vector3( 0, 0, -1 )
      camera_vector.applyQuaternion( @visual.camera.quaternion )
      cp = @visual.camera.position.clone().applyMatrix4( @visual.camera.matrixWorld )

      for object in @objects 
        if object.icon?
          ov =  object.object.position.clone().sub(cp.clone()).normalize()   
          angle = camera_vector.angleTo(ov)
          if angle <1.0   # 30 degrees
            object.icon.visible = true
            zzz = object.object.position.clone()
            v = @projector.projectVector(zzz,@visual.camera)
            object.icon.position.x = (@width/2)*v.x
            object.icon.position.y = (@height/2)*v.y
            object.icon.position.z = -20
          else
            object.icon.visible = false  


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