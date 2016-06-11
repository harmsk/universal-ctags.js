var ctags = require("./universal-ctags.js");

out = ctags.ctags(["--help"]);

out = ctags.ctags(["--version -aklaj"]);
console.log(out['errorStream']);

out = ctags.ctags(["--version"]);
console.log(out['outputStream']);
console.log(out['exitStatus']);

out = ctags.ctags(["-f", "-", "main/main.c"]);
console.log(out['exitStatus']);
console.log(out['errorStream']);
console.log(out['outputStream']);

out = ctags.ctags(["--verbose", "-f", "-", "main/main.c"]);
console.log(out['exitStatus']);
console.log(out['errorStream']);
console.log(out['outputStream']);

out = ctags.ctags(["-f", "-", "/home/harmsk/SparkleShare/harmsk-documents/assessment/traditional/paper/assessment-paper.tex"]);
console.log(out['exitStatus']);
console.log(out['errorStream']);
console.log(out['outputStream']);
