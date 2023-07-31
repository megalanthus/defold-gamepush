local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function is_logged_in()
    utils.to_log(gamepush.player.is_logged_in())
end

local function has_any_credentials()
    utils.to_log(gamepush.player.has_any_credentials())
end

local function is_logged_in_by_platform()
    utils.to_log(gamepush.player.has_any_credentials())
end

local function sync()
    gamepush.player.sync(nil, function()
        utils.to_log("Sync player")
    end)
end

local function sync_override()
    gamepush.player.sync({ override = true }, function()
        utils.to_log("Sync player with override")
    end)
end

local function load()
    gamepush.player.load(function()
        utils.to_log("Load player")
    end)
end

local function login()
    gamepush.player.login(function(result)
        utils.to_log("Login player: " .. tostring(result))
    end)
end

local function fetch_fields()
    gamepush.player.fetch_fields(function()
        utils.to_log("Fetch fields player")
    end)
end

local function id()
    utils.to_log(gamepush.player.id())
end

local function score()
    utils.to_log(gamepush.player.score())
end

local function name()
    utils.to_log(gamepush.player.name())
end

local function avatar()
    utils.to_log(gamepush.player.avatar())
end

local function is_stub()
    utils.to_log(gamepush.player.is_stub())
end

local function fields()
    utils.to_log(gamepush.player.fields())
end

local function get()
    utils.to_log("player get: " .. gamepush.player.get("score"))
end

local function set()
    gamepush.player.set("score", 100)
    utils.to_log("player set score 100")
end

local function add()
    gamepush.player.add("score", 10)
    utils.to_log("player add score 10")
end

local function toggle()
    gamepush.player.toggle("score")
    utils.to_log("player toggle score")
end

local function has()
    utils.to_log("player has score: " .. tostring(gamepush.player.has("score")))
end

local function to_json()
    utils.to_log("player to json:", gamepush.player.to_json())
end

local function from_json()
    local player = { name = "Name player", score = 152 }
    gamepush.player.from_json(player)
    utils.to_log("player from json:", player)
end

local function reset()
    gamepush.player.reset()
    utils.to_log("player reset")
end

local function remove()
    gamepush.player.remove()
    utils.to_log("player remove")
end

local function get_field()
    utils.to_log("player get field:", gamepush.player.get_field("score"))
end

local function get_field_name()
    utils.to_log("player get field name:", gamepush.player.get_field_name("score"))
end

local function get_field_variant_name()
    local variant_name = gamepush.player.get_field_variant_name("progress", "progress_value")
    utils.to_log("player get field variant name:", variant_name)
end

local function fetch()
    gamepush.players.fetch({ ids = { 62116670, 62142823 } }, function(result)
        utils.to_log("Fetch player data:", result)
    end)
end

local function active_days()
    utils.to_log("Active days:", gamepush.player.stats.active_days())
end

local function active_days_consecutive()
    utils.to_log("Active days consecutive:", gamepush.player.stats.active_days_consecutive())
end

local function playtime_today()
    utils.to_log("Playtime today:", gamepush.player.stats.playtime_today())
end

local function playtime_all()
    utils.to_log("Playtime all:", gamepush.player.stats.playtime_all())
end

local M = {
    { name = "Is logged in", callback = is_logged_in },
    { name = "Has any credentials", callback = has_any_credentials },
    { name = "Is logged in by platform", callback = is_logged_in_by_platform },
    { name = "Sync player", callback = sync },
    { name = "Sync player with override", callback = sync_override },
    { name = "Load", callback = load },
    { name = "Login", callback = login },
    { name = "Fetch fields", callback = fetch_fields },
    { name = "Id", callback = id },
    { name = "Score", callback = score },
    { name = "Name", callback = name },
    { name = "Avatar", callback = avatar },
    { name = "Is stub", callback = is_stub },
    { name = "Fields", callback = fields },
    { name = "Get", callback = get },
    { name = "Set", callback = set },
    { name = "Add", callback = add },
    { name = "Toggle", callback = toggle },
    { name = "Has", callback = has },
    { name = "To json", callback = to_json },
    { name = "From json", callback = from_json },
    { name = "Reset", callback = reset },
    { name = "Remove", callback = remove },
    { name = "Get field", callback = get_field },
    { name = "Get field name", callback = get_field_name },
    { name = "Get field variant name", callback = get_field_variant_name },
    { name = "Fetch players", callback = fetch },
    { name = "Active days", callback = active_days },
    { name = "Active days consecutive", callback = active_days_consecutive },
    { name = "Playtime today", callback = playtime_today },
    { name = "Playtime all", callback = playtime_all },
}

gamepush.player.callbacks.sync = function(success)
    utils.to_console("sync player:", success)
end
gamepush.player.callbacks.load = function(success)
    utils.to_console("load player:", success)
end
gamepush.player.callbacks.login = function(success)
    utils.to_console("login player:", success)
end
gamepush.player.callbacks.fetch_fields = function(success)
    utils.to_console("fetch fields player", success)
end
gamepush.player.callbacks.change = function()
    utils.to_console("change player")
end

return M