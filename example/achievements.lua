local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function groups_list()
    utils.to_log("Groups list:", gamepush.achievements.groups_list())
end

local function list()
    utils.to_log("List:", gamepush.achievements.list())
end

local function unlocked_list()
    utils.to_log("Unlocked list:", gamepush.achievements.unlocked_list())
end

local function unlock()
    gamepush.achievements.unlock({ tag = "my_achiv" }, function(result)
        utils.to_log("Achievements unlock:", result)
    end)
end

local function set_progress()
    gamepush.achievements.set_progress({ tag = "my_achiv", progress = 25 }, function(result)
        utils.to_log("Achievements set progress:", result)
    end)
end

local function has()
    utils.to_log(gamepush.achievements.has("my_achiv"))
end

local function get_progress()
    utils.to_log(gamepush.achievements.get_progress(1960))
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
    { name = "Groups list", callback = groups_list },
    { name = "List", callback = list },
    { name = "Unlocked list", callback = unlocked_list },
    { name = "Unlock", callback = unlock },
    { name = "Set progress", callback = set_progress },
    { name = "Has", callback = has },
    { name = "Get progress", callback = get_progress },
    { name = "Open", callback = open },
    { name = "Fetch", callback = fetch },
}

gamepush.achievements.callbacks.unlock = function(achievement)
    utils.to_console("achievement unlock:", achievement)
end
gamepush.achievements.callbacks.error_unlock = function(error)
    utils.to_console("achievement unlock error:", error)
end
gamepush.achievements.callbacks.progress = function(achievement)
    utils.to_console("achievement progress:", achievement)
end
gamepush.achievements.callbacks.error_progress = function(error)
    utils.to_console("achievement progress error:", error)
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