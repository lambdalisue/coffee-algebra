(function() {
  var Vector, unittest, utils;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  utils = require('./utils');
  exports.Vector = Vector = (function() {
    __extends(Vector, utils.AccessorPropertyObject);
    function Vector(axes) {
      this.axes = axes;
    }
    Vector.get('x', function() {
      if (this.axes.length === 2 || this.axes.length === 3) {
        return this.axes[0];
      }
    });
    Vector.get('y', function() {
      if (this.axes.length === 2 || this.axes.length === 3) {
        return this.axes[1];
      }
    });
    Vector.get('z', function() {
      if (this.axes.length === 3) {
        return this.axes[2];
      }
    });
    Vector.set('x', function(value) {
      if (this.axes.length === 2 || this.axes.length === 3) {
        return this.axes[0] = value;
      }
    });
    Vector.set('y', function(value) {
      if (this.axes.length === 2 || this.axes.length === 3) {
        return this.axes[1] = value;
      }
    });
    Vector.set('z', function(value) {
      if (this.axes.length === 3) {
        return this.axes[2] = value;
      }
    });
    Vector.prototype.plus = function(vector) {
      return Vector.plus(this, vector);
    };
    Vector.prototype.minus = function(vector) {
      return Vector.minus(this, vector);
    };
    Vector.prototype.multiple = function(scalar) {
      return Vector.multiple(this, scalar);
    };
    Vector.prototype.devide = function(scalar) {
      return Vector.devide(this, scalar);
    };
    Vector.prototype.dot = function(vector) {
      return Vector.dot(this, vector);
    };
    Vector.prototype.cross = function(vector) {
      return Vector.cross(this, vector);
    };
    Vector.prototype.square = function() {
      var axis, squareTotal, _i, _len, _ref;
      squareTotal = 0;
      _ref = this.axes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        axis = _ref[_i];
        squareTotal += Math.pow(axis, 2);
      }
      return squareTotal;
    };
    Vector.prototype.size = function() {
      return Math.sqrt(this.square());
    };
    Vector.prototype.unit = function() {
      return this.devide(this.size());
    };
    Vector.prototype.toString = function() {
      if (this.axes.length === 2) {
        return "<Vector (" + this.x + ", " + this.y + ")>";
      } else if (this.axes.length === 3) {
        return "<Vector (" + this.x + ", " + this.y + ", " + this.z + ")>";
      }
      return "<Vector " + this.axes.length + " dimension>";
    };
    Vector.plus = function(lhs, rhs) {
      var i, newAxes, _ref;
      if (lhs.axes.length === !rhs.axes.length) {
        throw "error: cannot plus two vector which has different dimension";
      }
      newAxes = [];
      for (i = 0, _ref = lhs.axes.length; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
        newAxes.push(lhs.axes[i] + rhs.axes[i]);
      }
      return new Vector(newAxes);
    };
    Vector.minus = function(lhs, rhs) {
      var i, newAxes, _ref;
      if (lhs.axes.length === !rhs.axes.length) {
        throw "error: cannot minus two vector which has different dimension";
      }
      newAxes = [];
      for (i = 0, _ref = lhs.axes.length; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
        newAxes.push(lhs.axes[i] - rhs.axes[i]);
      }
      return new Vector(newAxes);
    };
    Vector.multiple = function(lhs, rhs) {
      var axis, newAxes, scalar, vector, _i, _len, _ref;
      if (typeof lhs === !"number" && typeof rhs === !"number") {
        throw "error: cannot multiple two vector, use scalar value for multiplication or dot or cross for vector multiplication";
      }
      if (typeof lhs === "number") {
        scalar = lhs;
        vector = rhs;
      } else {
        scalar = rhs;
        vector = lhs;
      }
      newAxes = [];
      _ref = vector.axes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        axis = _ref[_i];
        newAxes.push(axis * axis);
      }
      return new Vector(newAxes);
    };
    Vector.devide = function(lhs, rhs) {
      var axis, newAxes, scalar, vector, _i, _len, _ref;
      if (typeof lhs === !"number" && typeof rhs === !"number") {
        throw "error: cannot devide two vector, use scalar value for division";
      }
      if (typeof lhs === "number") {
        scalar = lhs;
        vector = rhs;
      } else {
        scalar = rhs;
        vector = lhs;
      }
      newAxes = [];
      _ref = vector.axes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        axis = _ref[_i];
        newAxes.push(axis / axis);
      }
      return new Vector(newAxes);
    };
    Vector.dot = function(lhs, rhs) {
      var i, product, _ref;
      if (lhs.axes.length === !rhs.axes.length) {
        throw "error: cannot dot product two vector which has different dimension";
      }
      product = 0;
      for (i = 0, _ref = lhs.axes.length; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
        product += lhs.axes[i] * rhs.axes[i];
      }
      return product;
    };
    Vector.cross = function(lhs, rhs) {
      var newX, newY, newZ;
      if (lhs.axes.length === !rhs.axes.length) {
        throw "error: cannot cross product two vector which has different dimension";
      }
      if (lhs.axes.length === 2) {
        return lhs.x * rhs.y - lhs.y * rhs.x;
      } else if (lhs.axes.length === 3) {
        newX = lhs.y * rhs.z - lhs.z * rhs.y;
        newY = lhs.z * rhs.x - lhs.x * rhs.z;
        newZ = lhs.x * rhs.y - lhs.y * rhs.x;
        return new Vector([newX, newY, newZ]);
      }
    };
    return Vector;
  })();
  unittest = function() {
    var v2, v3, v4;
    v2 = new Vector([1, 2]);
    v3 = new Vector([1, 2, 3]);
    v4 = new Vector([1, 2, 3, 4]);
    console.log(v2.toString());
    console.log(" x: " + v2.x + ", y: " + v2.y + ", z: " + v2.z);
    console.log(v3.toString());
    console.log(" x: " + v3.x + ", y: " + v3.y + ", z: " + v3.z);
    console.log(v4.toString());
    return console.log(" x: " + v4.x + ", y: " + v4.y + ", z: " + v4.z);
  };
}).call(this);
