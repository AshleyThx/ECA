local SHARED_CONSTANTS = require "@shared/constants"

return table.freeze(setmetatable({}, { __index = SHARED_CONSTANTS }))
