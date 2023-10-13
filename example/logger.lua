local gamepush = require("gamepush.gamepush")

local function info()
    gamepush.logger.info("Information", "count", 100)
end

local function warn()
    gamepush.logger.warn("Warning", "count", 100)
end

local function err()
    gamepush.logger.error("Error", "count", 100)
end

local function log()
    gamepush.logger.log("Log", "count", 100)
end

local M = {
    { name = "Information", callback = info },
    { name = "Warning", callback = warn },
    { name = "Error", callback = err },
    { name = "Log", callback = log }
}

return M