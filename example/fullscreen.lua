local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function open()
    utils.to_log("Fullscreen open")
    gamepush.fullscreen.open()
end

local function close()
    utils.to_log("Fullscreen close")
    gamepush.fullscreen.close()
end

local function toggle()
    utils.to_log("Fullscreen toggle")
    gamepush.fullscreen.toggle()
end

local M = {
    { name = "Open", callback = open },
    { name = "Close", callback = close },
    { name = "Toggle", callback = toggle },
}

gamepush.fullscreen.callbacks.open = function()
    utils.to_console("Fullscreen open")
end
gamepush.fullscreen.callbacks.close = function()
    utils.to_console("Fullscreen close")
end
gamepush.fullscreen.callbacks.change = function()
    utils.to_console("Fullscreen change")
end

return M