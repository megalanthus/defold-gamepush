local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local reward_id = 18

local function give()
    gamepush.rewards.give({ id = reward_id }, function(result)
        utils.to_log("Give reward:", result)
    end)
end

local function accept()
    gamepush.rewards.accept({ id = "my_reward" }, function(result)
        utils.to_log("Accept reward:", result)
    end)
end

local function list()
    utils.to_log("List reward:", gamepush.rewards.list())
end

local function given_list()
    utils.to_log("List given reward:", gamepush.rewards.given_list())
end

local function get_reward()
    utils.to_log("Get reward:", gamepush.rewards.get_reward(reward_id))
end

local function has()
    utils.to_log("Reward has:", gamepush.rewards.has(reward_id))
end

local function has_accepted()
    utils.to_log("Reward has accepted:", gamepush.rewards.has_accepted(reward_id))
end

local function has_unaccepted()
    utils.to_log("Reward has unaccepted:", gamepush.rewards.has_accepted(reward_id))
end

local M = {
    { name = "Give", callback = give },
    { name = "Accept", callback = accept },
    { name = "List", callback = list },
    { name = "Given list", callback = given_list },
    { name = "Get reward", callback = get_reward },
    { name = "Has", callback = has },
    { name = "Has accepted", callback = has_accepted },
    { name = "Has unaccepted", callback = has_unaccepted },
}

gamepush.rewards.callbacks.give = function(reward)
    utils.to_console("Give reward:", reward)
end
gamepush.rewards.callbacks.error_give = function(error)
    utils.to_console("Give reward error:", error)
end
gamepush.rewards.callbacks.accept = function(reward)
    utils.to_console("Accept reward:", reward)
end
gamepush.rewards.callbacks.error_accept = function(error)
    utils.to_console("Accept reward error:", error)
end

return M