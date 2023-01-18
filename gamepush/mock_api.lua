local callback_ids = require("gamepush.core.callback_ids")

local M = {}

local function get_storage_file_name()
    local appname = sys.get_config("project.title")
    if sys.get_sys_info().system_name == "Linux" then
        appname = string.format("config/%s", appname)
        return sys.get_save_file(appname, M.file_storage)
    end
    return sys.get_save_file(appname, M.file_storage)
end

local function save_storage()
    local data = {}
    for key, value in pairs(M) do
        if type(value) ~= "function" and type(value) ~= "table" then
            data[key] = value
        end
    end
    sys.save(get_storage_file_name(), data)
end

M.send = function(callback_id, message)
end

M.file_storage = "gamepush.dat"

-- инициализация
M["init"] = function()
    M["player.load"]()
end

-- язык
M["language"] = sys.get_sys_info().language
M["changeLanguage"] = function(language)
    M["language"] = language
end

M["isDev"] = true
M["isMobile"] = false
M["isAllowedOrigin"] = true
M["serverTime"] = os.date("%FT%T")
M["isPaused"] = false
M["pause"] = function()
    M["isPaused"] = true
    M.send(callback_ids.common.pause)
end
M["resume"] = function()
    M["isPaused"] = false
    M.send(callback_ids.common.resume)
end

-- приложение
M["app.title"] = sys.get_config("project.title")
M["app.description"] = sys.get_config("gamepush.description")
M["app.image"] = sys.get_config("gamepush.image")
M["app.url"] = ""

-- платформа
M["platform.type"] = sys.get_sys_info().system_name
M["platform.hasIntegratedAuth"] = false
M["platform.isExternalLinksAllowed"] = false
M["platform.isSecretCodeAuthAvailable"] = false

-- игрок
M["player.isLoggedIn"] = false
M["player.hasAnyCredentials"] = false
M["player.isLoggedInByPlatform"] = false
M["player.sync"] = function(parameters)
    save_storage()
    M.send(callback_ids.player.change)
    M.send(callback_ids.player.sync, true)
end
M["player.load"] = function()
    local data = sys.load(get_storage_file_name())
    for key, value in pairs(data) do
        M[key] = value
    end
    M.send(callback_ids.player.change)
    M.send(callback_ids.player.load, true)
end
M["player.login"] = function()
    M["player.isLoggedIn"] = true
    M.send(callback_ids.player.login, true)
    return true
end
M["player.fetchFields"] = function()
    M.send(callback_ids.player.fetchFields)
end
M["player.id"] = 0
M["player.score"] = 0
M["player.name"] = "Player"
M["player.avatar"] = ""
M["player.isStub"] = false
M["player.fields"] = {
    { name = "Score",
      key = "score",
      type = "stats",
      important = true,
      default = 0,
      variants = {}
    }
}
M["player.get"] = function(key)
    key = "player." .. key
    return M[key]
end
M["player.set"] = function(key, value)
    key = "player." .. key
    M[key] = value
    save_storage()
    M.send(callback_ids.player.change)
end
M["player.add"] = function(key, value)
    key = "player." .. key
    M[key] = (M[key] or 0) + value
    save_storage()
    M.send(callback_ids.player.change)
end
M["player.toggle"] = function(key)
    key = "player." .. key
    M[key] = not M[key]
    save_storage()
    M.send(callback_ids.player.change)
end
M["player.has"] = function(key)
    key = "player." .. key
    return M[key] ~= nil
end
M["player.toJSON"] = function()
    local result = {}
    for key, value in pairs(M) do
        if type(value) ~= "function" and type(value) ~= "table" and string.find(key, "player.") == 1 then
            result[string.sub(key, 8)] = value
        end
    end
    return result
end
M["player.fromJSON"] = function(player)
    for key, value in pairs(player) do
        M["player." .. key] = value
    end
    save_storage()
    M.send(callback_ids.player.change)
end
M["player.reset"] = function()
    M["player.score"] = 0
    M["player.name"] = ""
    M.send(callback_ids.player.change)
end
M["player.remove"] = function()
    M["player.reset"]()
