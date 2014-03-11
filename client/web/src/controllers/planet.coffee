define ['../services/renderers','underscore','../utils/hmap','../utils/cmap'], (renderers,_,hmap,cmap) ->

  gen = (width,height,index,feature_size) ->
    scene = new THREE.Scene()

    camera = new THREE.PerspectiveCamera(45, width / height, 0.01, 1000)
    camera.position.z = 1.5

    scene.add new THREE.AmbientLight(0x333333)

    light = new THREE.DirectionalLight(0xffffff, 1);
    light.position.set(5,3,5)
    scene.add(light)


    map_width = 512
    map_height = 256
    bump_scale = 0.1
    

    hdata = hmap(map_width,map_height,feature_size)

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

    earth = new THREE.Mesh(new THREE.SphereGeometry(0.5, 24, 24),material)

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
    $scope.idx = 1
    $scope.feature_size = 32

    gen_data = gen($scope.width,$scope.height,$scope.idx,$scope.feature_size)
    
    renderer = renderers.create_renderer "planet",$scope.width,$scope.height,gen_data.scene,gen_data.camera,() ->
      gen_data.planet.rotation.y += $scope.speed
      #clouds.rotation.y += $scope.speed*1.5
        
    $scope.generate = () ->
      gen_data = gen($scope.width,$scope.height,$scope.idx,$scope.feature_size)
      renderer = renderers.create_renderer "planet",$scope.width,$scope.height,gen_data.scene,gen_data.camera,() ->
        gen_data.planet.rotation.y += $scope.speed

    $scope.add_renderer_to = (element) ->
      element.append renderer.renderer.domElement