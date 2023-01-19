local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function unlock()
    gamepush.achievements.unlock({ tag = "my_achiv" }, function(result)
        utils.to_log("Achievements unlock:", result)
    end)
end

local function open()
    gamepush.achievements.open(function()
        utils.to_log("Achievements open")
    end)
end

local function fetch()
    gamepush.achievements.fetch(function(achievements)
        utils.to_log("Achievements fetch:", achievements)
    end)
end

local M = {
    { name = "Unlock", callback = unlock },
    { name = "Open", callback = open },
    { name = "Fetch", callback = fetch },
}

gamepush.achievements.callbacks.unlock = function(achievement)
    utils.to_console("achievement unlock:", achievement)
end
gamepush.achievements.callbacks.error_unlock = function(error)
    utils.to_console("achievement unlock error:", error)
end
gamepush.achievements.callbacks.open = function()
    utils.to_console("open achievements")
end
gamepush.achievements.callbacks.close = function()
    utils.to_console("close achievements")
end
gamepush.achievements.callbacks.fetch = function(result)
    utils.to_console("fetch achievements:", result)
end
gamepush.achievements.callbacks.error_fetch = function(error)
    utils.to_console("fetch achievements error:", error)
end

return M