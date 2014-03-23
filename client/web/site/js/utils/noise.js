// Generated by CoffeeScript 1.6.3
(function() {
  define(['underscore', '../utils/rnd'], function(_, rnd) {
    var HMAP, bilinear_filter, generate, generate_noise, normalise, smooth_noise, turbulence, turbulence2_noise, turbulence_noise, zoom;
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
    bilinear_filter = function(noise, x, y, zoom) {
      var fractX, fractY, value, x0, x0_int, x1, x2, y0, y0_int, y1, y2;
      x0 = x / zoom;
      y0 = y / zoom;
      x0_int = Math.floor(x0);
      y0_int = Math.floor(y0);
      fractX = x0 - x0_int;
      fractY = y0 - y0_int;
      x1 = x0_int;
      y1 = y0_int;
      x2 = (x0_int + noise.width - 1) % (noise.width / zoom);
      y2 = (y0_int + noise.height - 1) % (noise.height / zoom);
      value = 0;
      value += fractX * fractY * noise.data[x1 + y1 * noise.width];
      value += fractX * (1 - fractY) * noise.data[x1 + y2 * noise.width];
      value += (1 - fractX) * fractY * noise.data[x2 + y1 * noise.width];
      value += (1 - fractX) * (1 - fractY) * noise.data[x2 + y2 * noise.width];
      return value;
    };
    smooth_noise = function(noise, zoom) {
      var i, x, y, zoomed_noise;
      zoomed_noise = [];
      i = 0;
      while (i < noise.size) {
        y = Math.floor(i / noise.width);
        x = i % noise.width;
        zoomed_noise[i] = bilinear_filter(noise, x, y, zoom);
        i = i + 1;
      }
      return zoomed_noise;
    };
    turbulence = function(noise, x, y, size) {
      var initialSize, value;
      value = 0;
      initialSize = size;
      while (size >= 1) {
        value += bilinear_filter(noise, x, y, size) * size;
        size /= 4;
      }
      return value;
    };
    turbulence_noise = function(noise, size) {
      var i, x, y, zoomed_noise;
      zoomed_noise = [];
      i = 0;
      while (i < noise.size) {
        y = Math.floor(i / noise.width);
        x = i % noise.width;
        zoomed_noise[i] = turbulence(noise, x, y, size);
        i = i + 1;
      }
      return zoomed_noise;
    };
    turbulence2_noise = function(noise, x_period, y_period, power, size) {
      var i, turbo, v, x, x_v, xy_v, y, y_v, zoomed_noise;
      zoomed_noise = [];
      i = 0;
      while (i < noise.size) {
        y = Math.floor(i / noise.width);
        x = i % noise.width;
        x_v = x * x_period / noise.width;
        y_v = y * y_period / noise.height;
        turbo = power * turbulence(noise, x, y, size) / size / 30;
        xy_v = x_v + y_v + turbo;
        v = Math.abs(Math.sin(xy_v * 3.14159));
        zoomed_noise[i] = v;
        i = i + 1;
      }
      return zoomed_noise;
    };
    normalise = function(noise) {
      var c, i, max, min, ret_val, _i, _j, _len, _len1, _ref, _ref1;
      min = max = noise.data[0];
      _ref = noise.data;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        c = _ref[_i];
        if (c < min) {
          min = c;
        }
        if (c > max) {
          max = c;
        }
      }
      ret_val = new HMAP(noise.width, noise.height, []);
      _ref1 = _.range(noise.width * noise.height);
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        i = _ref1[_j];
        ret_val.data[i] = (noise.data[i] - min) / (max - min);
      }
      return ret_val;
    };
    return generate = function(width, height, x_period, y_period, power, size) {
      var noise, ntnoise, tnoise;
      noise = new HMAP(width, height, generate_noise(width, height));
      tnoise = new HMAP(width, height, turbulence2_noise(noise, x_period, y_period, power, size));
      ntnoise = normalise(tnoise);
      return ntnoise;
    };
  });

}).call(this);
