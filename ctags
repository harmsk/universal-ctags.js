#!/usr/bin/env node

var ctags = require('./universal-ctags.js');
out = ctags.ctags(process.argv.slice(2));
if (out['errorStream'] != null ) {
  console.error(out['errorStream']);
} \
if (out['outputStream'] != null ) {
  console.log(out['outputStream']);
}
process.exit(out['exitStatus']);
