local process = require("@lune/process")
local fs = require("@lune/fs")

if fs.isDir("dev") then fs.removeDir("dev") end
fs.copy("src", "dev")

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

process.exec("darklua", {
	"process",
	"src",
	"dev",
}, { env = {
	__DEBUG__ = "true",
} }, { stdio = "forward" })

process.exec("argon", {
	"build",
	"dev.project.json",
	"--output",
	"build/build.rbxl",
}, { stdio = "forward" })
