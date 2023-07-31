local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local scheduler_id = "my_scheduler"
local trigger_id = "my_trigger"
local day = 1

local function claim_day()
    gamepush.schedulers.claim_day(scheduler_id, day, function(result)
        utils.to_log("Claim day:", result)
    end)
end

local function claim_day_additional()
    gamepush.schedulers.claim_day_additional(scheduler_id, day, trigger_id, function(result)
        utils.to_log("Claim day additional:", result)
    end)
end

local function claim_all_day()
    gamepush.schedulers.claim_all_day(scheduler_id, day, function(result)
        utils.to_log("Claim all day:", result)
    end)
end

local function claim_all_days()
    gamepush.schedulers.claim_all_days(scheduler_id, function(result)
        utils.to_log("Claim all days:", result)
    end)
end

local function list()
    utils.to_log("List schedulers:", gamepush.schedulers.list())
end

local function active_list()
    utils.to_log("Active list schedulers:", gamepush.schedulers.active_list())
end

local function get_scheduler()
    utils.to_log("Get scheduler:", gamepush.schedulers.get_scheduler(scheduler_id))
end

local function get_scheduler_day()
    utils.to_log("Get scheduler day:", gamepush.schedulers.get_scheduler_day(scheduler_id, day))
end

local function get_scheduler_current_day()
    utils.to_log("Get scheduler current day:", gamepush.schedulers.get_scheduler_current_day(scheduler_id))
end

local function is_registered()
    utils.to_log("Is registered:", gamepush.schedulers.is_registered(scheduler_id))
end

local function is_today_reward_claimed()
    utils.to_log("Is today reward claimed:", gamepush.schedulers.is_today_reward_claimed(scheduler_id))
end

local function can_claim_day()
    utils.to_log("Can claim day:", gamepush.schedulers.can_claim_day(scheduler_id, day))
end

local function can_claim_day_additional()
    utils.to_log("Can claim day additional:", gamepush.schedulers.can_claim_day_additional(scheduler_id, day, trigger_id))
end

local function can_claim_all_day()
    utils.to_log("Can claim all day:", gamepush.schedulers.can_claim_all_day(scheduler_id, day))
end

local M = {
    { name = "Claim day", callback = claim_day },
    { name = "Claim day additional", callback = claim_day_additional },
    { name = "Claim all day", callback = claim_all_day },
    { name = "Claim all days", callback = claim_all_days },
    { name = "List", callback = list },
    { name = "Active list", callback = active_list },
    { name = "Get scheduler", callback = get_scheduler },
    { name = "Get scheduler day", callback = get_scheduler_day },
    { name = "Get scheduler current day", callback = get_scheduler_current_day },
    { name = "Is registered", callback = is_registered },
    { name = "Is today reward claimed", callback = is_today_reward_claimed },
    { name = "Can claim day", callback = can_claim_day },
    { name = "Can claim day additional", callback = can_claim_day_additional },
    { name = "Can claim all day", callback = can_claim_all_day },
}

gamepush.schedulers.callbacks.claim_day = function(scheduler)
    utils.to_console("Claim day scheduler:", scheduler)
end
gamepush.schedulers.callbacks.error_claim_day = function(error)
    utils.to_console("Claim day scheduler error:", error)
end
gamepush.schedulers.callbacks.claim_day_additional = function(scheduler)
    utils.to_console("Claim day additional scheduler:", scheduler)
end
gamepush.schedulers.callbacks.error_claim_day_additional = function(error)
    utils.to_console("Claim day additional scheduler error:", error)
end
gamepush.schedulers.callbacks.claim_all_day = function(scheduler)
    utils.to_console("Claim all day scheduler:", scheduler)
end
gamepush.schedulers.callbacks.error_claim_all_day = function(error)
    utils.to_console("Claim all day scheduler error:", error)
end
gamepush.schedulers.callbacks.claim_all_days = function(scheduler)
    utils.to_console("Claim all days scheduler:", scheduler)
end
gamepush.schedulers.callbacks.error_claim_all_days = function(error)
    utils.to_console("Claim all days scheduler error:", error)
end
gamepush.schedulers.callbacks.join = function(scheduler)
    utils.to_console("Join scheduler:", scheduler)
end
gamepush.schedulers.callbacks.error_join = function(error)
    utils.to_console("Join scheduler error:", error)
end

return M