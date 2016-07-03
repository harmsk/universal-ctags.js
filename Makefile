.PHONY: all clean test clean-ctags clean-libxml2 ctags-tmain ctags-units git-init git-clean FORCE
.DEFAULT_GOAL: all

all: lib/ctags.js

EMSCRIPTEN_FLAGS=-Oz

lib/ctags.js: ext/ctags/ctags.bc ext/libxml2/build/lib/libxml2.bc lib/pre.js lib/post.js
	emcc $(EMSCRIPTEN_FLAGS) --memory-init-file 0 -s EMULATE_FUNCTION_POINTER_CASTS=1 --pre-js lib/pre.js --post-js lib/post.js -o $@ ext/ctags/ctags.bc ext/libxml2/build/lib/libxml2.bc

ext/ctags/configure:
	cd ext/ctags && ./autogen.sh
	cd ext/ctags && emconfigure ./configure --enable-iconv --disable-external-sort CFLAGS="$(EMSCRIPTEN_FLAGS)" PKG_CONFIG_PATH="../libxml2/build/lib/pkgconfig/"

ext/ctags/ctags.bc: ext/ctags/configure ext/libxml2/build/lib/libxml2.bc FORCE
	cd ext/ctags && emmake make

ext/libxml2/build/lib/libxml2.bc:
	cd ext/libxml2 && autoreconf -ifv
	cd ext/libxml2 && emconfigure ./configure --with-http=no --with-ftp=no --with-python=no --with-threads=no --prefix="`pwd`/build" CFLAGS="$(EMSCRIPTEN_FLAGS)"
	cd ext/libxml2 && emmake make
	cd ext/libxml2 && emmake make install
	cp ext/libxml2/build/lib/libxml2.a $@

clean: clean-libxml2 clean-ctags

clean-libxml2:
	cd ext/libxml2 && emmake make clean
	rm -rf ext/libxml2/build

clean-ctags:
	cd ext/ctags && emmake make clean
	rm -f ext/ctags/ctags
	rm -f lib/ctags.js

test: ctags-tmain ctags-units

ctags-tmain: ext/ctags/ctags
	cd ext/ctags && emmake make tmain

ctags-units: ext/ctags/ctags
	cd ext/ctags && emmake make units

ext/ctags/ctags: lib/ctags.js
	ln -s ../../ctags $@
	touch ctags

git-init:
	git submodule update --init --recursive

git-clean:
	cd ext/libxml2 && git clean -dfx
	cd ext/ctags && git clean -dfx
