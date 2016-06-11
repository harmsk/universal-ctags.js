Module['exitStatus'] = null;

function softExit(status, implicit) {
	Module['exitStatus'] = status;

  if (Module['noExitRuntime']) {
  } else {
    ABORT = true;
    EXITSTATUS = status;
    STACKTOP = initialStackTop;

    exitRuntime();

    if (Module['onExit']) Module['onExit'](status);
  }

  // if we reach here, we must throw an exception to halt the current execution
  throw new ExitStatus(status);
}
Module['softExit'] = Module.softExit = softExit;

function initFS(mount) {
		Module['fileSystemMount'] = Module.fileSystemMount = mount;

		var path = require('path');
		var dir = path.resolve('.');

		FS.mkdir(mount);
		FS.mount(NODEFS, { root: '/' }, mount);
		FS.chdir(mount + dir);
}
Module['initFS'] = Module.initFS = initFS;
