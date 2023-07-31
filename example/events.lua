local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local event_tag = "my_event"

local function join()
    gamepush.events.join({ tag = event_tag }, function(result)
        utils.to_log("Join event:", result)
    end)
end

local function list()
    utils.to_log("List events:", gamepush.events.list())
end

local function active_list()
    utils.to_log("Active list events:", gamepush.events.active_list())
end

local function get_event()
    utils.to_log("Get event:", gamepush.events.get_event(event_tag))
end

local function has()
    utils.to_log("Event has:", gamepush.events.has(event_tag))
end

local function is_joined()
    utils.to_log("Is joined:", gamepush.events.is_joined(event_tag))
end

local M = {
    { name = "Join", callback = join },
    { name = "List", callback = list },
    { name = "Active list", callback = active_list },
    { name = "Get event", callback = get_event },
    { name = "Has", callback = has },
    { name = "Is joined", callback = is_joined },
}

gamepush.events.callbacks.join = function(reward)
    utils.to_console("Join event:", reward)
end
gamepush.events.callbacks.error_join = function(error)
    utils.to_console("Join event error:", error)
end

return M