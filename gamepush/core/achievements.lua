local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")
local callbacks = require("gamepush.core.callbacks")

M.rare = {
    COMMON = "COMMON",
    UNCOMMON = "UNCOMMON",
    RARE = "RARE",
    EPIC = "EPIC",
    LEGENDARY = "LEGENDARY",
    MYTHIC = "MYTHIC"
}

---Разблокировать достижение
---@param achievement number|string id или tag достижения
---@param callback function функция обратного вызова по результату разблокировки достижения: callback(result)
function M.unlock(achievement, callback)
    local parameters = helpers.make_parameters_id_or_tag(achievement, "Achievement")
    helpers.check_callback(callback)
    core.call_api("achievements.unlock", { parameters }, callback)
end

---Открыть достижения в оверлее
---@param callback function функция обратного вызова по результату открытия достижений: callback()
function M.open(callback)
    helpers.check_callback(callback)
    core.call_api("achievements.open", nil, callback)
end

---Запросить достижения
---@param callback function функция обратного вызова по результату запроса достижений: callback(achievements)
function M.fetch(callback)
    helpers.check_callback(callback)
    return core.call_api("achievements.fetch", nil, callback)
end

M.callbacks = callbacks.achievements

return M