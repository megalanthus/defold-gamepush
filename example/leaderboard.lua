local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function open()
    gamepush.leaderboard.open()
    utils.to_log("Leaderboard open")
end

local function open_param()
    local param = {
        limit = 5,
        order = "DESC",
        includeFields = { "level" },
        displayFields = { "score", "level" },
        withMe = "last"
    }
    gamepush.leaderboard.open(param)
    utils.to_log("Leaderboard open with parameters:\n" .. utils.table_to_string(param))
end

local function fetch()
    gamepush.leaderboard.fetch(nil, function(leaders)
        utils.to_log("Leaderboard fetch:\n" .. utils.table_to_string(leaders))
    end)
end

local function fetch_param()
    local param = {
        limit = 3,
        order = "ASC",
        includeFields = { "level" },
        displayFields = { "score", "level" },
        withMe = "last"
    }
    gamepush.leaderboard.fetch(param, function(leaders)
        utils.to_log("Leaderboard fetch with parameters:\n" .. utils.table_to_string(leaders))
    end)
end

local function fetch_player_rating()
    gamepush.leaderboard.fetch_player_rating(nil, function(leaders)
        utils.to_log("Leaderboard fetch rating:\n" .. utils.table_to_string(leaders))
    end)
end

local function fetch_player_rating_param()
    local param = {
        includeFields = { "level" },
    }
    gamepush.leaderboard.fetch_player_rating(param, function(leaders)
        utils.to_log("Leaderboard fetch rating with parameters:\n" .. utils.table_to_string(leaders))
    end)
end

local function open_scoped()
    local parameters = {
        tag = "test",
        variant = "levels"
    }
    gamepush.leaderboard.open_scoped(parameters, function(result)
        utils.to_log("Leaderboard open scoped:\n" .. utils.table_to_string(result))
    end)
end

local function fetch_scoped()
    local parameters = {
        tag = "test",
        variant = "levels"
    }
    gamepush.leaderboard.fetch_scoped(parameters, function(leaders)
        utils.to_log("Leaderboard fetch scoped:\n" .. utils.table_to_string(leaders))
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
        utils.to_log("Leaderboard publish record:\n" .. utils.table_to_string(result))
    end)
end

local function fetch_player_rating_scoped()
    local param = {
        tag = "test",
        variant = "levels"
    }
    gamepush.leaderboard.fetch_player_rating_scoped(param, function(leaders)
        utils.to_log("Leaderboard fetch rating with parameters:\n" .. utils.table_to_string(leaders))
    end)
end

local M = {
    { name = "Open", callback = open },
    { name = "Open with param", callback = open_param },
    { name = "Fetch", callback = fetch },
    { name = "Fetch with param", callback = fetch_param },
    { name = "Fetch player rating", callback = fetch_player_rating },
    { name = "Fetch player rating with param", callback = fetch_player_rating_param },
    { name = "Open scoped", callback = open_scoped },
    { name = "Fetch scoped", callback = fetch_scoped },
    { name = "Publish record", callback = publish_record },
    { name = "Fetch player rating scoped", callback = fetch_player_rating_scoped },
}

return M