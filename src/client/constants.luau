local players = game:GetService("Players")

local SHARED_CONSTANTS = require "@shared/constants"

local client = players.LocalPlayer
local player_gui = client:WaitForChild("PlayerGui") :: PlayerGui

return table.freeze(setmetatable({
	CLIENT = client,
	UI_CONTAINER = player_gui,
}, { __index = SHARED_CONSTANTS }))
