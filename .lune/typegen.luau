local process = require("@lune/process")

process.exec("argon", {
	"sourcemap",
	"--output",
	"sourcemap.json",
})

process.exec("wally-package-types", {
	"--sourcemap",
	"sourcemap.json",
	"Packages",
})
