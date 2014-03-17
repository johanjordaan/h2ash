// Generated by CoffeeScript 1.6.3
(function() {
  define(['underscore', '../utils/rnd'], function(_, rnd) {
    var HMAP, generate, generate_noise, zoom;
    HMAP = function(width, height, data) {
      var ret_val;
      return ret_val = {
        size: width * height,
        width: width,
        height: height,
        data: data
      };
    };
    generate_noise = function(width, height) {
      var i, noise, size;
      size = width * height;
      noise = [];
      i = 0;
      while (i < size) {
        noise[i] = rnd.random();
        i = i + 1;
      }
      return noise;
    };
    zoom = function(noise, size) {
      var i, x, y, zoomed_noise;
      zoomed_noise = [];
      i = 0;
      while (i < noise.size) {
        y = Math.floor(i / noise.width);
        x = i % noise.width;
        zoomed_noise[i] = noise.data[Math.floor(x / size) + Math.floor(y / size) * noise.width];
        i = i + 1;
      }
      return zoomed_noise;
    };
    return generate = function(width, height) {
      var noise, zoomed_noise;
      noise = new HMAP(width, height, generate_noise(width, height));
      zoomed_noise = new HMAP(width, height, zoom(noise, 16));
      return zoomed_noise;
    };
  });

}).call(this);
