local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function title()
    utils.to_log(gamepush.app.title())
end

local function description()
    utils.to_log(gamepush.app.description())
end

local function get_image()
    utils.to_log(gamepush.app.image())
end

local function url()
    utils.to_log(gamepush.app.url())
end

local M = {
    { name = "Title", callback = title },
    { name = "Description", callback = description },
    { name = "Image", callback = get_image },
    { name = "Url", callback = url }
}

return M