local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function open()
    gamepush.documents.open({ type = "PLAYER_PRIVACY_POLICY" })
end

local function fetch()
    gamepush.documents.fetch({ type = "PLAYER_PRIVACY_POLICY", format = "TXT" }, function(document)
        utils.to_log("Documents fetch")
        pprint("Documents fetch result:", document)
    end)
end

local M = {
    { name = "Open", callback = open },
    { name = "Fetch", callback = fetch },
}

gamepush.documents.callbacks.open = function()
    utils.to_console("Document open")
end
gamepush.documents.callbacks.close = function()
    utils.to_console("Document close")
end
gamepush.documents.callbacks.fetch = function(document)
    utils.to_console("Document fetch", document)
end
gamepush.documents.callbacks.fetch_error = function(error)
    utils.to_console("Document fetch error:", error)
end

return M