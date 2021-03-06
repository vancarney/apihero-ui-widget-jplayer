// Generated by CoffeeScript 1.9.0
var environment, fs, mincer;

fs = require('fs');

mincer = require('mincer');

environment = require('../environment');

module.exports.init = function(app) {
  app.set('views', './views');
  app.set('view engine', 'jade');
  app.use('/assets', mincer.createServer(environment));
  app.use(function(req, res, next) {
    var rh;
    if (res.locals == null) {
      res.locals = {};
    }
    res.locals.isXHR = ((rh = req.headers['x-requested-with']) != null) && rh === 'XMLHttpRequest';
    return next();
  });
  return app.get('/', function(eq, res, next) {
    return res.render('index');
  });
};
