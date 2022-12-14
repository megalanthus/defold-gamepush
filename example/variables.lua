local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function fetch()
    gamepush.variables.fetch(function()
        utils.to_log("variables fetch")
    end)
end

local function get()
    utils.to_log("variables get 'var': " .. tostring(gamepush.variables.get("var")))
end

local function has()
    utils.to_log("variables has 'var': " .. tostring(gamepush.variables.has("var")))
end

local function type()
    utils.to_log("variables type 'var': " .. tostring(gamepush.variables.type("var")))
end

local M = {
    { name = "Fetch", callback = fetch },
    { name = "Get", callback = get },
    { name = "Has", callback = has },
    { name = "Type", callback = type },
}

gamepush.variables.callbacks.fetch = function()
    utils.to_console("Variables fetch")
end
gamepush.variables.callbacks.error = function(error)
    utils.to_console("Variables fetch error:", error)
end

return M