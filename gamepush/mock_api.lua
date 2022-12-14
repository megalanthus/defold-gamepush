local callback_ids = require("gamepush.core.callback_ids")

local data = {}
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
M["language"] = { value = sys.get_sys_info().language }
M["changeLanguage"] = function(language)
    M["language"].value = language
end

M["isDev"] = { value = true }
M["isMobile"] = { value = false }
M["isAllowedOrigin"] = { value = false }
M["serverTime"] = { value = os.date("%FT%T") }
M["isPaused"] = { value = false }
M["pause"] = function()
    M["isPaused"] = { value = true }
    M.send(callback_ids.common_pause)
end
M["resume"] = function()
    M["isPaused"] = { value = false }
    M.send(callback_ids.common_resume)
end

-- приложение
M["app.title"] = sys.get_config("project.title")
M["app.description"] = sys.get_config("gamepush.description")
M["app.image"] = sys.get_config("gamepush.image")
M["app.url"] = ""

-- платформа
M["platform.type"] = sys.get_sys_info().system_name
M["platform.hasIntegratedAuth"] = { value = false }
M["platform.isExternalLinksAllowed"] = { value = false }
M["platform.isSecretCodeAuthAvailable"] = { value = false }

-- игрок
M["player.isLoggedIn"] = { value = false }
M["player.hasAnyCredentials"] = { value = false }
M["player.isLoggedInByPlatform"] = { value = false }
M.fields_data = {
    { name = "Score",
      key = "score",
      type = "stats",
      important = true,
      default = 0,
      variants = {}
    }
}
M.player_data = {
    id = 0,
    score = 0,
    name = "Player",
    avatar = "",
    isStub = false,
    fields = M.fields_data
}
M["player"] = M.player_data
M["player.sync"] = function(parameters)
    save_storage()
    M.send(callback_ids.player_change)
    M.send(callback_ids.player_sync, true)
end
M["player.load"] = function()
    data = sys.load(get_storage_file_name())
    M.send(callback_ids.player_change)
    M.send(callback_ids.player_load, true)
end
M["player.login"] = function()
    M.player_data.isLoggedIn = true
    M.send(callback_ids.player_login, true)
    return true
end
M["player.fetchFields"] = function()
    M.send(callback_ids.player_fetch_fields)
end
M["player.get"] = function(key)
    return { value = data[key] }
end
M["player.set"] = function(key, value)
    data[key] = value
    save_storage()
    M.send(callback_ids.player_change)
end
M["player.add"] = function(key, value)
    data[key] = data[key] or 0 + value
    save_storage()
    M.send(callback_ids.player_change)
end
M["player.toggle"] = function(key)
    data[key] = not data[key]
    save_storage()
    M.send(callback_ids.player_change)
end
M["player.has"] = function(key)
    return { value = data[key] ~= nil }
end
M["player.toJSON"] = function()
    local result = {}
    for key, value in pairs(M.player_data) do
        result[key] = value
    end
    for key, value in pairs(data) do
        result[key] = value
    end
    return result
end
M["player.fromJSON"] = function(player)
    for key, value in pairs(player) do
        data[key] = value
    end
    save_storage()
    M.send(callback_ids.player_change)
end
M["player.reset"] = function()
    data = {}
    M.player_data.score = 0
    M.player_data.name = ""
    M.send(callback_ids.player_change)
end
M["player.remove"] = function()
    M["player.reset"]()
end
M["player.getField"] = function(key)
    for _, field in pairs(M.player_data.fields) do
        if field.key == key then
            return { value = field }
        end
    end
    return {}
end
M["player.getFieldName"] = function(key)
    local field = M["player.getField"](key)
    return { value = field.name or "" }
end
M["player.getFieldVariantName"] = function(key, value)
    local result = M["player.getFieldName"](key)
    return result
end

-- реклама
M.ads_fullscreen_result = true
M.ads_preloader_result = true
M.ads_rewarded_result = true
M["ads"] = {
    isAdblockEnabled = false,
    isStickyAvailable = true,
    isFullscreenAvailable = true,
    isRewardedAvailable = true,
    isPreloaderAvailable = true,
    isStickyPlaying = false,
    isFullscreenPlaying = false,
    isRewardedPlaying = false,
    isPreloaderPlaying = false
}
M["ads.showFullscreen"] = function()
    M.send(callback_ids.ads_start)
    M.send(callback_ids.ads_fullscreen_start)
    local result = M.ads_fullscreen_result
    M.send(callback_ids.ads_close, result)
    M.send(callback_ids.ads_fullscreen_close, result)
    return result
end
M["ads.showPreloader"] = function()
    M.send(callback_ids.ads_start)
    M.send(callback_ids.ads_preloader_start)
    local result = M.ads_preloader_result
    M.send(callback_ids.ads_close, result)
    M.send(callback_ids.ads_preloader_close, result)
    return result
