local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")

---Поддерживается ли шаринг
---@return boolean результат
function M.is_supports_share()
    return core.call_api("socials.isSupportsShare") == true
end

---Проверка поддержки нативного шаринга
---@return boolean результат
function M.is_supports_native_share()
    return core.call_api("socials.isSupportsNativeShare") == true
end

---Поделиться
---@param parameters table|nil
function M.share(parameters)
    helpers.check_table(parameters, "parameters")
    core.call_api("socials.share", { parameters })
end

---Поддерживается ли нативный постинг
---@return boolean результат
function M.is_supports_native_posts()
    return core.call_api("socials.isSupportsNativePosts") == true
end

---Опубликовать пост
---@param parameters table|nil
function M.post(parameters)
    helpers.check_table(parameters, "parameters")
    core.call_api("socials.post", { parameters })
end

---Проверка поддержки нативных инвайтов
---@return boolean результат
function M.is_supports_native_invite()
    return core.call_api("socials.isSupportsNativeInvite") == true
end

---Пригласить друзей
---@param parameters table|nil
function M.invite(parameters)
    helpers.check_table(parameters, "parameters")
    core.call_api("socials.invite", { parameters })
end

---Можно ли приглашать в сообщество на текущей платформе
---@return boolean результат
function M.can_join_community()
    return core.call_api("socials.canJoinCommunity") == true
end

---Поддерживается ли нативное вступление в сообщество
---@return boolean результат
function M.is_supports_native_community_join()
    return core.call_api("socials.isSupportsNativeCommunityJoin") == true
end

---Вступить в сообщество
function M.join_community()
    core.call_api("socials.joinCommunity")
end

return M