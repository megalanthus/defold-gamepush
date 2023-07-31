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

---Список групп достижений
---@return table результат
function M.groups_list()
    return core.call_api("achievements.groupsList")
end

---Список достижений
---@return table результат
function M.list()
    return core.call_api("achievements.list")
end

---Список разблокированных достижений
---@return table результат
function M.unlocked_list()
    return core.call_api("achievements.unlockedList")
end

---Разблокировать достижение
---@param parameters table параметры
---@param callback function функция обратного вызова по результату разблокировки достижения: callback(result)
function M.unlock(parameters, callback)
    helpers.check_table_required(parameters)
    helpers.check_callback(callback)
    core.call_api("achievements.unlock", { parameters }, callback)
end

---Установить прогресс в достижении
---@param parameters table параметры
---@param callback function функция обратного вызова по результату установки прогресса в достижении: callback(result)
function M.set_progress(parameters, callback)
    helpers.check_table_required(parameters)
    helpers.check_callback(callback)
    core.call_api("achievements.setProgress", { parameters }, callback)
end

---Проверить есть ли у игрока достижение
---@param id_or_tag string|number тег или идентификатор достижения
---@return boolean результат
function M.has(id_or_tag)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    return core.call_api("achievements.has", id_or_tag) == true
end

---Получить прогресс достижения
---@param id_or_tag string|number тег или идентификатор достижения
---@return number результат
function M.get_progress(id_or_tag)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    return core.call_api("achievements.getProgress", id_or_tag)
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