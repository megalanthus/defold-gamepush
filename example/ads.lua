local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function is_adblock_enabled()
    utils.to_log(gamepush.ads.is_adblock_enabled())
end

local function is_sticky_available()
    utils.to_log(gamepush.ads.is_sticky_available())
end

local function is_fullscreen_available()
    utils.to_log(gamepush.ads.is_fullscreen_available())
end

local function is_rewarded_available()
    utils.to_log(gamepush.ads.is_rewarded_available())
end

local function is_preloader_available()
    utils.to_log(gamepush.ads.is_preloader_available())
end

local function is_sticky_playing()
    utils.to_log(gamepush.ads.is_sticky_playing())
end

local function is_fullscreen_playing()
    utils.to_log(gamepush.ads.is_fullscreen_playing())
end

local function is_rewarded_playing()
    utils.to_log(gamepush.ads.is_rewarded_playing())
end

local function is_preloader_playing()
    utils.to_log(gamepush.ads.is_preloader_playing())
end

local function show_fullscreen()
    gamepush.ads.show_fullscreen(function(result)
        utils.to_log("show fullscreen: " .. tostring(result))
    end)
end

local function show_fullscreen_countdown()
    gamepush.ads.show_fullscreen(function(result)
        utils.to_log("show fullscreen: " .. tostring(result))
    end, { showCountdownOverlay = true })
end

local function show_preloader()
    gamepush.ads.show_preloader(function(result)
        utils.to_log("show preloader: " .. tostring(result))
    end)
end

local function show_rewarded()
    gamepush.ads.show_rewarded_video(function(result)
        utils.to_log("show rewarded: " .. tostring(result))
    end)
end

local function show_rewarded_failed()
    gamepush.ads.show_rewarded_video(function(result)
        utils.to_log("show rewarded: " .. tostring(result))
    end, { showRewardedFailedOverlay = true })
end

local function show_sticky()
    gamepush.ads.show_sticky(function(result)
        utils.to_log("show sticky: " .. tostring(result))
    end)
end

local function refresh_sticky()
    gamepush.ads.refresh_sticky(function(result)
        utils.to_log("refresh sticky: " .. tostring(result))
    end)
end

local function close_sticky()
    gamepush.ads.close_sticky(function()
        utils.to_log("close sticky")
    end)
end

local M = {
    { name = "Is adblock enabled", callback = is_adblock_enabled },
    { name = "Is sticky available", callback = is_sticky_available },
    { name = "Is fullscreen available", callback = is_fullscreen_available },
    { name = "Is rewarded available", callback = is_rewarded_available },
    { name = "Is preloader available", callback = is_preloader_available },
    { name = "Is sticky playing", callback = is_sticky_playing },
    { name = "Is fullscreen playing", callback = is_fullscreen_playing },
    { name = "Is rewarded playing", callback = is_rewarded_playing },
    { name = "Is preloader playing", callback = is_preloader_playing },
    { name = "Show fullscreen", callback = show_fullscreen },
    { name = "Show fullscreen with countdown", callback = show_fullscreen_countdown },
    { name = "Show preloader", callback = show_preloader },
    { name = "Show rewarded", callback = show_rewarded },
    { name = "Show rewarded with failed", callback = show_rewarded_failed },
    { name = "Show sticky", callback = show_sticky },
    { name = "Refresh sticky", callback = refresh_sticky },
    { name = "Close sticky", callback = close_sticky },
}

gamepush.ads.callbacks.start = function()
    utils.to_console("start ads")
end
gamepush.ads.callbacks.close = function(success)
    utils.to_console("close ads:", success)
end
gamepush.ads.callbacks.fullscreen_start = function()
    utils.to_console("start fullscreen ads")
end
gamepush.ads.callbacks.fullscreen_close = function(success)
    utils.to_console("close fullscreen ads:", success)
end
gamepush.ads.callbacks.preloader_start = function()
    utils.to_console("start preloader ads")
end
gamepush.ads.callbacks.preloader_close = function(success)
    utils.to_console("close preloader ads:", success)
end
gamepush.ads.callbacks.rewarded_start = function()
    utils.to_console("start rewarded ads")
end
gamepush.ads.callbacks.rewarded_close = function(success)
    utils.to_console("close rewarded ads:", success)
end
gamepush.ads.callbacks.rewarded_reward = function()
    utils.to_console("reward rewarded ads")
end
gamepush.ads.callbacks.sticky_start = function()
    utils.to_console("start sticky ads")
end
gamepush.ads.callbacks.sticky_render = function()
    utils.to_console("render sticky ads")
end
gamepush.ads.callbacks.sticky_refresh = function()
    utils.to_console("refresh sticky ads")
end
gamepush.ads.callbacks.sticky_close = function()
    utils.to_console("close sticky ads")
end

return M