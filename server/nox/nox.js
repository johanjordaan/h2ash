// Generated by CoffeeScript 1.6.3
(function() {
  var nox, _;

  _ = require('underscore');

  nox = {};

  nox.is_template = function(object) {
    return object._nox_template;
  };

  nox.deep_clone = function(source) {
    var i, key, ret_val, _i, _j, _len, _len1, _ref;
    if (_.isFunction(source) || _.isNumber(source) || _.isString(source)) {
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
        ret_val[key] = nox.deep_clone(source[key]);
      }
      return ret_val;
    }
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
      if (template[key]._nox_method === true) {
        ret_val[key] = template[key].run(ret_val);
      } else {
        ret_val[key] = nox.deep_clone(template[key]);
      }
    }
    return ret_val;
  };

  nox.extend_template = function(source_template, name, properties) {
    var key, property_key, ret_val, _i, _j, _len, _len1, _ref, _ref1;
    ret_val = nox.deep_clone(source_template);
    _ref = _.keys(properties);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      key = _ref[_i];
      _ref1 = _.keys(properties[key]);
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        property_key = _ref1[_j];
        ret_val[key][property_key] = properties[key][property_key];
      }
    }
    return nox.create_template(name, ret_val);
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
    ret_val = {
      _nox_method: true,
      _nox_errors: [],
      min: input.min,
      max: input.max,
      normal: input.normal,
      run: function(target_object) {
        var diff, i, itterations, max, min, normal, _i, _len, _ref;
        if (nox.check_fields(this, ['min', 'max', 'normal'])) {
          return this._nox_errors;
        }
        min = nox.resolve(this.min, target_object);
        max = nox.resolve(this.max, target_object);
        normal = nox.resolve(this.normal, target_object);
        itterations = normal ? 3 : 1;
        ret_val = 0;
        diff = max - min;
        _ref = _.range(itterations);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          i = _ref[_i];
          ret_val += min + diff * Math.random();
        }
        ret_val = ret_val / itterations;
        return ret_val;
      }
    };
    return ret_val;
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
    ret_val = {
      _nox_method: true,
      count: input.count,
      values: input.values,
      return_one: input.return_one,
      run: function(target_object) {
        var count, default_probability, i, item, probability, r, return_one, total_probability, values, _i, _j, _len, _len1, _ref;
        count = Math.floor(nox.resolve(this.count, target_object));
        values = nox.resolve(this.values, target_object);
        return_one = nox.resolve(this.return_one, target_object);
        default_probability = 1 / _.size(values);
        ret_val = [];
        _ref = _.range(count);
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
                  ret_val.push(nox.construct_template(item.item));
                } else {
                  if (_.isString(item.item) && _.contains(_.keys(nox.templates), item.item)) {
                    ret_val.push(nox.construct_template(nox.templates[item.item]));
                  } else {
                    ret_val.push(item.item);
                  }
                }
              } else {
                if (_.isString(item) && _.contains(_.keys(nox.templates), item)) {
                  ret_val.push(nox.construct_template(nox.templates[item]));
                } else {
                  ret_val.push(item);
                }
              }
            }
          }
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

  module.exports = nox;

}).call(this);