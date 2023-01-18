local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function yandex_environment()
    local environment = gamepush.platform.call_native_sdk("environment")
    utils.to_log("Yandex environment:", environment)
end

local function yandex_review()
    utils.to_log("Call native yandex feedback.canReview")
    gamepush.platform.call_native_sdk("feedback.canReview", nil, function(result)
        utils.to_log("Call native yandex feedback.canReview:", result)
        if result.value then
            gamepush.platform.call_native_sdk("feedback.requestReview")
        end
    end)
end

local function yandex_set_leaderboard()
    gamepush.platform.call_native_sdk("lb=getLeaderboards", nil, function(leaderboards)
        utils.to_log("Yandex set leaderboard 200 score:", leaderboards)
        gamepush.platform.call_native_sdk("lb:setLeaderboardScore", { "leaderboard2021", 200 })
    end)
end

local function yandex_get_leaderboard()
    gamepush.platform.call_native_sdk("lb=getLeaderboards", nil, function(leaderboards)
        if leaderboards.error then
            utils.to_log("Yandex get leaderboard:", leaderboards)
        else
            local parameters = {
                "leaderboard2021",
                { quantityTop = 10, includeUser = true, quantityAround = 3 }
            }
            gamepush.platform.call_native_sdk("lb:getLeaderboardEntries", parameters, function(result)
                utils.to_log("Yandex get leaderboard:", result)
            end)
        end
    end)
end

local M = {
    { name = "Yandex environment", callback = yandex_environment },
    { name = "Yandex review", callback = yandex_review },
    { name = "Yandex set leaderboard", callback = yandex_set_leaderboard },
    { name = "Yandex get leaderboard", callback = yandex_get_leaderboard }
}

return M