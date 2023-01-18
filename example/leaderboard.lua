local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function open()
    local param = {
        limit = 5,
        order = "DESC",
        includeFields = { "level" },
        displayFields = { "score", "level" },
        withMe = "last"
    }
    gamepush.leaderboard.open(param)
    utils.to_log("Leaderboard open:", param)
end

local function fetch()
    local param = {
        limit = 3,
        order = "ASC",
        includeFields = { "level" },
        displayFields = { "score", "level" },
        withMe = "last"
    }
    gamepush.leaderboard.fetch(param, function(leaders)
        utils.to_log("Leaderboard fetch:", leaders)
    end)
end

local function fetch_player_rating()
    local param = {
        includeFields = { "level" },
    }
    gamepush.leaderboard.fetch_player_rating(param, function(leaders)
        utils.to_log("Leaderboard fetch rating:", leaders)
    end)
end

local function open_scoped()
    local parameters = {
        tag = "test",
        variant = "levels"
    }
    gamepush.leaderboard.open_scoped(parameters, function(result)
        utils.to_log("Leaderboard open scoped:", result)
    end)
end

local function fetch_scoped()
    local parameters = {
        tag = "test",
        variant = "levels"
    }
    gamepush.leaderboard.fetch_scoped(parameters, function(leaders)
        utils.to_log("Leaderboard fetch scoped:", leaders)
    end)
end

local function publish_record()
    local record = {
        tag = "test",
        variant = "levels",
        record = {
            score = 250
        },
    }
    gamepush.leaderboard.publish_record(record, function(result)
        utils.to_log("Leaderboard publish record:", result)
    end)
end

local function fetch_player_rating_scoped()
    local param = {
        tag = "test",
        variant = "levels"
    }
    gamepush.leaderboard.fetch_player_rating_scoped(param, function(leaders)
        utils.to_log("Leaderboard fetch rating with parameters:", leaders)
    end)
end

local M = {
    { name = "Open", callback = open },
    { name = "Fetch", callback = fetch },
    { name = "Fetch player rating", callback = fetch_player_rating },
    { name = "Open scoped", callback = open_scoped },
    { name = "Fetch scoped", callback = fetch_scoped },
    { name = "Publish record", callback = publish_record },
    { name = "Fetch player rating scoped", callback = fetch_player_rating_scoped },
}

return M