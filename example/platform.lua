local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function get_type()
    utils.to_log(gamepush.platform.type())
end

local function has_integrated_auth()
    utils.to_log(gamepush.platform.has_integrated_auth())
end

local function is_external_links_allowed()
    utils.to_log(gamepush.platform.is_external_links_allowed())
end

local function is_secret_code_auth_available()
    utils.to_log(gamepush.platform.is_secret_code_auth_available())
end

local M = {
    { name = "Type", callback = get_type },
    { name = "Has integrated auth", callback = has_integrated_auth },
    { name = "Is external links allowed", callback = is_external_links_allowed },
    { name = "Is secret code auth available", callback = is_secret_code_auth_available }
}

return M