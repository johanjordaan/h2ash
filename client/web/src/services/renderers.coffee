define ['THREE','underscore'],(THREE,_) ->

  renderers = {}

  render = () ->  
    for renderer_key in _.keys(renderers)
      renderer = renderers[renderer_key]
      renderer.update()
      renderer.renderer.render renderer.scene,renderer.camera

  animate = () ->
    requestAnimationFrame animate
    render() 

  return () ->
    create_renderer : (name,width,height,scene,camera,update) ->
      renderer = {}
      if name in _.keys(renderers)
        renderer = renderers[name].renderer
      else  
        renderer = new THREE.WebGLRenderer()
      
      renderer.setSize(width,height) 
      renderer.setClearColor( 0x000000, 1) 

      renderers[name] =
        active : true
        renderer : renderer
        camera : camera
        scene : scene
        update : update

      return renderers[name]

    get_renderer : (name) ->
      return renderers[name].renderer

    run : () ->
      animate()




