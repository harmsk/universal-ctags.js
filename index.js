'use strict';

var FS_MOUNT = '/fs';

module.exports = {
	ctags: function(args) {
		// ctags.js can only be called once; we need a new instance each time.
		var Module = require('./lib/ctags.js') // noInitialRun required
		delete require.cache[require.resolve('./lib/ctags.js')]

		Module['initFS'](FS_MOUNT);

		Module['outputStream'] = null;
		Module['print'] = function(text) {
			if (Module['outputStream'] == null) {
				Module['outputStream'] = text;
			} else {
				Module['outputStream'] += '\n' + text;
			}
		};

		Module['errorStream'] = null;
		Module['printErr'] = function(text) {
			if (Module['errorStream'] == null) {
				Module['errorStream'] = text;
			} else {
				Module['errorStream'] += '\n' + text;
			}
		}

		Module['exit'] = Module['softExit'];

		Module['callMain'](args);
		return Module;
	}
};