end
M["player.getField"] = function(key)
    for _, field in pairs(M["player.fields"]) do
        if field.key == key then
            return field
        end
    end
    return {}
end
M["player.getFieldName"] = function(key)
    local field = M["player.getField"](key)
    return field.name or ""
end
M["player.getFieldVariantName"] = function(key, value)
    local result = M["player.getFieldName"](key)
    return result
end

-- покупки
M.payments_data = {}
M.product_data = {
    {
        description = "my product",
        price = 100,
        currency = "GS",
        icon = "https://cdn.gamepush.com/static/256x256/images/achievements/flash.png",
        iconSmall = "https://cdn.gamepush.com/static/48x48/images/achievements/flash.png",
        id = 749,
        currencySymbol = "GS'а",
        yandexId = "",
        name = "my_product",
        tag = "my_product"
    },
}
M["payments.isAvailable"] = true
M["payments.purchase"] = function(product)
    for _, item in pairs(M.product_data) do
        if item.id == product.id or item.tag == product.tag then
            local id = item.tag
            if M.payments_data[id] then
                M.payments_data[id] = M.payments_data[id] + 1
            else
                M.payments_data[id] = 1
            end
            local purchase = {
                payload = {},
                productId = product.id or 0
            }
            M.send(callback_ids.payments.purchase, { ["purchase"] = purchase, ["product"] = item })
            return { ["purchase"] = purchase, ["product"] = item, success = true, error = "" }
        end
    end
    local result = { message = "purchase_not_found" }
    M.send(callback_ids.payments["error:purchase"], result)
    return result
end
M["payments.consume"] = function(product)
    for _, item in pairs(M.product_data) do
        if item.id == product.id or item.tag == product.tag then
            local id = item.tag
            if M.payments_data[id] ~= nil and M.payments_data[id] > 0 then
                M.payments_data[id] = M.payments_data[id] - 1
                local purchase = {
                    payload = {},
                    productId = product.id or 0
                }
                M.send(callback_ids.payments.consume, { ["purchase"] = purchase, ["product"] = item })
                return { ["purchase"] = purchase, ["product"] = item, success = true, error = "" }
            end
        end
    end
    local result = { message = "purchase_not_found" }
    M.send(callback_ids.payments["error:consume"], result)
    return result
end
M["payments.has"] = function(product_id)
    if type(product_id) == "number" then
        for _, item in pairs(M.product_data) do
            if item.id == product_id then
                product_id = item.tag
                break
            end
        end
    end
    return M.payments_data[product_id] ~= nil and M.payments_data[product_id] > 0
end
M["payments.fetchProducts"] = function()
    M.send(callback_ids.payments.fetchProducts, M.product_data)
    return M.product_data
end

-- таблица лидеров
M["leaderboard.fetch"] = {
    players = {
        { score = 100,
          avatar = "",
          id = 0,
          name = "Player 1",
          position = 1 },
        { score = 80,
          avatar = "",
          id = 0,
          name = "Player 2",
          position = 2 }
    },
    fields = M["player.fields"]
}
M["leaderboard.fetchPlayerRating"] = {
    fields = M["player.fields"],
    player = {
        removed = false,
        projectId = sys.get_config("gamepush.id"),
        active = true,
        id = 0,
        score = 0,
        name = "",
        avatar = "",
        platformType = "NONE"
    }
}

-- реклама
M.ads_fullscreen_result = true
M.ads_preloader_result = true
M.ads_rewarded_result = true
M["ads.isAdblockEnabled"] = false
M["ads.isStickyAvailable"] = true
M["ads.isFullscreenAvailable"] = true
M["ads.isRewardedAvailable"] = true
M["ads.isPreloaderAvailable"] = true
M["ads.isStickyPlaying"] = false
M["ads.isFullscreenPlaying"] = false
M["ads.isRewardedPlaying"] = false
M["ads.isPreloaderPlaying"] = false
M["ads.showFullscreen"] = function()
    M.send(callback_ids.ads.start)
    M.send(callback_ids.ads["fullscreen:start"])
    local result = M.ads_fullscreen_result
    M.send(callback_ids.ads.close, result)
    M.send(callback_ids.ads["fullscreen:close"], result)
    return result
