local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")
local callbacks = require("gamepush.core.callbacks")

---Получить награду за триггер
---@param parameters table параметры
---@param callback function функция обратного вызова по результату выдачи награды: callback(result)
function M.claim(parameters, callback)
    helpers.check_table_required(parameters)
    helpers.check_callback(callback)
    core.call_api("triggers.claim", { parameters }, callback)
end

---Список триггеров
---@return table результат
function M.list()
    return core.call_api("triggers.list")
end

---Список активированных триггеров
---@return table результат
function M.activated_list()
    return core.call_api("triggers.activatedList")
end

---Получение информации о награде
---@param trigger string тег или идентификатор награды
---@return table результат
function M.get_trigger(trigger)
    helpers.check_string(trigger, "trigger")
    return core.call_api("triggers.getTrigger", trigger)
end

---Триггер активирован
---@param trigger string тег или идентификатор награды
---@return boolean результат
function M.is_activated(trigger)
    helpers.check_string(trigger, "trigger")
    return core.call_api("triggers.isActivated", trigger) == true
end

---Награда начислена
---@param trigger string тег или идентификатор награды
---@return boolean результат
function M.is_claimed(trigger)
    helpers.check_string_or_number(trigger, "trigger")
    return core.call_api("triggers.isClaimed", trigger) == true
end

M.callbacks = callbacks.triggers

return M