define ['../services/renderers','underscore','../utils/hmap','../utils/cmap','../utils/noise','OrbitControls'], (renderers,_,hmap,cmap,noise,orbit) ->

  ship_mesh = {}
  gen = (width,height,index,feature_size) ->
    scene = new THREE.Scene()

    camera = new THREE.PerspectiveCamera(60, width / height, 0.01, 100000)
    camera.position.z = 130

    scene.add new THREE.AmbientLight(0x333333)

    light = new THREE.DirectionalLight(0xffffff, 1);
    light.position.set(5,3,5)
    scene.add(light)


    map_width = 512
    map_height = 256
    bump_scale = 3
    

    hdata = hmap(map_width,map_height,feature_size)
    #hdata = noise(map_width,map_height,0,1)

    size = map_width*map_height

    cdata = cmap(hdata,index)

    texture = new THREE.DataTexture(cdata.cmap.data,map_width,map_height) 
    texture.needsUpdate = true

    spec = new THREE.DataTexture(cdata.smap.data,map_width,map_height) 
    spec.needsUpdate = true

    bumpmap = new THREE.DataTexture(cdata.bmap.data,map_width,map_height) 
    bumpmap.needsUpdate = true

    material = new THREE.MeshPhongMaterial
        map : texture
        bumpMap : bumpmap
        bumpScale:   bump_scale
        specularMap: spec
        specular: new THREE.Color('grey')

    earth = new THREE.Mesh(new THREE.SphereGeometry(100, 24, 24),material)


    ship_geometry = new THREE.CylinderGeometry( 0, 10, 30, 4, 1 )
    ship_material =  new THREE.MeshLambertMaterial( { color:0xffffff, shading: THREE.FlatShading } )
    ship_mesh = new THREE.Mesh( ship_geometry, ship_material )
    ship_mesh.position.x = 140
    ship_mesh.position.y = 140
    scene.add(ship_mesh)
    ship_mesh.add(camera)

    #clouds = new THREE.Mesh new THREE.SphereGeometry(0.505, 24, 24),
    #  new THREE.MeshPhongMaterial
    #    map: THREE.ImageUtils.loadTexture('images/fair_clouds_4k.png'),
    #    transparent: true

    scene.add(earth)
    #scene.add(clouds)
    ret_val =
      scene : scene
      camera : camera
      planet : earth


  return ($scope,$timeout,renderers)->
    $scope.speed = 0.01
    $scope.width = 320
    $scope.height = 240
    $scope.idx = 0
    $scope.feature_size = 32

    gen_data = gen($scope.width,$scope.height,$scope.idx,$scope.feature_size)
    
    renderer = renderers.create_renderer "planet",$scope.width,$scope.height,gen_data.scene,gen_data.camera,() ->
      gen_data.planet.rotation.y += $scope.speed
      ship_mesh.position.y += 1
      #clouds.rotation.y += $scope.speed*1.5
        
    $scope.generate = () ->
      gen_data = gen($scope.width,$scope.height,$scope.idx,$scope.feature_size)
      renderer = renderers.create_renderer "planet",$scope.width,$scope.height,gen_data.scene,gen_data.camera,() ->
        gen_data.planet.rotation.y += $scope.speed
        ship_mesh.position.y += 1

    $scope.add_renderer_to = (element) ->
      controls = new THREE.OrbitControls( renderer.camera, renderer.renderer.domElement );
      controls.addEventListener( 'change', renderer.update );

      element.append renderer.renderer.domElement