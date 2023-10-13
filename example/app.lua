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

local function request_review()
    gamepush.app.request_review(function(result)
        utils.to_log("Request review:", result)
    end)
end

local function can_request_review()
    utils.to_log("Can request review:", gamepush.app.can_request_review())
end

local function is_already_reviewed()
    utils.to_log("Is already reviewed:", gamepush.app.is_already_reviewed())
end

local function add_shortcut()
    gamepush.app.add_shortcut(function(result)
        utils.to_log("Add shortcut:", result)
    end)
end

local function can_add_shortcut()
    utils.to_log("Can add shortcut:", gamepush.app.can_add_shortcut())
end

local M = {
    { name = "Title", callback = title },
    { name = "Description", callback = description },
    { name = "Image", callback = get_image },
    { name = "Url", callback = url },
    { name = "Request review", callback = request_review },
    { name = "Can request review", callback = can_request_review },
    { name = "Is already reviewed", callback = is_already_reviewed },
    { name = "Add shortcut", callback = add_shortcut },
    { name = "Can add shortcut", callback = can_add_shortcut }
}

return M