local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function open()
    local parameters = {
        limit = 5,
        order = "DESC",
        includeFields = { "level" },
        displayFields = { "score", "level" },
        withMe = "last"
    }
    gamepush.leaderboard.open(parameters)
    utils.to_log("Leaderboard open:", parameters)
end

local function fetch()
    local parameters = {
        limit = 3,
        order = "ASC",
        includeFields = { "level" },
        displayFields = { "score", "level" },
        withMe = "last"
    }
    gamepush.leaderboard.fetch(parameters, function(leaders)
        utils.to_log("Leaderboard fetch:", leaders)
    end)
end

local function fetch_player_rating()
    local parameters = {
        includeFields = { "level" }
    }
    gamepush.leaderboard.fetch_player_rating(parameters, function(leaders)
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
    local parameters = {
        tag = "test",
        variant = "levels",
        record = {
            level = 50
        }
    }
    gamepush.leaderboard.publish_record(parameters, function(result)
        utils.to_log("Leaderboard publish record:", result)
    end)
end

local function fetch_player_rating_scoped()
    local parameters = {
        tag = "test",
        variant = "levels"
    }
    gamepush.leaderboard.fetch_player_rating_scoped(parameters, function(leaders)
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