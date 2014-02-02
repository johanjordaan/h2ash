// Generated by CoffeeScript 1.6.3
(function() {
  var nox, _,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  _ = require('underscore');

  nox = {};

  nox.is_template = function(object) {
    if (object == null) {
      return false;
    }
    if (!_.isObject(object)) {
      return false;
    }
    return object._nox_template;
  };

  nox.is_method = function(object) {
    if (object == null) {
      return false;
    }
    if (!_.isObject(object)) {
      return false;
    }
    return object._nox_method === true;
  };

  nox.deep_clone = function(source, directives) {
    var i, key, ret_val, _i, _j, _len, _len1, _ref;
    if (_.isFunction(source) || _.isNumber(source) || _.isString(source) || _.isBoolean(source)) {
      return source;
    }
    if (_.isArray(source)) {
      ret_val = [];
      for (_i = 0, _len = source.length; _i < _len; _i++) {
        i = source[_i];
        ret_val.push(nox.deep_clone(i));
      }
      return ret_val;
    }
    if (_.isObject(source)) {
      ret_val = {};
      _ref = _.keys(source);
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        key = _ref[_j];
        if ((directives != null) && (directives.remove != null) && __indexOf.call(directives.remove, key) >= 0) {

        } else {
          ret_val[key] = nox.deep_clone(source[key], directives);
        }
      }
      return ret_val;
    }
  };

  nox.probability = function(probability, item) {
    var ret_val;
    ret_val = {
      probability: probability,
      item: item
    };
    return ret_val;
  };

  nox.is_method_valid = function(method) {
    var key, _i, _len, _ref;
    console.log('xxxx', method);
    if (method._nox_errors.length > 0) {
      return false;
    }
    _ref = _.keys(method);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      key = _ref[_i];
      if (nox.is_method(method[key])) {
        if (!nox.is_method_valid(method[key])) {
          return false;
        }
      }
    }
    return true;
  };

  nox.is_template_valid = function(template) {
    var key, _i, _len, _ref;
    if (template == null) {
      return false;
    }
    if (!_.isObject(template)) {
      return false;
    }
    if (!nox.is_template(template)) {
      return false;
    }
    _ref = _.keys(template);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      key = _ref[_i];
      if (nox.is_method(template[key])) {
        if (!nox.is_method_valid(template[key])) {
          return false;
        }
      }
    }
    return true;
  };

  nox.templates = {};

  nox.create_template = function(name, properties) {
    nox.templates[name] = properties;
    properties._nox_template = true;
    properties._nox_template_name = name;
    return properties;
  };

  nox.construct_template = function(template, parent, index) {
    var key, ret_val, template_str, _i, _len, _ref;
    ret_val = {
      _parent: parent,
      _index: index,
      _nox_errors: []
    };
    if (template == null) {
      ret_val._nox_errors.push("Cannot construct template with undefined template parameter.");
      return ret_val;
    }
    if (_.isString(template)) {
      template_str = template;
      template = nox.templates[template];
      if (template == null) {
        ret_val._nox_errors.push("Cannot find template [" + template_str + "].");
        return ret_val;
      }
    }
    _ref = _.keys(template);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      key = _ref[_i];
      if (key === '_nox_template') {
        continue;
      }
      if (template[key]._nox_method === true) {
        ret_val[key] = template[key].run(ret_val);
      } else {
        ret_val[key] = nox.deep_clone(template[key]);
      }
    }
    return ret_val;
  };

  nox.extend_fields = function(fields, properties, directives) {
    var key, _i, _len, _ref, _results;
    _ref = _.keys(properties);
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      key = _ref[_i];
      if ((directives != null) && (directives.remove != null) && __indexOf.call(directives.remove, key) >= 0) {
        _results.push(delete fields[key]);
      } else {
        if ((fields[key] == null) || !_.isObject(properties[key]) || !_.isObject(fields[key]) || nox.is_method(properties[key])) {
          _results.push(fields[key] = nox.deep_clone(properties[key]));
        } else {
          _results.push(nox.extend_fields(fields[key], properties[key]));
        }
      }
    }
    return _results;
  };

  nox.extend_template = function(source_template, name, properties, directives) {
    var ret_val;
    ret_val = nox.deep_clone(source_template, directives);
    nox.extend_fields(ret_val, properties, directives);
    return nox.create_template(name, ret_val);
  };

  nox.de_nox = function(o) {
    var i, key, _i, _j, _len, _len1, _ref, _results, _results1;
    if (_.isArray(o)) {
      _results = [];
      for (_i = 0, _len = o.length; _i < _len; _i++) {
        i = o[_i];
        _results.push(nox.de_nox(i));
      }
      return _results;
    } else if (_.isObject(o)) {
      delete o._parent;
      delete o._nox_errors;
      delete o._index;
      delete o._nox_template_name;
      _ref = _.keys(o);
      _results1 = [];
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        key = _ref[_j];
        _results1.push(nox.de_nox(o[key]));
      }
      return _results1;
    }
  };

  nox.resolve = function(parameter, target_object) {
    if (parameter._nox_method) {
      return parameter.run(target_object);
    } else {
      return parameter;
    }
  };

  nox.check_field = function(field, field_name, errors) {
    if (field == null) {
      return errors.push("Required field [" + field_name + "] is missing.");
    }
  };

  nox.check_fields = function(source, field_list) {
    var field, _i, _len;
    for (_i = 0, _len = field_list.length; _i < _len; _i++) {
      field = field_list[_i];
      nox.check_field(source[field], field, source._nox_errors);
    }
    return _.size(source._nox_errors) > 0;
  };

  nox["const"] = function(input) {
    var ret_val;
    ret_val = {
      _nox_method: true,
      _nox_errors: [],
      value: input.value,
      run: function(target_object) {
        var value;
        if (nox.check_fields(this, ['value'])) {
          return this._nox_errors;
        }
        value = nox.resolve(this.value, target_object);
        return value;
      }
    };
    return ret_val;
  };

  nox.method = function(input) {
    var ret_val;
    ret_val = {
      _nox_method: true,
      _nox_errors: [],
      method: input.method,
      run: function(target_object) {
        var method;
        if (nox.check_fields(this, ['method'])) {
          return this._nox_errors;
        }
        method = nox.resolve(this.method, target_object);
        return method(target_object);
      }
    };
    return ret_val;
  };

  nox.rnd = function(input) {
    var ret_val;
    if (input.min == null) {
      input.min = 0;
    }
    if (input.normal == null) {
      input.normal = false;
    }
    if (input.integer == null) {
      input.integer = false;
    }
    ret_val = {
      _nox_method: true,
      _nox_errors: [],
      min: input.min,
      max: input.max,
      normal: input.normal,
      integer: input.integer,
      run: function(target_object) {
        var diff, i, integer, itterations, max, min, normal, _i, _len, _ref;
        if (nox.check_fields(this, ['min', 'max', 'normal', 'integer'])) {
          return this._nox_errors;
        }
        min = nox.resolve(this.min, target_object);
        max = nox.resolve(this.max, target_object);
        normal = nox.resolve(this.normal, target_object);
        integer = nox.resolve(this.integer, target_object);
        itterations = normal ? 3 : 1;
        ret_val = 0;
        diff = max - min;
        _ref = _.range(itterations);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          i = _ref[_i];
          if (integer) {
            ret_val += _.random(min, max);
          } else {
            ret_val += min + diff * Math.random();
          }
        }
        ret_val = ret_val / itterations;
        return ret_val;
      }
    };
    return ret_val;
  };

  nox.rnd_int = function(input) {
    input.integer = true;
    return nox.rnd(input);
  };

  nox.rnd_normal = function(input) {
    input.normal = true;
    return nox.rnd(input);
  };

  nox.select = function(input) {
    var ret_val;
    if (input.count == null) {
      input.count = 1;
    }
    if (input.return_one == null) {
      input.return_one = false;
    }
    if (input.enable_batching == null) {
      input.enable_batching = false;
    }
    if (input.batch_size == null) {
      input.batch_size = 0;
    }
    if (input.batch_cb == null) {
      input.batch_cb = function() {};
    }
    ret_val = {
      _nox_method: true,
      _nox_errors: [],
      count: input.count,
      values: input.values,
      return_one: input.return_one,
      enable_batching: input.enable_batching,
      batch_size: input.batch_size,
      batch_cb: input.batch_cb,
      run: function(target_object) {
        var batch_busy, batch_cb, batch_count, batch_size, count, default_probability, enable_batching, extra_batch, f, generate, num_batches, return_one, values;
        if (nox.check_fields(this, ['values'])) {
          return this._nox_errors;
        }
        count = nox.resolve(this.count, target_object);
        values = nox.resolve(this.values, target_object);
        return_one = nox.resolve(this.return_one, target_object);
        enable_batching = nox.resolve(this.enable_batching, target_object);
        batch_size = nox.resolve(this.batch_size, target_object);
        batch_cb = nox.resolve(this.batch_cb, target_object);
        if (count === 0 && !return_one) {
          return [];
        }
        if (count !== 1 && return_one) {
          this._nox_errors.push("To select one a count of exactly 1 is required.");
          return this._nox_errors;
        }
        if (_.size(values) === 0) {
          this._nox_errors.push("Values list should contain at least one value.");
          return this._nox_errors;
        }
        default_probability = 1 / _.size(values);
        extra_batch = 0;
        if (count % batch_size > 0) {
          extra_batch = 1;
        }
        num_batches = Math.floor(count / batch_size) + extra_batch;
        batch_count = 0;
        batch_busy = false;
        ret_val = [];
        generate = function() {
          var i, item, last_batch, probability, r, ret_arr, start, stop, total_probability, _i, _j, _len, _len1, _ref;
          batch_busy = true;
          ret_arr = [];
          start = 0;
          stop = count;
          if (enable_batching) {
            start = batch_count * batch_size;
            stop = (batch_count + 1) * batch_size;
            last_batch = false;
            if (stop > count) {
              stop = count;
              last_batch = true;
            }
          }
          _ref = _.range(start, stop);
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            i = _ref[_i];
            r = Math.random();
            total_probability = 0;
            for (_j = 0, _len1 = values.length; _j < _len1; _j++) {
              item = values[_j];
              probability = item.probability != null ? item.probability : default_probability;
              total_probability += probability;
              if (r <= total_probability) {
                if ((item.item != null) && (item.probability != null)) {
                  if (nox.is_template(item.item)) {
                    ret_arr.push(nox.construct_template(item.item, target_object, i));
                    break;
                  } else {
                    if (_.isString(item.item) && _.contains(_.keys(nox.templates), item.item)) {
                      ret_arr.push(nox.construct_template(nox.templates[item.item], target_object, i));
                      break;
                    } else {
                      ret_arr.push(item.item);
                      break;
                    }
                  }
                } else {
                  if (nox.is_template(item)) {
                    ret_arr.push(nox.construct_template(item, target_object, i));
                    break;
                  } else if (_.isString(item) && _.contains(_.keys(nox.templates), item)) {
                    ret_arr.push(nox.construct_template(nox.templates[item], target_object, i));
                    break;
                  } else {
                    ret_arr.push(item);
                    break;
                  }
                }
              }
            }
          }
          if (enable_batching) {
            batch_cb(batch_size, batch_count, last_batch, ret_arr, function() {
              console.log('Here....');
              batch_count += 1;
              return batch_busy = false;
            });
          }
          return ret_arr;
        };
        ret_val = generate();
        if (enable_batching) {
          f = function() {
            if (batch_count <= num_batches) {
              if (!batch_busy) {
                generate();
              } else {
                console.log('Waiting...');
              }
              return setTimeout(f, 100);
            }
          };
          setTimeout(f, 100);
        }
        if (return_one) {
          return ret_val[0];
        } else {
          return ret_val;
        }
      }
    };
    return ret_val;
  };

  nox.select_one = function(input) {
    input.count = 1;
    input.return_one = true;
    return nox.select(input);
  };

  nox.select_batched = function(input) {
    input.enable_batching = true;
    return nox.select(input);
  };

  module.exports = nox;

}).call(this);
