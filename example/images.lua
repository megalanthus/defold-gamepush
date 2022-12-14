local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function upload()
    gamepush.images.upload({ tags = { "screenshot", "level7" } }, function(image)
        utils.to_log("Images upload:\n" .. utils.table_to_string(image))
    end)
end

local function upload_url()
    gamepush.images.upload_url({ url = "https://cdn.gamepush.com/static/images/629/47a/62947aa15164d67a6f8f4618-64x64.webp", tags = { "level7" } }, function(image)
        utils.to_log("Images upload url:\n" .. utils.table_to_string(image))
    end)
end

local function file_choice()
    gamepush.images.choice_file(function(image)
        utils.to_log("Images file choice:\n" .. utils.table_to_string(image))
        gamepush.images.upload_url({ url = image.tempUrl, tags = { "level7" } }, function(result)
            utils.to_log("Images upload url:\n" .. utils.table_to_string(result))
        end)
    end)
end

local function fetch()
    gamepush.images.fetch(nil, function(image)
        utils.to_log("Images fetch:\n" .. utils.table_to_string(image))
    end)
end

local function fetch_more()
    gamepush.images.fetch_more({ limit = 2 }, function(image)
        utils.to_log("Images fetch more:\n" .. utils.table_to_string(image))
    end)
end

local function resize()
    local image = gamepush.images.resize("https://cdn.gamepush.com/static/images/629/47d/62947da15164d67a6f8f4b83-920x920.webp", 64, 64)
    utils.to_log(image)
    gamepush.images.upload_url({ url = image, tags = { "screenshot" } }, function(result)
        utils.to_log("Images upload url:\n" .. utils.table_to_string(result))
    end)
end

local function can_upload()
    utils.to_log("Images can upload: " .. tostring(gamepush.images.can_upload()))
end

local M = {
    { name = "Upload", callback = upload },
    { name = "Upload url", callback = upload_url },
    { name = "File choice", callback = file_choice },
    { name = "Fetch", callback = fetch },
    { name = "Fetch more", callback = fetch_more },
    { name = "Resize", callback = resize },
    { name = "Can upload", callback = can_upload },
}

gamepush.images.callbacks.upload = function(image)
    utils.to_console("Images upload:", image)
end
gamepush.images.callbacks.upload_error = function(error)
    utils.to_console("Images upload error:", error)
end
gamepush.images.callbacks.choose = function(result)
    utils.to_console("Images choose:", result)
end
gamepush.images.callbacks.choose_error = function(error)
    utils.to_console("Images choose error:", error)
end
gamepush.images.callbacks.fetch = function(result)
    utils.to_console("Images fetch:", result)
end
gamepush.images.callbacks.fetch_error = function(error)
    utils.to_console("Images fetch error:", error)
end
gamepush.images.callbacks.fetch_more = function(result)
    utils.to_console("Images fetch more:", result)
end
gamepush.images.callbacks.fetch_more_error = function(error)
    utils.to_console("Images fetch more error:", error)
end

return M