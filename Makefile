EMSCRIPTEN_FLAGS=-Oz

.PHONY: all
.DEFAULT_GOAL: all ctags libxml2 clean
.ONESHELL:

all: ctags

# TODO
lib/ctags.js: libxml2/build/lib/libxml2.bc lib/pre.js lib/post.js

ctags: ctags/ctags

# TODO: let's do the command version of this so we don't have to have all this stuff...
define CTAGS_SCRIPT
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
endef

ctags/ctags: lib/ctags.js
	echo "$(CTAGS_SCRIPT)" > $@
	chmod 775 $@

# TODO: conifgure target for both ctags and libxml2

lib/ctags.js: ctags/ctags.bc libxml2/build/lib/libxml2.bc lib/pre.js lib/post.js
	emcc $(EMSCRIPTEN_FLAGS) --memory-init-file 0 -s EMULATE_FUNCTION_POINTER_CASTS=1 --pre-js lib/pre.js --post-js lib/post.js -o $@ ctags/ctags.bc libxml2/build/lib/libxml2.bc

ctags/ctags.bc: libxml2/build/lib/libxml2.bc
ifeq (, $(shell which emcc))
	$(error "No emcc found, install emscripten and source emsdk_env.sh")
endif
	cd ctags && autoreconf -vfi
	cd ctags && emconfigure ./configure --disable-external-sort CFLAGS="$(EMSCRIPTEN_FLAGS)" PKG_CONFIG_PATH="../libxml2/build/lib/pkgconfig/"
	cd ctags && emmake make

libxml2: libxml2/build/lib/libxml2.bc

libxml2/build/lib/libxml2.bc: libxml2/build/lib/libxml2.a
	cp libxml2/build/lib/libxml2.a $@

libxml2/build/lib/libxml2.a:
ifeq (, $(shell which emcc))
	$(error "No emcc found, install emscripten and source emsdk_env.sh")
endif
	cd libxml2 && autoreconf -ifv
	cd libxml2 && emconfigure ./configure --with-http=no --with-ftp=no --with-python=no --with-threads=no --prefix="`pwd`/build" CFLAGS="$(EMSCRIPTEN_FLAGS)"
	cd libxml2 && emmake make
	cd libxml2 && emmake make install
