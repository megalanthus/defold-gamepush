local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function yandex_environment()
    local environment = gamepush.platform.call_native_sdk("environment")
    utils.to_log("Yandex environment:\n" .. utils.table_to_string(environment))
end

local function yandex_review()
    utils.to_log("Call native yandex feedback.canReview")
    gamepush.platform.call_native_sdk("feedback.canReview", nil, function(result)
        utils.to_log("Call native yandex feedback.canReview:\n" .. utils.table_to_string(result))
        if result.value then
            gamepush.platform.call_native_sdk("feedback.requestReview")
        end
    end)
end

local function yandex_set_leaderboard()
    gamepush.platform.call_native_sdk("lb=getLeaderboards", nil, function(leaderboards)
        utils.to_log("Yandex set leaderboard 120 score:\n" .. utils.table_to_string(leaderboards))
        gamepush.platform.call_native_sdk("lb:setLeaderboardScore", { "leaderboard2021", 120 })
    end)
end

local function yandex_get_leaderboard()
    gamepush.platform.call_native_sdk("lb=getLeaderboards", nil, function(leaderboards)
        if leaderboards.error then
            utils.to_log("Yandex get leaderboard:\n" .. utils.table_to_string(leaderboards))
        else
            local parameters = {
                "leaderboard2021",
                { quantityTop = 10, includeUser = true, quantityAround = 3 }
            }
            gamepush.platform.call_native_sdk("lb:getLeaderboardEntries", parameters, function(result)
                utils.to_log("Yandex get leaderboard:\n" .. utils.table_to_string(result))
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