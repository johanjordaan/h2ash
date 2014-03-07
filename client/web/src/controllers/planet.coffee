define ['../services/renderers','underscore','../utils/hmap','../utils/cmap'], (renderers,_,hmap,cmap) ->

  gen = (width,height) ->
    scene = new THREE.Scene()

    camera = new THREE.PerspectiveCamera(45, width / height, 0.01, 1000)
    camera.position.z = 1.5

    scene.add new THREE.AmbientLight(0x333333)

    light = new THREE.DirectionalLight(0xffffff, 1);
    light.position.set(5,3,5)
    scene.add(light)

    hdata = hmap(512,256,40)

    size = 512*256
    
    bumpmap_data = new Uint8Array(4*size)
    for i in _.range(size)
      c = (hdata.data[i]+1)/2
      bumpmap_data[0+i*4] = (c*0xff)&0xFF
      bumpmap_data[1+i*4] = (c*0xff)&0xFF
      bumpmap_data[2+i*4] = (c*0xff)&0xFF
      bumpmap_data[3+i*4] = 0xff

    bumpmap = new THREE.DataTexture(bumpmap_data,512,256) 
    bumpmap.needsUpdate = true

    cdata = cmap(hdata)
    texture_data = new Uint8Array(4*size)
    for i in _.range(size*4)
      texture_data[i] = cdata.data[i]
    texture = new THREE.DataTexture(texture_data,512,256) 
    texture.needsUpdate = true



    #texture = THREE.ImageUtils.generateDataTexture(512,256,new THREE.Color(0x00ff00))
    material = new THREE.MeshPhongMaterial
        map : texture
        #map: THREE.ImageUtils.loadTexture('images/2_no_clouds_4k.jpg')
        #bumpMap: THREE.ImageUtils.loadTexture('images/elev_bump_4k.jpg')
        bumpMap : bumpmap
        bumpScale:   0.1
        #specularMap: THREE.ImageUtils.loadTexture('images/water_4k.png')
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

    gen_data = gen($scope.width,$scope.height)
    
    renderer = renderers.create_renderer "planet",$scope.width,$scope.height,gen_data.scene,gen_data.camera,() ->
      gen_data.planet.rotation.y += $scope.speed
      #clouds.rotation.y += $scope.speed*1.5
        
    $scope.generate = () ->
      gen_data = gen($scope.width,$scope.height)
      renderer = renderers.create_renderer "planet",$scope.width,$scope.height,gen_data.scene,gen_data.camera,() ->
        gen_data.planet.rotation.y += $scope.speed

    $scope.add_renderer_to = (element) ->
      element.append renderer.renderer.domElement