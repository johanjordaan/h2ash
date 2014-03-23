define ['THREE','underscore'],(THREE,_) ->

  renderers = {}

  render = () ->  
    for renderer_key in _.keys(renderers)
      renderer = renderers[renderer_key]
      renderer.update()
      
      renderer.renderer.clear()
      renderer.renderer.render renderer.scene,renderer.camera
      
      p = new THREE.Projector()
      vector = new THREE.Vector3( 3000, -3000, 3000 )
      v = p.projectVector(vector,renderer.camera)
      renderer.sceneOrtho.children[0].position.x = 160*.6*v.x
      renderer.sceneOrtho.children[0].position.y = 120*.6*v.y
      #renderer.sceneOrtho.children[0].position.x = 0
      #renderer.sceneOrtho.children[0].position.y = 0

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




