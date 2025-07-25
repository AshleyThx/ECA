local process = require("@lune/process")
local fs = require("@lune/fs")

if fs.isDir("dev") then fs.removeDir("dev") end
fs.copy("src", "dev")

process.exec("wally", {
	"install",
}, { stdio = "forward" })
process.create("argon", {
	"sourcemap",
	"--output",
	"sourcemap.json",
	"--watch",
})
process.exec("wally-package-types", {
	"--sourcemap",
	"sourcemap.json",
	"Packages",
}, { stdio = "forward" })

process.create("darklua", {
	"process",
	"src",
	"dev",
	"--watch",
}, { env = {
	__DEBUG__ = "true",
} })
process.exec("argon", {
	"serve",
	"dev.project.json",
}, { stdio = "forward" })
