define ['../services/renderers','underscore','OrbitControls','../utils/planet_visualiser'], (renderers,_,orbit,planet_visualiser) ->


  objects = []
  selected_object = {}

  gen = (scene,sceneOrtho,camera,cameraOrtho,width,height,index,x_period,y_period,power,feature_size) ->

    if selected_object.remove?
      selected_object.remove(camera)
    for o in objects
      scene.remove(o) 
    objects = []
    selected_object = {}
    
    planet = planet_visualiser(index,x_period,y_period,power,feature_size)
    planet2 = planet_visualiser(index+1,x_period,y_period,power,feature_size)
    planet2.position.x = 3000
    planet2.position.y = -3000
    planet2.position.z = 3000


    ship_geometry = new THREE.CylinderGeometry( 0, 10, 30, 4, 1 )
    ship_material =  new THREE.MeshLambertMaterial( { color:0xffffff, shading: THREE.FlatShading } )
    ship = new THREE.Mesh( ship_geometry, ship_material )
    ship.position.x = 120
    ship.position.y = 120


    objects.push(planet)
    objects.push(planet2)
    objects.push(ship)

    selected_object = ship    


    scene.add(ship)
    ship.add(camera)
    scene.add(planet)
    scene.add(planet2)


    selected_object.add(camera)



    geo = new THREE.Geometry();
    geo.vertices.push(new THREE.Vector3( 0, 5, 0));
    geo.vertices.push(new THREE.Vector3(-5,-5, 0));
    geo.vertices.push(new THREE.Vector3( 5,-5, 0));
    geo.faces.push( new THREE.Face3(0, 1, 2));
    
    #geo.computeCentroids();
    #geo.computeFaceNormals();
    
    #ot_material = new THREE.LineBasicMaterial( { color: 0xAAAAAA, linewidth: 3 } )
    #ot_geometry = new THREE.CircleGeometry( 10, 64 )
    #ot_geometry.vertices.shift()
    ot_material = new THREE.MeshBasicMaterial({
            color:              0xAAAAAA,
            wireframe:          true,
            wireframeLinewidth: 3
        })

    icon = new THREE.Mesh( geo, ot_material )
    sceneOrtho.add( icon )
    icon.position.x = 0
    icon.position.y = 0


    ret_val =
      scene : scene
      sceneOrtho : sceneOrtho
      camera : camera
      cameraOrtho : cameraOrtho
      planet : planet


  return ($scope,$timeout,renderers)->
    $scope.speed = 0.001
    $scope.width = 320
    $scope.height = 240
    

    $scope.idx = 0
    $scope.x_period = 0
    $scope.y_period = 0
    $scope.power = 5
    $scope.feature_size = 32


    $scope.scene = new THREE.Scene()
    $scope.sceneOrtho = new THREE.Scene();

    $scope.camera = new THREE.PerspectiveCamera(60, $scope.width / $scope.height, 0.01, 100000)
    $scope.camera.position.z = 130
    
    $scope.cameraOrtho = new THREE.PerspectiveCamera(60, $scope.width / $scope.height, 0.01, 100000)
      #new THREE.OrthographicCamera( - $scope.width / 2, $scope.width / 2, $scope.height / 2, - $scope.height / 2, 0.01, 100000 )
    $scope.cameraOrtho.position.z = 130;
    
    $scope.scene.add new THREE.AmbientLight(0x333333)
    light = new THREE.DirectionalLight(0xffffff, 1);
    light.position.set(5,3,5)
    $scope.scene.add(light)




    gen_data = gen($scope.scene,$scope.sceneOrtho,$scope.camera,$scope.cameraOrtho,$scope.width,$scope.height,$scope.idx,$scope.x_period,$scope.x_period,$scope.power,$scope.feature_size)
    
    $scope.renderer = renderers.create_renderer "planet",$scope.width,$scope.height,$scope.scene,$scope.sceneOrtho,$scope.camera,$scope.cameraOrtho,() ->
      objects[0].rotation.y += $scope.speed*2
      objects[1].rotation.y += $scope.speed*3
    $scope.state = 'a'     
    
    $scope.generate = () ->
      gen_data = gen($scope.scene,$scope.sceneOrtho,$scope.camera,$scope.cameraOrtho,$scope.width,$scope.height,$scope.idx,$scope.x_period,$scope.x_period,$scope.power,$scope.feature_size)
      $scope.renderer = renderers.create_renderer "planet",$scope.width,$scope.height,$scope.scene,$scope.sceneOrtho,$scope.camera,$scope.cameraOrtho,() ->
        objects[0].rotation.y += $scope.speed*2
        objects[1].rotation.y += $scope.speed*3
        
      $scope.state = 'a'  
      
    $scope.add_renderer_to = (element) ->
      controls = new THREE.OrbitControls( $scope.renderer.camera, $scope.renderer.renderer.domElement );
      controls.addEventListener( 'change', $scope.renderer.update );

      $scope.renderer.renderer.domElement.addEventListener 'dblclick', (event) ->
        #mouse_x = ( event.clientX / $scope.width ) * 2 - 1
        #mouse_y = - ( event.clientY / $scope.height ) * 2 + 1

        #vector = new THREE.Vector3( mouse_x, mouse_y, 1 )
        #projector = new THREE.Projector() 
        #projector.unprojectVector( vector, $scope.camera )
        #raycaster = new THREE.Raycaster()
        #raycaster.set( $scope.camera.position, vector.sub( $scope.camera.position ).normalize() )
        #debugger
        #for o in objects
        #  intersects = raycaster.intersectObject( o )
        #  if ( intersects.length > 0 )
        #    selected_object.remove($scope.camera)
        #    selected_object = o
        #    selected_object.add($scope.camera)
        if  $scope.state == 'a'
          objects[2].position.x = 3200
          objects[2].position.y = -3200
          objects[2].position.z = 3200
          $scope.state = 'b'
        else
          objects[2].position.x = 120
          objects[2].position.y = -120
          objects[2].position.z = 120
          $scope.state = 'a'




      
        $scope.renderer.update()



      element.append $scope.renderer.renderer.domElement