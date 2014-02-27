// Generated by CoffeeScript 1.6.3
(function() {
  define(['../services/renderers', 'underscore', '../utils/hmap'], function(renderers, _, hmap) {
    var camera, clouds, earth, hdata, height, i, light, material, scene, size, texture, texture_data, width, _i, _len, _ref;
    width = 320;
    height = 240;
    scene = new THREE.Scene();
    camera = new THREE.PerspectiveCamera(45, width / height, 0.01, 1000);
    camera.position.z = 1.5;
    scene.add(new THREE.AmbientLight(0x333333));
    light = new THREE.DirectionalLight(0xffffff, 1);
    light.position.set(5, 3, 5);
    scene.add(light);
    hdata = hmap(512, 256, 128);
    size = 512 * 256;
    texture_data = new Uint8Array(4 * size);
    _ref = _.range(size);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      texture_data[0 + i * 4] = hdata.data[i] * 0xff;
      texture_data[1 + i * 4] = hdata.data[i] * 0xff;
      texture_data[2 + i * 4] = hdata.data[i] * 0xff;
      texture_data[3 + i * 4] = 0xff;
    }
    texture = new THREE.DataTexture(texture_data, 512, 256);
    texture.needsUpdate = true;
    material = new THREE.MeshPhongMaterial({
      map: texture,
      bumpMap: texture,
      bumpScale: 0.005,
      specular: new THREE.Color('grey')
    });
    earth = new THREE.Mesh(new THREE.SphereGeometry(0.5, 32, 32), material);
    clouds = new THREE.Mesh(new THREE.SphereGeometry(0.503, 32, 32), new THREE.MeshPhongMaterial({
      map: THREE.ImageUtils.loadTexture('images/fair_clouds_4k.png'),
      transparent: true
    }));
    scene.add(earth);
    return function($scope, $timeout, renderers) {
      var renderer;
      $scope.speed = 0.001;
      renderer = renderers.create_renderer("planet", width, height, scene, camera, function() {
        earth.rotation.y += $scope.speed;
        return clouds.rotation.y += $scope.speed * 2;
      });
      return $scope.add_renderer_to = function(element) {
        return element.append(renderer.renderer.domElement);
      };
    };
  });

}).call(this);
