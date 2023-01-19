local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function open()
    gamepush.games_collections.open({ tag = "ALL" }, function()
        utils.to_log("Games collections open")
    end)
end

local function fetch()
    gamepush.games_collections.fetch({ tag = "ALL" }, function(result)
        utils.to_log("Games collections fetch:", result)
    end)
end

local M = {
    { name = "Open", callback = open },
    { name = "Fetch", callback = fetch },
}

gamepush.games_collections.callbacks.open = function()
    utils.to_console("Games collections open")
end
gamepush.games_collections.callbacks.close = function()
    utils.to_console("Games collections close")
end
gamepush.games_collections.callbacks.fetch = function(result)
    utils.to_console("Games collections fetch", result)
end
gamepush.games_collections.callbacks.error_fetch = function(error)
    utils.to_console("Games collections fetch error:", error)
end

return M