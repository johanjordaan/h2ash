// Generated by CoffeeScript 1.6.3
(function() {
  define(['underscore', '../utils/cmap', '../utils/noise'], function(_, cmap, noise) {
    var generate_planet;
    return generate_planet = function(index, x_period, y_period, power, size, planet_size, clouds_ind) {
      var bump_scale, bumpmap, cdata, cloud_cdata, cloud_hdata, cloud_texture, clouds, hdata, layer, layers, map_height, map_width, material, planet, spec, texture, _i, _len;
      map_width = 512;
      map_height = 256;
      bump_scale = 6;
      hdata = noise(map_width, map_height, x_period, y_period, power, size);
      cdata = cmap(hdata, index);
      texture = new THREE.DataTexture(cdata.cmap.data, map_width, map_height);
      texture.needsUpdate = true;
      spec = new THREE.DataTexture(cdata.smap.data, map_width, map_height);
      spec.needsUpdate = true;
      bumpmap = new THREE.DataTexture(cdata.bmap.data, map_width, map_height);
      bumpmap.needsUpdate = true;
      material = new THREE.MeshPhongMaterial({
        map: texture,
        bumpMap: bumpmap,
        bumpScale: bump_scale,
        specularMap: spec,
        specular: new THREE.Color('grey')
      });
      planet = new THREE.Mesh(new THREE.SphereGeometry(planet_size, 24, 24), material);
      if ((clouds_ind != null) && clouds_ind) {
        layers = [
          {
            size: 64,
            color: 5
          }
        ];
        for (_i = 0, _len = layers.length; _i < _len; _i++) {
          layer = layers[_i];
          map_width = 256;
          map_height = 1024;
          cloud_hdata = noise(map_width, map_height, 0, 0, 1, layer.size);
          cloud_cdata = cmap(cloud_hdata, layer.color);
          cloud_texture = new THREE.DataTexture(cloud_cdata.cmap.data, map_width, map_height);
          cloud_texture.needsUpdate = true;
          clouds = new THREE.Mesh(new THREE.SphereGeometry(planet_size * 1.1, 24, 24), new THREE.MeshPhongMaterial({
            map: cloud_texture,
            transparent: true
          }));
          planet.add(clouds);
        }
      }
      return planet;
    };
  });

}).call(this);
