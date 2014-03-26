define ['OrbitControls','../utils/planet_visualiser','../game_scene'], (orbit,planet_visualiser,GS) ->

  return ($scope)->
    $scope.idx = 0
    $scope.x_period = 0
    $scope.y_period = 0
    $scope.power = 5
    $scope.feature_size = 32


    $scope.speed = 0.001
    $scope.gs = new GS.GameScene(320,240)
    
    ambient_light = new THREE.AmbientLight(0x333333)
    $scope.gs.add(new GS.GameObject(ambient_light)) 
    
    directional_light = new THREE.DirectionalLight(0xffffff, 1);
    directional_light.position.set(5,3,5)
    $scope.gs.add(new GS.GameObject(directional_light)) 
    

    icon_geometry = new THREE.Geometry();
    icon_geometry.vertices.push(new THREE.Vector3( 0, 5, 0));
    icon_geometry.vertices.push(new THREE.Vector3(-5,-5, 0));
    icon_geometry.vertices.push(new THREE.Vector3( 5,-5, 0));
    icon_geometry.faces.push( new THREE.Face3(0, 1, 2));
    icon_material = new THREE.MeshBasicMaterial({color:0xAAAAAA,wireframe:true,wireframeLinewidth:3})

    

    planet_icon = new THREE.Mesh( icon_geometry, icon_material )
    planet = planet_visualiser($scope.idx,$scope.x_period,$scope.y_period,$scope.power,$scope.feature_size)
    planet.position.set(0,0,0)
    $scope.gs.add(new GS.GameObject(planet,planet_icon)) 


    planet2_icon = new THREE.Mesh( icon_geometry, icon_material )
    planet2 = planet_visualiser($scope.idx+1,$scope.x_period,$scope.y_period,$scope.power,$scope.feature_size)
    planet2.position.set(3000,-3000,3000)
    $scope.gs.add(new GS.GameObject(planet2,planet2_icon)) 

    ship_icon = new THREE.Mesh( icon_geometry, icon_material )
    ship_geometry = new THREE.CylinderGeometry( 0, 10, 30, 4, 1 )
    ship_material =  new THREE.MeshLambertMaterial( { color:0xffffff, shading: THREE.FlatShading } )
    ship = new THREE.Mesh( ship_geometry, ship_material )
    ship.position.set(0,0,200)
    $scope.gs.add(new GS.GameObject(ship,ship_icon)) 
    
    $scope.gs.set_camera_focus(ship)

    #$scope.renderer = renderers.create_renderer "planet",$scope.width,$scope.height,$scope.scene,$scope.sceneOrtho,$scope.camera,$scope.cameraOrtho,() ->
    #  objects[0].rotation.y += $scope.speed*2
    #  objects[1].rotation.y += $scope.speed*3
    $scope.state = 'a'     
    
    $scope.gs.animate()

    $scope.add_renderer_to = (element) ->
      controls = new THREE.OrbitControls( $scope.gs.visual.camera, $scope.gs.renderer.domElement );
      controls.addEventListener( 'change', $scope.gs.render.bind($scope.gs) );

      $scope.gs.renderer.domElement.addEventListener 'dblclick', (event) ->
        if  $scope.state == 'a'
          $scope.gs.objects[4].object.position.set(3200,-3200,3200)
          $scope.state = 'b'
        else
          $scope.gs.objects[4].object.position.set(0,0,200)
          $scope.state = 'a'

      $scope.gs.attach_to_element(element)