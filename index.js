/**
 * index.js
 * 
 * main entry point to NPM 
 * exports main module which should be located in lib and be a file named the same name of the package
 * ex: apihero-ui-mymodule should have lib/apihero-ui-mymodule.js in lib
 * 
 * exports an array of paths which can be defined in package.json for apihero module loaders to locate files they may be interested in.
 * refer to the documentation for apihero module for specifics
 */
var path = require('path');
var pkg	 = require("./package.json");

//-- tests to ensure package.name is set on package.json
if ((pkg.hasOwnProperty('name') && pkg.name != null && pkg.name.length) === false) {
	throw ("package.name was undefined on package @ " + __dirname);
	process.exit(1);
}

//-- attempts to require module. Note the manual prepending of the ./, this is due to join stripping it out
module.exports = require( '.' + path.sep + path.join('lib', pkg.name) );

//-- adds paths property onto exports with whatever files have been declared in the package config
module.exports.config = pkg.hasOwnProperty('moduleConfig') ? pkg.moduleConfig : {};