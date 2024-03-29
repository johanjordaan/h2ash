// Generated by CoffeeScript 1.6.3
(function() {
  var expect, nox, should;

  should = require('chai').should();

  expect = require('chai').expect;

  nox = require('../../nox/nox');

  describe('nox.const', function() {
    describe('- basic uasge : ', function() {
      var c;
      c = nox["const"]({
        value: 10
      });
      it('should set the _nox_method flag', function() {
        return c._nox_method.should.equal(true);
      });
      it('should set the _nox_errors flag', function() {
        c._nox_errors.should.be.a('array');
        return c._nox_errors.length.should.equal(0);
      });
      it('should store the value in the value variable', function() {
        return c.value.should.equal(10);
      });
      return it('should return the value when it is run', function() {
        var c_result;
        c_result = c.run();
        return c_result.should.equal(10);
      });
    });
    describe('- recursive usage : ', function() {
      var c;
      c = nox["const"]({
        value: nox["const"]({
          value: nox["const"]({
            value: 20
          })
        })
      });
      it('should set the _nox_method flag on the levels', function() {
        c._nox_method.should.equal(true);
        c.value._nox_method.should.equal(true);
        return c.value.value._nox_method.should.equal(true);
      });
      it('should set the value of the lowest level value', function() {
        return c.value.value.value.should.equal(20);
      });
      return it('should return the value when it is run', function() {
        var c_result;
        c_result = c.run();
        return c_result.should.equal(20);
      });
    });
    return describe('- error conditions :', function() {
      var c, c_result;
      c = nox["const"]({});
      c_result = c.run();
      it('should return an error list if the required fields (value) is not specified', function() {
        c_result.should.be.a('Array');
        return c_result.length.should.equal(1);
      });
      return it('should return a usable error message', function() {
        return c_result[0].should.equal("Required field [value] is missing.");
      });
    });
  });

}).call(this);
