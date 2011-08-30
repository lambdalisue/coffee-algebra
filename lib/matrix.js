(function() {
  var AccessorPropertyObject, Matrix, Vector, flatten, max, pad, sum;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __slice = Array.prototype.slice;
  AccessorPropertyObject = (function() {
    function AccessorPropertyObject() {}
    AccessorPropertyObject.get = function(propertyName, func) {
      return Object.defineProperty(this.prototype, propertyName, {
        configurable: true,
        enumerable: true,
        get: func
      });
    };
    AccessorPropertyObject.set = function(propertyName, func) {
      return Object.defineProperty(this.prototype, propertyName, {
        configurable: true,
        enumerable: true,
        set: func
      });
    };
    return AccessorPropertyObject;
  })();
  sum = function(a) {
    if (a.length === 0) {
      return 0;
    }
    return a.reduce(function(lhs, rhs) {
      return lhs + rhs;
    });
  };
  max = function(a) {
    if (a.length === 0) {
      return 0;
    }
    return a.reduce(function(lhs, rhs) {
      return Math.max(lhs, rhs);
    });
  };
  flatten = function(a) {
    if (a.length === 0) {
      return [];
    }
    return a.reduce(function(lhs, rhs) {
      return lhs.concat(rhs);
    });
  };
  pad = function(str, n, letter) {
    var leading, offset;
    if (letter == null) {
      letter = 0;
    }
    offset = n - str.toString().length;
    if (offset > 0) {
      leading = Array(offset + 1).join(letter);
      return "" + leading + str;
    } else {
      return str;
    }
  };
  exports.Matrix = Matrix = (function() {
    __extends(Matrix, AccessorPropertyObject);
    function Matrix(entries) {
      if (entries.length === 1) {
        throw new Error("it is not matrix but scalar");
      }
      this._entries = entries;
    }
    Matrix.get('entries', function() {
      return this._entries;
    });
    Matrix.get('m', function() {
      return this.entries.length;
    });
    Matrix.get('n', function() {
      return this.entries[0].length;
    });
    Matrix.prototype.get = function(i, j, def) {
      if (def == null) {
        def = null;
      }
      if ((0 <= i && i < this.m) && (0 <= j && j < this.n)) {
        return this.entries[i][j];
      } else if (def != null) {
        return def;
      } else {
        throw new Error("error: (" + i + ", " + j + ") is out of range.");
      }
    };
    Matrix.prototype.set = function(i, j, value) {
      if ((0 <= i && i < this.m) && (0 <= j && j < this.n)) {
        return this.entries[i][j] = value;
      } else {
        throw new Error("error: (" + i + ", " + j + ") is out of range.");
      }
    };
    Matrix.prototype.row = function(i) {
      return this.entries[i];
    };
    Matrix.prototype.column = function(j) {
      var row, _i, _len, _ref, _results;
      _ref = this.entries;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        row = _ref[_i];
        _results.push(row[j]);
      }
      return _results;
    };
    Matrix.prototype.toArray = function() {
      return flatten(this.entries);
    };
    Matrix.prototype.toString = function() {
      var e, longest, prow, row, rows, _i, _len, _ref;
      longest = (max(this.toArray())).toString().length;
      rows = [];
      _ref = this.entries;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        row = _ref[_i];
        prow = (function() {
          var _j, _len2, _results;
          _results = [];
          for (_j = 0, _len2 = row.length; _j < _len2; _j++) {
            e = row[_j];
            _results.push(pad(e, longest, ' '));
          }
          return _results;
        })();
        rows.push("| " + (prow.join(' ')) + " |");
      }
      return rows.join('\n');
    };
    Matrix.prototype.isSquare = function() {
      return this.m === this.n;
    };
    Matrix.prototype.isDiagonal = function() {
      var i, j, _ref, _ref2;
      if (!this.isSquare()) {
        return false;
      }
      for (i = 0, _ref = this.m; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
        for (j = 0, _ref2 = this.n; 0 <= _ref2 ? j < _ref2 : j > _ref2; 0 <= _ref2 ? j++ : j--) {
          if (i === j) {
            continue;
          }
          if (this.get(i, j) !== 0) {
            return false;
          }
        }
      }
      return true;
    };
    Matrix.prototype.isIdentity = function() {
      var i, _ref;
      if (!(this.isSquare() && this.isDiagonal())) {
        return false;
      }
      for (i = 0, _ref = this.m; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
        if (this.get(i, i) !== 1) {
          return false;
        }
      }
      return true;
    };
    Matrix.prototype.isSymmetric = function() {
      var transpose;
      transpose = this.transpose();
      return this.compare(transpose);
    };
    Matrix.prototype.isSkewSymmetric = function() {
      var transpose;
      transpose = this.transpose();
      return this.compare(transpose.multiple(-1));
    };
    Matrix.prototype.compare = function(matrix) {
      return Matrix.compare(this, matrix);
    };
    Matrix.prototype.plus = function(rhs) {
      return Matrix.plus(this, rhs);
    };
    Matrix.prototype.minus = function(rhs) {
      return Matrix.minus(this, rhs);
    };
    Matrix.prototype.multiple = function(rhs) {
      return Matrix.multiple(this, rhs);
    };
    Matrix.prototype.devide = function(rhs) {
      return Matrix.devide(this, rhs);
    };
    Matrix.prototype.power = function(k) {
      return Matrix.power(this, k);
    };
    Matrix.prototype.resize = function(m, n) {
      return Matrix.resize(this, m, n);
    };
    Matrix.prototype.trace = function() {
      return Matrix.trace(this);
    };
    Matrix.prototype.transpose = function() {
      return Matrix.transpose(this);
    };
    Matrix.compare = function(lhs, rhs) {
      var i, j, _ref, _ref2;
      if (lhs.m !== rhs.m || lhs.n !== rhs.n) {
        return false;
      }
      for (i = 0, _ref = lhs.m; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
        for (j = 0, _ref2 = lhs.n; 0 <= _ref2 ? j < _ref2 : j > _ref2; 0 <= _ref2 ? j++ : j--) {
          if (lhs.get(i, j) !== rhs.get(i, j)) {
            return false;
          }
        }
      }
      return true;
    };
    Matrix.plus = function(lhs, rhs) {
      var i, j, newMatrix, row, _ref, _ref2;
      if (!(lhs instanceof Matrix) || !(rhs instanceof Matrix)) {
        throw new Error("error: lhs and rhs must be an instance of Matrix");
      } else if (lhs.m !== rhs.m || lhs.n !== rhs.n) {
        throw new Error("error: cannot plus two matrix which has different type");
      }
      newMatrix = [];
      for (i = 0, _ref = lhs.m; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
        row = [];
        for (j = 0, _ref2 = lhs.n; 0 <= _ref2 ? j < _ref2 : j > _ref2; 0 <= _ref2 ? j++ : j--) {
          row.push(lhs.get(i, j) + rhs.get(i, j));
        }
        newMatrix.push(row);
      }
      return new Matrix(newMatrix);
    };
    Matrix.minus = function(lhs, rhs) {
      var i, j, newMatrix, row, _ref, _ref2;
      if (!(lhs instanceof Matrix) || !(rhs instanceof Matrix)) {
        throw new Error("error: lhs and rhs must be an instance of Matrix");
      }
      if (lhs.m !== rhs.m || lhs.n !== rhs.n) {
        throw new Error("error: cannot minus two matrix which has different type");
      }
      newMatrix = [];
      for (i = 0, _ref = lhs.m; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
        row = [];
        for (j = 0, _ref2 = lhs.n; 0 <= _ref2 ? j < _ref2 : j > _ref2; 0 <= _ref2 ? j++ : j--) {
          row.push(lhs.get(i, j) - rhs.get(i, j));
        }
        newMatrix.push(row);
      }
      return new Matrix(newMatrix);
    };
    Matrix.multipleScalar = function(lhs, rhs) {
      var i, j, matrix, newMatrix, row, scalar, _ref, _ref2;
      if (lhs instanceof Matrix && typeof rhs === "number") {
        matrix = lhs;
        scalar = rhs;
      } else if (rhs instanceof Matrix && typeof lhs === "number") {
        matrix = rhs;
        scalar = lhs;
      } else {
        throw new Error("error: unknown object has passed");
      }
      newMatrix = [];
      for (i = 0, _ref = matrix.m; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
        row = [];
        for (j = 0, _ref2 = matrix.n; 0 <= _ref2 ? j < _ref2 : j > _ref2; 0 <= _ref2 ? j++ : j--) {
          row.push(matrix.get(i, j) * scalar);
        }
        newMatrix.push(row);
      }
      return new Matrix(newMatrix);
    };
    Matrix.multipleMatrix = function(lhs, rhs) {
      var i, j, k, newMatrix, row, _ref, _ref2;
      if (!(lhs instanceof Matrix) || !(rhs instanceof Matrix)) {
        throw new Error("error: lhs and rhs must be an instance of Matrix");
      }
      if (lhs.n !== rhs.m) {
        throw new Error("error: cannot multiple this two matrix. only matrix pair of M x N and N x L is defined");
      }
      newMatrix = [];
      for (i = 0, _ref = lhs.m; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
        row = [];
        for (j = 0, _ref2 = rhs.n; 0 <= _ref2 ? j < _ref2 : j > _ref2; 0 <= _ref2 ? j++ : j--) {
          row.push(sum((function() {
            var _ref3, _results;
            _results = [];
            for (k = 0, _ref3 = lhs.n; 0 <= _ref3 ? k < _ref3 : k > _ref3; 0 <= _ref3 ? k++ : k--) {
              _results.push(lhs.get(i, k) * rhs.get(k, j));
            }
            return _results;
          })()));
        }
        newMatrix.push(row);
      }
      return new Matrix(newMatrix);
    };
    Matrix.multiple = function(lhs, rhs) {
      if (typeof lhs !== "number" && typeof rhs !== "number") {
        return this.multipleMatrix(lhs, rhs);
      }
      return this.multipleScalar(lhs, rhs);
    };
    Matrix.devide = function(lhs, rhs) {
      var i, j, newMatrix, row, _ref, _ref2;
      if (lhs instanceof Matrix && rhs instanceof Matrix) {
        throw new Error("error: devision of two matrix is not defined");
      }
      if (typeof rhs !== "number") {
        throw new Error("error: you cannot devide scalar with matrix");
      }
      newMatrix = [];
      for (i = 0, _ref = lhs.m; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
        row = [];
        for (j = 0, _ref2 = lhs.n; 0 <= _ref2 ? j < _ref2 : j > _ref2; 0 <= _ref2 ? j++ : j--) {
          row.push(lhs.get(i, j) / rhs);
        }
        newMatrix.push(row);
      }
      return new Matrix(newMatrix);
    };
    Matrix.power = function(matrix, k) {
      if (!matrix.isSquare()) {
        throw new Error("error: a power of matrix is not defined except square matrix");
      }
      switch (k) {
        case 0:
          return Matrix.identify(matrix.m);
        case 1:
          return matrix;
        case 2:
          return matrix.multiple(matrix);
        default:
          return matrix.multiple(matrix.power(k - 1));
      }
    };
    Matrix.resize = function(matrix, m, n) {
      var i, j, newMatrix, row;
      newMatrix = [];
      for (i = 0; 0 <= m ? i < m : i > m; 0 <= m ? i++ : i--) {
        row = [];
        for (j = 0; 0 <= n ? j < n : j > n; 0 <= n ? j++ : j--) {
          row.push(matrix.get(i, j, 0));
        }
        newMatrix.push(row);
      }
      return new Matrix(newMatrix);
    };
    Matrix.trace = function(matrix) {
      var i;
      if (!matrix.isSquare()) {
        throw new Error("error: trace of non square matrix is not defined");
      }
      return sum((function() {
        var _ref, _results;
        _results = [];
        for (i = 0, _ref = matrix.m; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
          _results.push(matrix.get(i, i));
        }
        return _results;
      })());
    };
    Matrix.transpose = function(matrix) {
      var i, j, newMatrix, row, _ref, _ref2;
      newMatrix = [];
      for (j = 0, _ref = matrix.n; 0 <= _ref ? j < _ref : j > _ref; 0 <= _ref ? j++ : j--) {
        row = [];
        for (i = 0, _ref2 = matrix.m; 0 <= _ref2 ? i < _ref2 : i > _ref2; 0 <= _ref2 ? i++ : i--) {
          row.push(matrix.get(i, j));
        }
        newMatrix.push(row);
      }
      return new Matrix(newMatrix);
    };
    Matrix.zero = function(m, n) {
      var i, j, newMatrix, row;
      newMatrix = [];
      for (j = 0; 0 <= m ? j < m : j > m; 0 <= m ? j++ : j--) {
        row = [];
        for (i = 0; 0 <= n ? i < n : i > n; 0 <= n ? i++ : i--) {
          row.push(0);
        }
        newMatrix.push(row);
      }
      return new Matrix(newMatrix);
    };
    Matrix.identify = function(m) {
      var i, matrix;
      matrix = Matrix.zero(m, m);
      for (i = 0; 0 <= m ? i < m : i > m; 0 <= m ? i++ : i--) {
        matrix.set(i, i, 1);
      }
      return matrix;
    };
    return Matrix;
  })();
  exports.Vector = Vector = (function() {
    __extends(Vector, Matrix);
    function Vector() {
      var entries;
      entries = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (entries.length === 1 && entries instanceof Array) {
        this._entries = [entries[0]];
      } else {
        this._entries = [entries];
      }
    }
    Vector.get('dimension', function() {
      return this.m;
    });
    Vector.get('x', function() {
      if (this.dimension <= 3) {
        return this.get(0, 0);
      }
    });
    Vector.get('y', function() {
      if (this.dimension <= 3) {
        return this.get(0, 1);
      }
    });
    Vector.get('z', function() {
      if (this.dimension === 3) {
        return this.get(0, 2);
      }
    });
    return Vector;
  })();
}).call(this);
