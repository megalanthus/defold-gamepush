local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function init()
    local is_ok, message = pcall(gamepush.init, function(success)
        utils.to_log(success)
    end)
    if not is_ok then
        utils.to_console(message)
    end
end

local function get_language()
    utils.to_log("Current language: " .. gamepush.language())
end

local function set_language_ru()
    gamepush.change_language(gamepush.languages.RUSSIAN)
    utils.to_log("Set language `ru`")
end

local function set_language_en()
    gamepush.change_language(gamepush.languages.ENGLISH)
    utils.to_log("Set language `en`")
end

local function is_mobile()
    utils.to_log("Is mobile: " .. tostring(gamepush.is_mobile()))
end

local function is_portrait()
    utils.to_log("Is portrait: " .. tostring(gamepush.is_portrait()))
end

local function is_dev()
    utils.to_log("Is dev: " .. tostring(gamepush.is_dev()))
end

local function is_allowed_origin()
    utils.to_log("Is allowed origin: " .. tostring(gamepush.is_allowed_origin()))
end

local function get_server_time()
    utils.to_log("get server time: " .. gamepush.get_server_time())
end

local function is_paused()
    utils.to_log("is paused: " .. tostring(gamepush.is_paused()))
end

local function pause()
    gamepush.pause()
end

local function resume()
    gamepush.resume()
end

local function set_background()
    gamepush.set_background({ url = "/image.png" })
end

local function game_start()
    gamepush.game_start()
end

local function gameplay_start()
    gamepush.gameplay_start()
end

local function gameplay_stop()
    gamepush.gameplay_stop()
end

local M = {
    { name = "Init", callback = init },
    { name = "Get language", callback = get_language },
    { name = "Set language ru", callback = set_language_ru },
    { name = "Set language en", callback = set_language_en },
    { name = "Is mobile?", callback = is_mobile },
    { name = "Is portrait?", callback = is_portrait },
    { name = "Is dev?", callback = is_dev },
    { name = "Is allowed origin?", callback = is_allowed_origin },
    { name = "Get server time", callback = get_server_time },
    { name = "Is paused?", callback = is_paused },
    { name = "Pause", callback = pause },
    { name = "Resume", callback = resume },
    { name = "Set background", callback = set_background },
    { name = "Game start", callback = game_start },
    { name = "Gameplay start", callback = gameplay_start },
    { name = "Gameplay stop", callback = gameplay_stop }
}

gamepush.callbacks.change_orientation = function(orientation)
    utils.to_console("Change orientation", orientation)
end
gamepush.callbacks.pause = function()
    utils.to_console("pause")
end
gamepush.callbacks.resume = function()
    utils.to_console("resume")
end

return M