'use strict';
const assert = require('assert');

var newCtags = function(mount) {
  assert(mount != null);

  // ctags.js can only be called once; we need a new instance each time.
  var ctags = require('./lib/ctags.js') // noInitialRun required
  delete require.cache[require.resolve('./lib/ctags.js')]

  ctags['initFS'](mount);

  return ctags;
}

var captureOutput = function(ctags) {
  ctags['outputStream'] = null;
  ctags['print'] = function(text) {
    if (ctags['outputStream'] == null) {
      ctags['outputStream'] = text;
    } else {
      ctags['outputStream'] += '\n' + text;
    }
  };

  ctags['errorStream'] = null;
  ctags['printErr'] = function(text) {
    if (ctags['errorStream'] == null) {
      ctags['errorStream'] = text;
    } else {
      ctags['errorStream'] += '\n' + text;
    }
  }

  // If we don't soft exit, then we can't get the captured output
  ctags['exit'] = ctags['softExit'];
}

const FS_MOUNT = '/fs';
module.exports = {

  /**
   * Calls the ctags program and returns an emscripten Module object with
   * the results.
   *
   * @param {Array} args
   *   the arguments passed to ctags
   * @return {Module}
   *   Emscripten Module object
   */
  ctags: function(args) {
    var ctags = newCtags(FS_MOUNT);
    captureOutput(ctags);

		ctags['callMain'](args);
		return ctags;
  },

  /**
   * Generates tags from source files. The following args are prepended to
   * args: -f -
   *
   * @param {Array}
   *   arguments passed to ctags
   * @return {Array}
   *   an array of the elements of each tag line
   */
  generateTags: function(args) {
    var ctags = this.ctags(['-f', '-'].concat(args));
    if(ctags['exitStatus'] == 0) {
      var tags = this.parseTags(ctags['outputStream'])
      return tags;
    } else {
      throw new Error(ctags);
    }
  },

  /**
   * Parses the output of ctags breaking it into elements
   *
   * @param {String} tagString
   *   output of ctags
   * @return {Array}
   *   an array of the elements of each tag line
   */
  parseTags: function(tagString) {
    var lines = tagString.split('\n');
    var tagsList = [];
    for(var i = 0; i < lines.length; i++) {
      var line = this.parseTagLine(lines[i]);
      tagsList.push(line);
    }
    return tagsList;
  },

  /**
   * Takes a tag line and parses it, returning an array of the elements of the
   * tag line.
   *
   * @param {String} line
   *   tag line
   * @return {Array}
   *   an array of the elements of the tag line
   */
  parseTagLine: function(line) {
    var elements = line.split('\t');
    return elements;
  },

  /**
   * This acts like the command line version of ctags. All output is sent
   * to stdout and stderr. When finished, this exits node.
   *
   * @param {Array} args
   *   array of command line arguments
   */
	ctagsCommand: function(args) {
    var ctags = newCtags(FS_MOUNT);
		ctags['callMain'](args);
	}
};
