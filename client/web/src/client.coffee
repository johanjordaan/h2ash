require.config
  paths : 
      'jquery'   : '../bower_components/jquery/jquery.min'
      'bootstrap'  : '../bower_components/bootstrap/dist/js/bootstrap.min'
      'angular'  : '../bower_components/angular/angular'
      'angular-route'  : '../bower_components/angular-route/angular-route'
      'domReady' : '../bower_components/requirejs-domready/domReady',
      'underscore' : '../bower_components/underscore/underscore'
      'trig' : '../js/utils/trig'
      'THREE' : '../bower_components/three.js/three.min'

  shim :  
    'bootstrap' :
      exports : 'bootstrap'
      deps : ['jquery']
    'angular' : 
      exports : 'angular'
    'angular-route' : 
      deps : ['angular']
    'underscore' :
      exports : '_'
    'trig' :
      exports : 'trig' 
    'THREE' :
      exports : 'THREE' 

## 333333333333333
camera = {}
scene = {}
renderer = {}      
particleSystem = {}
sector = {}

animate = () ->
  requestAnimationFrame animate
  render()

render = () ->  
  speed = 0.001
  particleSystem.rotation.y += speed
  #particleSystem.rotation.x += 0.0005
  sector.rotation.y += speed
  renderer.render scene,camera

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



define ['jquery','bootstrap','underscore','require','angular','angular-route','trig'
        ,'./ng-directives/ng-draggable','./ng-directives/ng-window','./ng-directives/ng-workspace'
        ,'./ng-directives/ng-widget','THREE','api' ]
      , ($,bootstrap,_,require,angular,angular_route,trig,draggable,window,workspace,widget,THREE,api) ->
  
  renderer = new THREE.WebGLRenderer()

  angular.module('app',['ngRoute'])
    .config ($routeProvider) ->
      $routeProvider
      .when '/',
        templateUrl : 'partials/workspaces/login_workspace.html'
      .when '/pre_registration',
        templateUrl : 'partials/workspaces/pre_registration_workspace.html'
      .when '/pre_registration/validated',
        templateUrl : 'partials/workspaces/pre_registration_validated_workspace.html'
      .when '/main',
        templateUrl : 'partials/workspaces/main_workspace.html'
      .otherwise
        redirectTo : '/'
    .value 'auth',
      authenticated : false
      token : ''
    .factory('backend', api)
    .directive('draggable',draggable) 
    .directive('window',window)
    .directive('workspace',workspace)
    .directive('widget',widget)
    .controller 'leads_controller',($scope,$timeout,backend)->
      $scope.leads = []
      for i in _.range(20)
        $scope.leads.push
          email : 'email'+i
          motivation : 'halloooeee '+i
          validated : true
      #backend.get_leads $scope,{}
      #,(leads) ->
      #  $scope.leads = leads 
    .controller 'galaxy_controller',($scope,$timeout)->
      $scope.add_frame = () ->
        angular.element($('#three_target')).append( renderer.domElement )
    .controller 'about_controller',($scope)->
      #alert 'loading about controller'
      $scope.xxx = 'Here'
      $scope.say_it = (what) ->
        $scope.xxx = what
        alert 'I was told to say -> '+what
    .controller 'login_controller',($scope,$location,backend,auth) ->  
      $scope.login = () ->
        backend.login $scope,
          email : $scope.$$childHead.email
          password : $scope.$$childHead.password
        ,(authenticated) ->
          if authenticated 
            $location.path '/main'

      $scope.pre_register = () ->       
        $location.path '/pre_registration'
    .controller 'pre_registration_controller',($scope,$location,$timeout,backend) ->
      $scope.finished = false
      $scope.register = () ->
        backend.pre_register $scope,
          email : $scope.$$childHead.email 
          motivation : $scope.$$childHead.motivation 
        ,(success) ->
          if success
            $scope.finished = true
        
  width = 320
  height = 240
  camera = new THREE.PerspectiveCamera( 75, width / height, 1, 10000 )
  camera.position.z = 1000
  scene = new THREE.Scene()
  renderer = new THREE.WebGLRenderer()
  renderer.setSize(width,height) 
  renderer.setClearColor( 0x000000, 1) 


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




  require ['domReady!'], (document) ->
    angular.bootstrap document,['app']
    animate();

    $('body').css('background-image', "url('/images/ClientBackground.jpg')")

