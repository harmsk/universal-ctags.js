var Module = {};
Module.noInitialRun = true;

Module['preRun'] = new Array();
Module['preRun'].push( function() {
  ENV.HOME = process.env.HOME;
  ENV.HOMEPATH = process.env.HOMEPATH;
  ENV.HOMEDRIVE = process.env.HOMEDRIVE;
  ENV.CTAGS_DATA_PATH_ENVIRONMENT = process.env.CTAGS_DATA_PATH_ENVIRONMENT;
  ENV.CTAGS_LIBEXEC_PATH_ENVIRONMENT = process.env.CTAGS_LIBEXEC_PATH_ENVIRONMENT;
  // Use emscripten's TMP dir
} );
