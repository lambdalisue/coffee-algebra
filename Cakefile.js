(function() {
  var build, exec, fs, header, path, print, spawn, _ref;
  fs = require('fs');
  path = require('path');
  print = require('sys').print;
  _ref = require('child_process'), spawn = _ref.spawn, exec = _ref.exec;
  header = "/**\n * management tool for coffee-script project of node\n * http://github.com/lambdalisue/coffee-node-skeleton\n *\n * Copyright 2011, Alisue\n * Released under the MIT License\n */";
  build = function(watch, callback) {
    var coffee, options;
    if (typeof watch === 'function') {
      callback = watch;
      watch = false;
    }
    options = ['-c', '-o', 'lib', 'src'];
    if (watch) {
      options.unshift('-w');
    }
    coffee = spawn('coffee', options);
    coffee.stdout.on('data', function(data) {
      return print(data.toString());
    });
    coffee.stderr.on('data', function(data) {
      return print(data.toString());
    });
    return coffee.on('exit', function(status) {
      if (status === 0) {
        return typeof callback === "function" ? callback() : void 0;
      }
    });
  };
  task('docs', 'Generate annotated source code with Docco', function() {
    return fs.readdir('src', function(err, contents) {
      var docco, file, options;
      options = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = contents.length; _i < _len; _i++) {
          file = contents[_i];
          if (/\.coffee$/.test(file)) {
            _results.push("src/" + file);
          }
        }
        return _results;
      })();
      docco = spawn('docco', options);
      docco.stdout.on('data', function(data) {
        return print(data.toString());
      });
      docco.stderr.on('data', function(data) {
        return print(data.toString());
      });
      return docco.on('exit', function(status) {
        if (status === 0) {
          return typeof callback === "function" ? callback() : void 0;
        }
      });
    });
  });
  task('build', 'Compile CoffeeScript source files', function() {
    return build();
  });
  task('watch', 'Recompile CoffeeScript source files when modified', function() {
    return build(true);
  });
  task('test', 'Run the test suite', function() {
    return build(function() {
      var nodeunit, options;
      options = ['tests'];
      nodeunit = spawn('nodeunit', options);
      nodeunit.stdout.on('data', function(data) {
        return print(data.toString());
      });
      nodeunit.stderr.on('data', function(data) {
        return print(data.toString());
      });
      return nodeunit.on('exit', function(status) {
        if (status === 0) {
          return typeof callback === "function" ? callback() : void 0;
        }
      });
    });
  });
}).call(this);
