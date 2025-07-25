local process = require("@lune/process")

process.exec("wally", {
	"install",
}, { stdio = "forward" })
process.exec("argon", {
	"sourcemap",
	"--output",
	"sourcemap.json",
}, { stdio = "forward" })
process.exec("wally-package-types", {
	"--sourcemap",
	"sourcemap.json",
	"Packages",
}, { stdio = "forward" })
