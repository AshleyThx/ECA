local CONSTANTS = require "@client/constants"

return function()
	-- setting up react flags before requiring it
	_G.__DEV__ = if _G.__DEBUG__ == "true" then true else false

	local app = require "./app"
	local mount = require "./utils/mount"

	mount(app, {}, CONSTANTS.UI_CONTAINER)
end
