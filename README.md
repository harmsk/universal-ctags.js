universal-ctags.js
==================

A [node.js](https://nodejs.org/) package of
[universal ctags](https://github.com/universal-ctags/ctags) compiled to
Javascript with [emscripten](https://kripken.github.io/emscripten-site/).

**Maintainer**: Kyle J. Harms <kyle.harms@gmail.com>

## Version

Upstream has not produced a versioned release. When a versioned release
does happen, this package will try to follow the same version numbers. Until
then, this package will grab snapshot's of upstream's master branch.

universal-ctags.js version | universal ctags git snapshot
-------------------------- | ----------------------------
0.0.1                      | 082b085e549d0eb01bbfb2eea27bf265a5faf3b3

## Usage

A small wrapper is provided for calling the [ctags](https://ctags.io/)
program.

The syntax for all calls to universal-ctags.js is the same as the command line
[syntax](http://docs.ctags.io/en/latest/news.html#new-options) to ctags program.

```javascript
var ctags = require("universal-ctags");

/* return 2D array of tags for main.c */
var tags = ctags.generateTags(["main.c"]);

/* pass options to ctags */
var tags = ctags.generateTags(["--fields=KsS", "main.c"]);

/* write tags to file */
var EmscriptenModule = ctags.ctags(["-o", "out.tags", "main.c"]);

/* check that is exited successfully */
if(EmscriptenModule['exitStatus'] != 0) {
  console.log(EmscriptenModule['errorStream']);
}

/* behave exactly like the command line version of ctags */
/* this exits when finished */
ctags.ctagsCommand(["-o", "-", "main.c"])
```

## Building

You will need a working installation of
[emscripten](https://kripken.github.io/emscripten-site/).

```sh
# initialize git submodules
git submodule init
git submodule update
# -- or --
make git-init
```

```sh
# compile ctags to Javascript
make

# run ctags' tests
make test
```

## Known issues

Help resolving these issues is welcome. Some of the issues are not resolved
because the problem hasn't been identified (Unknown). Other issues, the work
hasn't yet started (Incomplete).

* Currently the ctags' `units` and `tmain` test suites fail.
 * Any output written to stdout (i.e. `-o -`) does not work with special
   characters. This affects calls to `ctags.generateTags([])`. This seems to be
   an issue with how emscripten coverts text written to stdout to a Javascript
   string. This works fine when writing to a file. (Unknown)
 * All of the external tag generators (`xcmd`) do not yet work. This affects
   CoffeeScript tags with the `coffeetags` program. (Incomplete)
* Windows support is unknown. Emscripten runs in a UNIX-like
  environment. It is not know if this affects tag generation on Windows. The
  paths in the tag files may need to be converted to Windows style paths.

## Contributions

Pull requests welcome.

## License

The node.js package is licensed under the MIT license.

universal ctags (lib/ctags.js) is licensed under the GPL-2.0.
