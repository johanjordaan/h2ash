define ['THREE','underscore'],(THREE,_) ->

  renderers = {}

  render = () ->  
    for renderer_key in _.keys(renderers)
      renderer = renderers[renderer_key]
      renderer.update()
      
      renderer.renderer.clear()
      renderer.renderer.render renderer.scene,renderer.camera
      

      #p = new THREE.Projector()
      #o = p.projectScene(renderer.scene,renderer.camera)
      #debugger


      p = new THREE.Projector()
      vector = new THREE.Vector3( 3000, -3000, 3000 )
      v = p.projectVector(vector,renderer.camera)
      debugger
      renderer.sceneOrtho.children[0].position.x = 160*v.x
      renderer.sceneOrtho.children[0].position.y = 120*v.y
      renderer.sceneOrtho.children[0].position.z = 0

      #renderer.cameraOrtho.position = renderer.camera.position.clone()
      #renderer.cameraOrtho.position.add(new THREE.Vector3(120,120,0))

      #renderer.cameraOrtho.rotation = renderer.camera.rotation.clone()
      
      #renderer.cameraOrtho.lookAt()
      #renderer.sceneOrtho.matrixWorldInverse = renderer.camera.matrixWorldInverse.clone()
      #renderer.sceneOrtho.projectionMatrix =  renderer.camera.projectionMatrix.clone()
      #renderer.cameraOrtho.projectionMatrix = renderer.camera.projectionMatrix.clone()
      #renderer.cameraOrtho.matrixWorldInverse = renderer.camera.matrixWorldInverse.clone()

      
      #renderer.cameraOrtho.rotation = renderer.camera.rotation.clone()


      renderer.renderer.clearDepth()
      renderer.renderer.render renderer.sceneOrtho, renderer.cameraOrtho

  animate = () ->
    requestAnimationFrame animate
    render() 

  return () ->
    create_renderer : (name,width,height,scene,sceneOrtho,camera,cameraOrtho,update) ->
      renderer = {}
      if name in _.keys(renderers)
        renderer = renderers[name].renderer
      else  
        renderer = new THREE.WebGLRenderer()
      
      renderer.setSize(width,height) 
      renderer.setClearColor( 0x000000, 1) 

      renderer.autoClear = false

      renderers[name] =
        active : true
        renderer : renderer
        camera : camera
        cameraOrtho : cameraOrtho
        scene : scene
        sceneOrtho : sceneOrtho
        update : update

      return renderers[name]

    get_renderer : (name) ->
      return renderers[name].renderer

    run : () ->
      animate()