end
M["ads.showPreloader"] = function()
    M.send(callback_ids.ads.start)
    M.send(callback_ids.ads["preloader:start"])
    local result = M.ads_preloader_result
    M.send(callback_ids.ads.close, result)
    M.send(callback_ids.ads["preloader:close"], result)
    return result
end
M["ads.showRewardedVideo"] = function()
    M.send(callback_ids.ads.start)
    M.send(callback_ids.ads["rewarded:start"])
    local result = M.ads_rewarded_result
    M.send(callback_ids.ads.close, result)
    M.send(callback_ids.ads["rewarded:close"], result)
    if result then
        M.send(callback_ids.ads["rewarded:reward"])
    end
    return result
end
M["ads.showSticky"] = function()
    M.send(callback_ids.ads.start)
    M.send(callback_ids.ads["sticky:start"])
    M.send(callback_ids.ads["sticky:render"])
    local result = M["ads.isStickyPlaying"] == false
    M["ads.isStickyPlaying"] = true
    return result
end
M["ads.refreshSticky"] = function()
    M.send(callback_ids.ads["sticky:refresh"])
    M.send(callback_ids.ads["sticky:render"])
    M["ads.isStickyPlaying"] = true
    return true
end
M["ads.closeSticky"] = function()
    M.send(callback_ids.ads.close, true)
    M.send(callback_ids.ads["sticky:close"])
    M["ads.isStickyPlaying"] = false
end

--достижения
local achievements = {}
M.achievement_data = {
    achievements = {
        {
            iconSmall = "https://cdn.gamepush.com/static/48x48/images/achievements/flash.png",
            id = 424,
            rare = "COMMON",
            name = "test achiv",
            description = "test achievement desc",
            icon = "https://cdn.gamepush.com/static/256x256/images/achievements/flash.png",
            tag = "my_achiv" }
    },
    playerAchievements = {
        {
            playerId = 0,
            createdAt = "2022-01-10T04:40:07+0000",
            achievementId = 0
        }
    },
    achievementsGroups = {
        { description = "",
          id = 0,
          achievements = { 0 },
          name = "Other",
          tag = "others"
        }
    }
}
M["achievements.unlock"] = function(parameters)
    local id = parameters.tag or parameters.id
    if achievements[id] then
        return { success = false, error = "already_unlocked" }
    end
    achievements[id] = true
    local result = {
        description = "test achievement desc",
        id = 424,
        rare = "COMMON",
        name = "test achiv",
        icon = "https://cdn.gamepush.com/static/256x256/images/achievements/flash.png",
        tag = "my_achiv"
    }
    M.send(callback_ids.achievements.unlock, result)
    return { achievement = result, success = true, error = "" }
end
M["achievements.open"] = function()
    M.send(callback_ids.achievements.fetch, M.achievement_data)
    M.send(callback_ids.achievements.open)
    M.send(callback_ids.achievements.close)
end
M["achievements.fetch"] = function()
    M.send(callback_ids.achievements.fetch, M.achievement_data)
    return M.achievement_data
end

-- социальные действия
M["socials.isSupportsShare"] = false
M["socials.isSupportsNativeShare"] = false
M["socials.isSupportsNativePosts"] = false
M["socials.isSupportsNativeInvite"] = false
M["socials.canJoinCommunity"] = false
M["socials.isSupportsNativeCommunityJoin"] = false

-- Игровые переменные
M["variables.fetch"] = function()
    M.send(callback_ids.variables.fetch)
end
M["variables.get"] = "val"
M["variables.has"] = true
M["variables.type"] = "data"

-- подборки игр
M.games_collections_data = {
    description = "",
    id = 0,
    games = {
        {
            description = "my game description",
            id = 1,
            name = "my game",
            url = "https://my_game.ru",
            icon = "https://my_game.ru/icon.png"
        }
    },
    name = "Наши игры",
    tag = "ALL"
}
M["gamesCollections.open"] = function()
    M.send(callback_ids.payments.fetchProducts, M.games_collections_data)
end
M["gamesCollections.fetch"] = function()
    M.send(callback_ids.payments.fetchProducts, M.games_collections_data)
    return M.games_collections_data
end

return M