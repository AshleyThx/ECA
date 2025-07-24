if not game:IsLoaded() then game.Loaded:Wait() end

local start_t = os.clock()

-- setting up logger before other modules use it
local log = require "@shared/log"
log.setup({
	roblox_console_log = true,
	extended_timestamp = if _G.__DEBUG__ == "true" then true else false,
	max_log_length = 800,
	drop_debug_logs = false,
})
log.Debug("Logger configured")

log.Debug("Mounting app")
require "./ui/start"()
log.Debug("App mounted")

local start_dt = os.clock() - start_t
log.Info(("Client started in %.3fms!"):format(start_dt * 1000))
