local callback_ids = require("gamepush.core.callback_ids")

local M = {}

local function get_storage_file_name()
    local appname = sys.get_config_string("project.title")
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
M["serverTime"] = function()
    return os.date("%FT%T")
end
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
M["app.title"] = sys.get_config_string("project.title")
M["app.description"] = sys.get_config_string("gamepush.description")
M["app.image"] = sys.get_config_string("gamepush.image")
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
        projectId = sys.get_config_string("gamepush.id"),
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
M["socials.share"] = function()
    local result = true
    M.send(callback_ids.socials.share, result)
    return result
end
M["socials.post"] = function()
    local result = true
    M.send(callback_ids.socials.post, result)
    return result
end
M["socials.invite"] = function()
    local result = true
    M.send(callback_ids.socials.invite, result)
    return result
end
M["socials.joinCommunity"] = function()
    local result = true
    M.send(callback_ids.socials.joinCommunity, result)
    return result
end
M["socials.makeShareUrl"] = function(parameters)
    return string.format("%s#%s", M["app.url"], json.encode(parameters))
end
M["socials.getShareParam"] = function()
    return nil
end

-- хранилище
M.storage_data = {}
M.storage_global_data = {}
M["storage.type"] = "platform"
M["storage.setStorage"] = function(storage_type)
    M["storage.type"] = storage_type
end
M["storage.set"] = function(key, value)
    M.storage_data[key] = value
    M.send(callback_ids.storage["set"], { key = key, value = value })
    return true
end
M["storage.get"] = function(key)
    local value = M.storage_data[key]
    M.send(callback_ids.storage["get"], { key = key, value = value })
    return value
end
M["storage.setGlobal"] = function(key, value)
    M.storage_global_data[key] = value
    M.send(callback_ids.storage["set:global"], { key = key, value = value })
    return true
end
M["storage.getGlobal"] = function(key)
    local value = M.storage_global_data[key]
    M.send(callback_ids.storage["get:global"], { key = key, value = value })
    return value
end

-- сегменты
M["segments.list"] = {}
M["segments.has"] = function(tag)
    for _, segment_tag in pairs(M["segments.list"]) do
        if segment_tag == tag then
            return true
        end
    end
    return false
end

-- эксперименты
M["experiments.map"] = {}
M["experiments.has"] = function(tag, cohort)
    return M["experiments.map"][tag] == cohort
end

-- фидбеки
M.feedbacks_data = {}
M.feedbacks_auto_id = 1
M["feedbacks.send"] = function(parameters)
    local feedback = {
        id = M.feedbacks_auto_id,
        type = parameters.type or "SUGGESTION",
        text = parameters.text or "",
        status = "NEW",
        messages = {}
    }
    M.feedbacks_auto_id = M.feedbacks_auto_id + 1
    table.insert(M.feedbacks_data, feedback)
    M.send(callback_ids.feedbacks.createFeedback, feedback)
    return feedback
end
M["feedbacks.open"] = function()
    M.send(callback_ids.feedbacks.openFeedbacksList)
    return true
end
M["feedbacks.openFeedback"] = function(parameters)
    for _, feedback in ipairs(M.feedbacks_data) do
        if tostring(feedback.id) == tostring(parameters.feedbackId) then
            return feedback
        end
    end
    return nil
end
M["feedbacks.fetch"] = function()
    local result = {
        items = M.feedbacks_data,
        canLoadMore = false
    }
    M.send(callback_ids.feedbacks.fetchFeedbacks, result)
    return result
end
M["feedbacks.fetchMore"] = function()
    local result = {
        items = {},
        canLoadMore = false
    }
    M.send(callback_ids.feedbacks.fetchMoreFeedbacks, result)
    return result
end
M["feedbacks.sendMessage"] = function(parameters)
    local message = {
        id = string.format("message-%d", os.time()),
        text = parameters.text or "",
        feedbackId = parameters.feedbackId,
        author = "PLAYER",
        attachments = parameters.files or {}
    }
    for _, feedback in ipairs(M.feedbacks_data) do
        if tostring(feedback.id) == tostring(parameters.feedbackId) then
            table.insert(feedback.messages, message)
            break
        end
    end
    M.send(callback_ids.feedbacks.sendMessage, message)
    M.send(callback_ids.feedbacks["event:feedbackMessage"], message)
    return message
end

-- реакции
M.reactions_data = {}
local function reaction_key(parameters)
    return string.format("%s:%s:%s", parameters.entityType or "", parameters.entityId or "", parameters.reactionType or "")
end
M["reactions.set"] = function(parameters)
    local key = reaction_key(parameters)
    local counter = (M.reactions_data[key] or 0) + 1
    M.reactions_data[key] = counter
    local result = {
        entityType = parameters.entityType,
        entityId = parameters.entityId,
        reactionType = parameters.reactionType,
        counter = counter
    }
    M.send(callback_ids.reactions["set"], result)
    M.send(callback_ids.reactions["event:set"], result)
    return result
end
M["reactions.unset"] = function(parameters)
    local key = reaction_key(parameters)
    local counter = math.max((M.reactions_data[key] or 1) - 1, 0)
    M.reactions_data[key] = counter
    local result = {
        entityType = parameters.entityType,
        entityId = parameters.entityId,
        reactionType = parameters.reactionType,
        counter = counter
    }
    M.send(callback_ids.reactions["unset"], result)
    M.send(callback_ids.reactions["event:unset"], result)
    return result
end

-- уникальные значения
M.uniques_data = {}
M["uniques.list"] = {}
M["uniques.get"] = function(tag)
    return M.uniques_data[tag]
end
M["uniques.register"] = function(parameters)
    local unique = {
        tag = parameters.tag,
        value = parameters.value
    }
    M.uniques_data[parameters.tag] = parameters.value
    local list = {}
    for tag, value in pairs(M.uniques_data) do
        table.insert(list, { tag = tag, value = value })
    end
    M["uniques.list"] = list
    M.send(callback_ids.uniques.register, unique)
    return { success = true, value = unique }
end
M["uniques.check"] = function(parameters)
    local result = M.uniques_data[parameters.tag] ~= parameters.value
    if result then
        M.send(callback_ids.uniques.check, { tag = parameters.tag, value = parameters.value })
    else
        M.send(callback_ids.uniques["error:check"], "already_exists")
    end
    return { success = result }
end
M["uniques.delete"] = function(parameters)
    local current_value = M.uniques_data[parameters.tag]
    M.uniques_data[parameters.tag] = nil
    local list = {}
    for tag, value in pairs(M.uniques_data) do
        table.insert(list, { tag = tag, value = value })
    end
    M["uniques.list"] = list
    local result = {
        tag = parameters.tag,
        value = current_value
    }
    M.send(callback_ids.uniques.delete, result)
    return { success = true, value = result }
end

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
    M.send(callback_ids.gamesCollections.open)
    M.send(callback_ids.gamesCollections.close)
end
M["gamesCollections.fetch"] = function()
    M.send(callback_ids.gamesCollections.fetch, M.games_collections_data)
    return M.games_collections_data
end

return M