end
M["ads.showRewardedVideo"] = function()
    M.send(callback_ids.ads_start)
    M.send(callback_ids.ads_rewarded_start)
    local result = M.ads_rewarded_result
    M.send(callback_ids.ads_close, result)
    M.send(callback_ids.ads_rewarded_close, result)
    if result then
        M.send(callback_ids.ads_rewarded_reward)
    end
    return result
end
M["ads.showSticky"] = function()
    M.send(callback_ids.ads_start)
    M.send(callback_ids.ads_sticky_start)
    M.send(callback_ids.ads_sticky_render)
    local result = M.ads.isStickyPlaying == false
    M.ads.isStickyPlaying = true
    return result
end
M["ads.refreshSticky"] = function()
    M.send(callback_ids.ads_sticky_refresh)
    M.send(callback_ids.ads_sticky_render)
    M.ads.isStickyPlaying = true
    return true
end
M["ads.closeSticky"] = function()
    M.send(callback_ids.ads_close, true)
    M.send(callback_ids.ads_sticky_close)
    M.ads.isStickyPlaying = false
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
    fields = M.fields_data
}
M["leaderboard.fetchPlayerRating"] = {
    fields = M.fields_data,
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
    M.send(callback_ids.achievements_unlock, result)
    return { achievement = result, success = true, error = "" }
end
M["achievements.open"] = function()
    M.send(callback_ids.achievements_fetch, M.achievement_data)
    M.send(callback_ids.achievements_open)
    M.send(callback_ids.achievements_close)
end
M["achievements.fetch"] = function()
    M.send(callback_ids.achievements_fetch, M.achievement_data)
    return M.achievement_data
end

-- покупки
local payments_data = {}
M.product_data = {
    products = {
        {
            description = "my product",
            price = 123,
            currency = "GS",
            icon = "https://cdn.gamepush.com/static/256x256/images/achievements/flash.png",
            iconSmall = "https://cdn.gamepush.com/static/48x48/images/achievements/flash.png",
            id = 29,
            currencySymbol = "GS'а",
            yandexId = "",
            name = "my_product",
            tag = "my_product"
        },
    },
    playerPurchases = {}
}
M["payments.isAvailable"] = { value = true }
M["payments.purchase"] = function(product)
    for _, item in pairs(M.product_data.products) do
        if item.id == product.id or item.tag == product.tag then
            local id = product.tag or product.id
            if payments_data[id] then
                payments_data[id] = payments_data[id] + 1
            else
                payments_data[id] = 1
            end
            local purchase = {
                payload = {},
                productId = product.id or 0
            }
            M.send(callback_ids.payments_purchase, { ["purchase"] = purchase, ["product"] = item })
            return { ["purchase"] = purchase, ["product"] = item, success = true, error = "" }
        end
    end
    local result = { message = "purchase_not_found" }
    M.send(callback_ids.payments_purchase_error, result)
    return result
end
M["payments.consume"] = function(product)
    for _, item in pairs(M.product_data.products) do
        if item.id == product.id or item.tag == product.tag then
            local id = product.tag or product.id
            if payments_data[id] ~= nil and payments_data[id] > 0 then
                payments_data[id] = payments_data[id] - 1
                local purchase = {
                    payload = {},
                    productId = product.id or 0
                }
                M.send(callback_ids.payments_consume, { ["purchase"] = purchase, ["product"] = item })
                return { ["purchase"] = purchase, ["product"] = item, success = true, error = "" }
            end
        end
    end
    local result = { message = "purchase_not_found" }
    M.send(callback_ids.payments_consume_error, result)
    return result
end
M["payments.has"] = function(product_id)
    return { value = payments_data[product_id] ~= nil and payments_data[product_id] > 0 }
end
M["payments.fetchProducts"] = function()
    M.send(callback_ids.payments_fetch_products, M.product_data)
    return M.product_data
end

-- Игровые переменные
M["variables.fetch"] = function()
    M.send(callback_ids.game_variables_fetch)
end
M["variables.get"] = { value = "val" }
M["variables.has"] = { value = true }
M["variables.type"] = { value = "data" }

-- социальные действия
M["socials"] = {
    isSupportsNativeShare = false,
    isSupportsNativePosts = false,
    isSupportsNativeInvite = false,
    canJoinCommunity = false,
    isSupportsNativeCommunityJoin = false,
    communityLink = ""
}

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
    M.send(callback_ids.payments_fetch_products, M.games_collections_data)
end
M["gamesCollections.fetch"] = function()
    M.send(callback_ids.payments_fetch_products, M.games_collections_data)
    return M.games_collections_data
end

return M