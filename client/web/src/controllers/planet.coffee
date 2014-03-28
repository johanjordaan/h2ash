define ['OrbitControls','../utils/planet_visualiser','../game_scene'], (orbit,planet_visualiser,GS) ->

  return ($scope)->
    $scope.idx = 0
    $scope.x_period = 0
    $scope.y_period = 0
    $scope.power = 5
    $scope.feature_size = 32

    $scope.gs = new GS.GameScene(320,240)
    
    ambient_light = new THREE.AmbientLight(0x333333)
    $scope.gs.add(new GS.GameObject("Ambient Light",ambient_light)) 
    
    directional_light = new THREE.DirectionalLight(0xffffff, 1);
    directional_light.position.set(5,3,5)
    $scope.gs.add(new GS.GameObject("Directional Light",directional_light)) 
    

    icon_geometry = new THREE.Geometry();
    icon_geometry.vertices.push(new THREE.Vector3( 0, 5, 0));
    icon_geometry.vertices.push(new THREE.Vector3(-5,-5, 0));
    icon_geometry.vertices.push(new THREE.Vector3( 5,-5, 0));
    icon_geometry.faces.push( new THREE.Face3(0, 1, 2));
    icon_material = new THREE.MeshBasicMaterial({color:0xAAAAAA,wireframe:true,wireframeLinewidth:3})

    

    planet_icon = new THREE.Mesh( icon_geometry, icon_material )
    planet = planet_visualiser($scope.idx,$scope.x_period,$scope.y_period,$scope.power,$scope.feature_size)
    planet.position.set(0,0,0)
    planet_go = new GS.GameObject "Planet 1",planet,planet_icon, () ->
      planet.rotation.y += 0.001
    $scope.gs.add(planet_go) 


    planet2_icon = new THREE.Mesh( icon_geometry, icon_material )
    planet2 = planet_visualiser($scope.idx+1,$scope.x_period,$scope.y_period,$scope.power,$scope.feature_size)
    planet2.position.set(3000,-3000,3000)
    planet2_go = new GS.GameObject "Planet 2", planet2,planet2_icon, () ->
      planet2.rotation.y += 0.01
    $scope.gs.add(planet2_go) 

    ship_icon = new THREE.Mesh( icon_geometry, icon_material )
    ship_geometry = new THREE.CylinderGeometry( 0, 10, 30, 4, 1 )
    ship_material =  new THREE.MeshLambertMaterial( { color:0xffffff, shading: THREE.FlatShading } )
    ship = new THREE.Mesh( ship_geometry, ship_material )
    ship.position.set(0,0,200)
    ship_go = new GS.GameObject "Ship", ship,ship_icon, () ->
      ship.position.x += 1
      ship.position.y -= 1
      ship.position.z += 1
      
    $scope.gs.add(ship_go) 
    
    $scope.gs.set_camera_focus(ship_go)
    
    $scope.gs.animate()



    $scope.state = 'a'     
    $scope.add_renderer_to = (element) ->
      $scope.gs.renderer.domElement.addEventListener 'dblclick', (event) ->
        if  $scope.state == 'a'
          $scope.gs.objects[4].object.position.set(3200,-3200,3200)
          $scope.state = 'b'
        else
          $scope.gs.objects[4].object.position.set(0,0,200)
          $scope.state = 'a'


      $scope.gs.attach_to_element(element)