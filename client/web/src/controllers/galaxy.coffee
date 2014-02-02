define ['../services/renderers'], (renderers) ->
  camera = {}
  scene = {}    
  particleSystem = {}
  sector = {}

  construct_sector  = (ra,rb,ta,tb,pa,pb) ->
    sector = new THREE.Object3D()

    yellowLineMaterial = new THREE.LineBasicMaterial 
      color : 0xFF0000
      shading : THREE.FlatShading
      linewidth : 2

    a = []
    a.push trig.sc2cc(trig.make_sc(ra,ta,pa))
    a.push trig.sc2cc(trig.make_sc(ra,tb,pa))
    a.push trig.sc2cc(trig.make_sc(ra,tb,pb))
    a.push trig.sc2cc(trig.make_sc(ra,ta,pb))
    a.push trig.sc2cc(trig.make_sc(ra,ta,pa))  # Same as top to complete the loop

    b = []
    b.push trig.sc2cc(trig.make_sc(rb,ta,pa))
    b.push trig.sc2cc(trig.make_sc(rb,tb,pa))
    b.push trig.sc2cc(trig.make_sc(rb,tb,pb))
    b.push trig.sc2cc(trig.make_sc(rb,ta,pb))
    b.push trig.sc2cc(trig.make_sc(rb,ta,pa)) # Same as top to complete the loop


    for i in _.range(4)
      g1 = new THREE.Geometry()
      g1.vertices.push new THREE.Vector3(a[i].x,a[i].y,a[i].z)
      g1.vertices.push new THREE.Vector3(a[i+1].x,a[i+1].y,a[i+1].z)
      sector.add new THREE.Line g1,yellowLineMaterial

      g2 = new THREE.Geometry()
      g2.vertices.push new THREE.Vector3(b[i].x,b[i].y,b[i].z)
      g2.vertices.push new THREE.Vector3(b[i+1].x,b[i+1].y,b[i+1].z)
      sector.add new THREE.Line g2,yellowLineMaterial

      g3 = new THREE.Geometry()
      g3.vertices.push new THREE.Vector3(a[i].x,a[i].y,a[i].z)
      g3.vertices.push new THREE.Vector3(b[i].x,b[i].y,b[i].z)
      sector.add new THREE.Line g3,yellowLineMaterial
    
    return sector

  width = 320
  height = 240
  camera = new THREE.PerspectiveCamera( 75, width / height, 1, 10000 )
  camera.position.z = 1000
  scene = new THREE.Scene()

  particles = new THREE.Geometry()

  scale = 2
  radius = 1000
  r_steps = 10*scale
  delta_r = radius/r_steps
  theta_steps = 12*scale
  delta_theta = Math.PI/theta_steps
  phi_steps = 24*scale
  delta_phi = (2*Math.PI)/phi_steps 

  for i in _.range(10000)
    sc = trig.make_sc _.random(0,radius),Math.random()*Math.PI,Math.random()*2*Math.PI
    cc = trig.sc2cc(sc)
    particle = new THREE.Vector3(cc.x,cc.y,cc.z)
    particles.vertices.push( particle )

  pMaterial = new THREE.ParticleBasicMaterial
    color: 0xFFFFFF
    size: 16
    map: THREE.ImageUtils.loadTexture "images/particle.png"
    transparent: true
    blending: THREE.AdditiveBlending
    depthWrite : true
    #alphaTest : 0.5
  
  particleSystem = new THREE.ParticleSystem particles,pMaterial
  particleSystem.sortParticles = true;
  scene.add(particleSystem)

  
  sector = construct_sector(delta_r*12,delta_r*13,0,delta_theta   ,Math.PI*.5,Math.PI*.5+delta_phi)
  scene.add(sector)

  ah = new THREE.AxisHelper(5000)
  scene.add ah


  return ($scope,$timeout,renderers)->
    $scope.speed = 0
    renderer = renderers.create_renderer "galaxy",320,240,scene,camera,() ->
      particleSystem.rotation.y += $scope.speed
      particleSystem.rotation.x += $scope.speed

    $scope.inc_speed = () ->
      $scope.speed += 0.001

    $scope.dec_speed = () ->
      $scope.speed -= 0.001
    
    $scope.add_renderer_to = (element) ->
      element.append renderer.renderer.domElement