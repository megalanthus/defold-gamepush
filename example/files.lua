local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function upload()
    gamepush.files.upload({ accept = ".txt, .json" }, function(result)
        utils.to_log("Files upload:", result)
    end)
end

local function upload_url()
    gamepush.files.upload_url({ filename = "mysave2.txt", url = "https://s3.gamepush.com/games/files/1528/ugc/21452286/test.txt", tags = { "level7" } }, function(result)
        utils.to_log("Files upload url:", result)
    end)
end

local function upload_content()
    gamepush.files.upload_content({ filename = "mysave.txt", content = "Hello world!" }, function(result)
        utils.to_log("Files upload content:", result)
    end)
end

local function load_content()
    gamepush.files.load_content("https://s3.gamepush.com/games/files/1528/ugc/21456702/mysave.txt", function(result)
        utils.to_log("Files load content:", result)
    end)
end

local function choose_file()
    gamepush.files.choose_file(".txt, .json", function(result)
        utils.to_log("Files choose file:", result)
        gamepush.files.upload_url({ filename = "mysave3.txt", url = result.tempUrl, tags = { "level7" } }, function(result)
            utils.to_log("Files upload url:", result)
        end)
    end)
end

local function fetch()
    gamepush.files.fetch(nil, function(result)
        utils.to_log("Files fetch:", result)
    end)
end

local function fetch_more()
    gamepush.files.fetch_more({ limit = 2 }, function(result)
        utils.to_log("Files fetch more:", result)
    end)
end

local function can_upload()
    utils.to_log("Files can upload:", gamepush.files.can_upload())
end

local M = {
    { name = "Upload", callback = upload },
    { name = "Upload url", callback = upload_url },
    { name = "Upload content", callback = upload_content },
    { name = "Load content", callback = load_content },
    { name = "Choose file", callback = choose_file },
    { name = "Fetch", callback = fetch },
    { name = "Fetch more", callback = fetch_more },
    { name = "Can upload", callback = can_upload },
}

gamepush.files.callbacks.upload = function(result)
    utils.to_console("Files upload:", result)
end
gamepush.files.callbacks.error_upload = function(error)
    utils.to_console("Files upload error:", error)
end
gamepush.files.callbacks.load_content = function(result)
    utils.to_console("Files load content:", result)
end
gamepush.files.callbacks.error_load_content = function(error)
    utils.to_console("Files load content error:", error)
end
gamepush.files.callbacks.choose = function(result)
    utils.to_console("Files choose:", result)
end
gamepush.files.callbacks.error_choose = function(error)
    utils.to_console("Files choose error:", error)
end
gamepush.files.callbacks.fetch = function(result)
    utils.to_console("Files fetch:", result)
end
gamepush.files.callbacks.error_fetch = function(error)
    utils.to_console("Files fetch error:", error)
end
gamepush.files.callbacks.fetch_more = function(result)
    utils.to_console("Files fetch more:", result)
end
gamepush.files.callbacks.error_fetch_more = function(error)
    utils.to_console("Files fetch more error:", error)
end

return M