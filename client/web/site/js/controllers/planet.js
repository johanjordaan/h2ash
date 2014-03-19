// Generated by CoffeeScript 1.6.3
(function() {
  define(['../services/renderers', 'underscore', '../utils/hmap', '../utils/cmap', '../utils/noise'], function(renderers, _, hmap, cmap, noise) {
    var gen;
    gen = function(width, height, index, feature_size) {
      var bump_scale, bumpmap, camera, cdata, earth, hdata, light, map_height, map_width, material, ret_val, scene, size, spec, texture;
      scene = new THREE.Scene();
      camera = new THREE.PerspectiveCamera(45, width / height, 0.01, 1000);
      camera.position.z = 1.5;
      scene.add(new THREE.AmbientLight(0x333333));
      light = new THREE.DirectionalLight(0xffffff, 1);
      light.position.set(5, 3, 5);
      scene.add(light);
      map_width = 512;
      map_height = 256;
      bump_scale = 0.1;
      hdata = noise(map_width, map_height, 0, 1);
      size = map_width * map_height;
      cdata = cmap(hdata, index);
      texture = new THREE.DataTexture(cdata.cmap.data, map_width, map_height);
      texture.needsUpdate = true;
      spec = new THREE.DataTexture(cdata.smap.data, map_width, map_height);
      spec.needsUpdate = true;
      bumpmap = new THREE.DataTexture(cdata.bmap.data, map_width, map_height);
      bumpmap.needsUpdate = true;
      material = new THREE.MeshPhongMaterial({
        map: texture,
        specularMap: spec
      });
      earth = new THREE.Mesh(new THREE.SphereGeometry(0.5, 24, 24), material);
      scene.add(earth);
      return ret_val = {
        scene: scene,
        camera: camera,
        planet: earth
      };
    };
    return function($scope, $timeout, renderers) {
      var gen_data, renderer;
      $scope.speed = 0.01;
      $scope.width = 320;
      $scope.height = 240;
      $scope.idx = 2;
      $scope.feature_size = 32;
      gen_data = gen($scope.width, $scope.height, $scope.idx, $scope.feature_size);
      renderer = renderers.create_renderer("planet", $scope.width, $scope.height, gen_data.scene, gen_data.camera, function() {
        return gen_data.planet.rotation.y += $scope.speed;
      });
      $scope.generate = function() {
        gen_data = gen($scope.width, $scope.height, $scope.idx, $scope.feature_size);
        return renderer = renderers.create_renderer("planet", $scope.width, $scope.height, gen_data.scene, gen_data.camera, function() {
          return gen_data.planet.rotation.y += $scope.speed;
        });
      };
      return $scope.add_renderer_to = function(element) {
        return element.append(renderer.renderer.domElement);
      };
    };
  });

}).call(this);
