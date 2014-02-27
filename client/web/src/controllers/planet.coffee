define ['../services/renderers','underscore','../utils/hmap'], (renderers,_,hmap) ->

  width = 320
  height = 240

  scene = new THREE.Scene()

  camera = new THREE.PerspectiveCamera(45, width / height, 0.01, 1000)
  camera.position.z = 1.5

  scene.add new THREE.AmbientLight(0x333333)

  light = new THREE.DirectionalLight(0xffffff, 1);
  light.position.set(5,3,5)
  scene.add(light)

  hdata = hmap(512,256,128)

  size = 512*256
  texture_data = new Uint8Array(4*size)
  for i in _.range(size)
    texture_data[0+i*4] = hdata.data[i]*0xff
    texture_data[1+i*4] = hdata.data[i]*0xff
    texture_data[2+i*4] = hdata.data[i]*0xff
    texture_data[3+i*4] = 0xff
    
  texture = new THREE.DataTexture(texture_data,512,256) 
  texture.needsUpdate = true

  #texture = THREE.ImageUtils.generateDataTexture(512,256,new THREE.Color(0x00ff00))
  material = new THREE.MeshPhongMaterial
      map : texture
      #map: THREE.ImageUtils.loadTexture('images/2_no_clouds_4k.jpg')
      #bumpMap: THREE.ImageUtils.loadTexture('images/elev_bump_4k.jpg')
      bumpMap : texture
      bumpScale:   0.005
      #specularMap: THREE.ImageUtils.loadTexture('images/water_4k.png')
      specular: new THREE.Color('grey')

  earth = new THREE.Mesh(new THREE.SphereGeometry(0.5, 32, 32),material)
    

  clouds = new THREE.Mesh new THREE.SphereGeometry(0.503, 32, 32),
    new THREE.MeshPhongMaterial
      map: THREE.ImageUtils.loadTexture('images/fair_clouds_4k.png'),
      transparent: true

  scene.add(earth)
  #scene.add(clouds)
  

  return ($scope,$timeout,renderers)->
    $scope.speed = 0.001
    renderer = renderers.create_renderer "planet",width,height,scene,camera,() ->
      earth.rotation.y += $scope.speed
      clouds.rotation.y += $scope.speed*2
        
    
    $scope.add_renderer_to = (element) ->
      element.append renderer.renderer.domElement