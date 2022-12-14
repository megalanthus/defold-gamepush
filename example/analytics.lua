local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function hit()
    local url = "/my-page/example?query=1"
    utils.to_log("Analytics hit: " .. url)
    gamepush.analytics.hit(url)
end

local function goal()
    local event = "LEVEL_START"
    local level = 15
    utils.to_log("Analytics goal: " .. event .. " " .. level)
    gamepush.analytics.goal(event, level)
end

local M = {
    { name = "Hit", callback = hit },
    { name = "Goal", callback = goal },
}

return M