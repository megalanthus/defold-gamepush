local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local trigger_id = "my_trigger"

local function claim()
    gamepush.triggers.claim({ id = trigger_id }, function(result)
        utils.to_log("Claim:", result)
    end)
end

local function list()
    utils.to_log("List triggers:", gamepush.triggers.list())
end

local function activated_list()
    utils.to_log("List activated triggers:", gamepush.triggers.activated_list())
end

local function get_trigger()
    utils.to_log("Get trigger:", gamepush.triggers.get_trigger(trigger_id))
end

local function is_activated()
    utils.to_log("Is activated:", gamepush.triggers.is_activated(trigger_id))
end

local function is_claimed()
    utils.to_log("Is claimed:", gamepush.triggers.is_claimed(trigger_id))
end

local M = {
    { name = "Claim", callback = claim },
    { name = "List", callback = list },
    { name = "Activated list", callback = activated_list },
    { name = "Get trigger", callback = get_trigger },
    { name = "Is activated", callback = is_activated },
    { name = "Is claimed", callback = is_claimed },
}

gamepush.triggers.callbacks.activate = function(trigger)
    utils.to_console("Trigger activate:", trigger)
end
gamepush.triggers.callbacks.claim = function(trigger)
    utils.to_console("Trigger claim:", trigger)
end
gamepush.triggers.callbacks.error_claim = function(error)
    utils.to_console("Trigger claim error:", error)
end

return M