EMSCRIPTEN_FLAGS=-Oz

.PHONY: all
.DEFAULT_GOAL: all ctags libxml2 clean

all: ctags

ctags: ctags/ctags ctags/readtags

# TODO: let's do the command version of this so we don't have to have all this stuff...
# TODO: conifgure target for both ctags and libxml2

lib/ctags.js: ctags/ctags.bc ext/libxml2/build/lib/libxml2.bc lib/pre.js lib/post.js
	emcc $(EMSCRIPTEN_FLAGS) --memory-init-file 0 -s EMULATE_FUNCTION_POINTER_CASTS=1 --pre-js lib/pre.js --post-js lib/post.js -o $@ ctags/ctags.bc ext/libxml2/build/lib/libxml2.bc

ctags/ctags.bc: ext/libxml2/build/lib/libxml2.bc
ifeq (, $(shell which emcc))
	$(error "No emcc found, install emscripten and source emsdk_env.sh")
endif
	cd ctags && ./autogen.sh
	cd ctags && emconfigure ./configure --disable-external-sort CFLAGS="$(EMSCRIPTEN_FLAGS)" PKG_CONFIG_PATH="../ext/libxml2/build/lib/pkgconfig/"
	cd ctags && emmake make

ctags/ctags: lib/ctags.js
	ln -s ../ctags.sh $@

lib/readtags.js: ctags/ctags.bc lib/pre.js lib/post.js
	emcc $(EMSCRIPTEN_FLAGS) --memory-init-file 0 -s EMULATE_FUNCTION_POINTER_CASTS=1 --pre-js lib/pre.js --post-js lib/post.js -o $@ ctags/readtags.bc

ctags/readtags: lib/readtags.js
	ln -s ../readtags.sh $@

libxml2: ext/libxml2/build/lib/libxml2.bc

ext/libxml2/build/lib/libxml2.bc: ext/libxml2/build/lib/libxml2.a
	cp ext/libxml2/build/lib/libxml2.a $@

ext/libxml2/build/lib/libxml2.a:
ifeq (, $(shell which emcc))
	$(error "No emcc found, install emscripten and source emsdk_env.sh")
endif
	cd libxml2 && autoreconf -ifv
	cd libxml2 && emconfigure ./configure --with-http=no --with-ftp=no --with-python=no --with-threads=no --prefix="`pwd`/build" CFLAGS="$(EMSCRIPTEN_FLAGS)"
	cd libxml2 && emmake make
	cd libxml2 && emmake make install

# TODO: readtags
