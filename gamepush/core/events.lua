local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")
local callbacks = require("gamepush.core.callbacks")

---Принять участие в событии
---@param parameters table параметры
---@param callback function функция обратного вызова по результату принятия участия в событии: callback(result)
function M.join(parameters, callback)
    helpers.check_table_required(parameters)
    helpers.check_callback(callback)
    core.call_api("events.join", { parameters }, callback)
end

---Список событий
---@return table результат
function M.list()
    return core.call_api("events.list")
end

---Список активных событий игрока
---@return table результат
function M.active_list()
    return core.call_api("events.activeList")
end

---Получение информации о событии
---@param id_or_tag string|number тег или идентификатор события
---@return table результат
function M.get_event(id_or_tag)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    return core.call_api("events.getEvent", id_or_tag)
end

---Событие активно
---@param id_or_tag string|number тег или идентификатор награды
---@return boolean результат
function M.has(id_or_tag)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    return core.call_api("events.has", id_or_tag) == true
end

---Игрок участвует в событии
---@param id_or_tag string|number тег или идентификатор награды
---@return boolean результат
function M.is_joined(id_or_tag)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    return core.call_api("events.isJoined", id_or_tag) == true
end

M.callbacks = callbacks.events

return M