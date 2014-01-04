// Generated by CoffeeScript 1.6.3
(function() {
  var expect, fix_random_value, fix_random_values, nox, saved_random, should, _;

  _ = require('underscore');

  should = require('chai').should();

  expect = require('chai').expect;

  nox = require('../../nox/nox');

  saved_random = Math.random;

  fix_random_value = function(value) {
    return fix_random_values([value]);
  };

  fix_random_values = function(values) {
    values = values.reverse();
    return Math.random = function() {
      var value;
      value = values.pop();
      fix_random_values(values.reverse());
      return value;
    };
  };

  describe('nox.select', function() {
    describe('- basic usage (select from non-template list) flat distribution : ', function() {
      var c, d, e, list, result;
      list = ['A', 'B', 'C', 'D'];
      c = nox.select({
        values: list
      });
      it('should set the _nox_method flag', function() {
        return c._nox_method.should.equal(true);
      });
      it('should set the _nox_errors flag', function() {
        c._nox_errors.should.be.a('array');
        return c._nox_errors.length.should.equal(0);
      });
      it('should store values in the values property', function() {
        return c.values.should.equal(list);
      });
      it('should set the default count to 1', function() {
        return c.count.should.equal(1);
      });
      it('should set the deafult return_one flag to false', function() {
        return c.return_one.should.equal(false);
      });
      d = nox.select({
        count: 3,
        values: list
      });
      it('should set the count to 3', function() {
        return d.count.should.equal(3);
      });
      fix_random_values([0, 0.5, 1]);
      result = d.run();
      it('should return a result with length of 3', function() {
        return result.length.should.equal(3);
      });
      it('should return an array with values A,B,D based on 0,0.5 and 1 random values', function() {
        var expected, i, _i, _len, _ref, _results;
        expected = ['A', 'B', 'D'];
        _ref = _.range(3);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          i = _ref[_i];
          _results.push(result[i].should.equal(expected[i]));
        }
        return _results;
      });
      e = nox.select_one({
        values: list
      });
      it('should set the deafult return_one flag to falstrue if using select_one', function() {
        return e.return_one.should.equal(true);
      });
      return it('should select a single item from the list (not as an array)', function() {
        fix_random_value(0.7);
        return e.run().should.equal('C');
      });
    });
    describe('- basic usage (select from list of templates, the templates must be constructed) flat distribution', function() {
      var a, alien, female, male, result;
      male = nox.create_template('male', {
        name: nox.select_one({
          values: ['John', 'Joe', 'Peter']
        })
      });
      female = nox.create_template('female', {
        name: nox.select_one({
          values: ['Jane', 'Sue', 'Sandra', 'Ruth']
        })
      });
      alien = nox.create_template('alien', {
        name: nox.select_one({
          values: ['Xi', 'Yi', 'Zi', 'Zoooo']
        })
      });
      a = nox.select({
        count: 2,
        values: [alien, female, male]
      });
      fix_random_values([1, 0.5, 0.5, 1]);
      result = a.run();
      return it('should return template instances based on the random numbers supplied', function() {
        result[0].name.should.equal('Joe');
        return result[1].name.should.equal('Ruth');
      });
    });
    describe('- recursive usage : ', function() {
      var gen_list, r, result;
      gen_list = function() {
        return ['X', 'Y', 'Z'];
      };
      r = nox.select({
        count: nox.rnd({
          min: 1,
          max: 3
        }),
        values: nox.method({
          method: gen_list
        })
      });
      fix_random_values([0.5, 0.5, 1]);
      result = r.run();
      return it('should get the list of values(2) from the method and selcet a random one from the list', function() {
        result.length.should.equal(2);
        result[0].should.equal('Y');
        return result[1].should.equal('Z');
      });
    });
    return describe('- error conditions :', function() {
      var c, c_result;
      c = nox.select({});
      c_result = c.run();
      it('should return an error list if the required fields (values) is not specified', function() {
        c_result.should.be.a('Array');
        return c_result.length.should.equal(1);
      });
      return it('should return a usable error message', function() {
        return c_result[0].should.equal("Required field [values] is missing.");
      });
    });
  });

}).call(this);
