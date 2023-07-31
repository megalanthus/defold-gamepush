local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")
local callbacks = require("gamepush.core.callbacks")

---Выдать награду
---@param parameters table параметры
---@param callback function функция обратного вызова по результату выдачи награды: callback(result)
function M.give(parameters, callback)
    helpers.check_table_required(parameters)
    helpers.check_callback(callback)
    core.call_api("rewards.give", { parameters }, callback)
end

---Принять награду
---@param parameters table параметры
---@param callback function функция обратного вызова по результату принятия награды: callback(result)
function M.accept(parameters, callback)
    helpers.check_table_required(parameters)
    helpers.check_callback(callback)
    core.call_api("rewards.accept", { parameters }, callback)
end

---Список наград
---@return table результат
function M.list()
    return core.call_api("rewards.list")
end

---Список выданных наград
---@return table результат
function M.given_list()
    return core.call_api("rewards.givenList")
end

---Получение информации о награде
---@param id_or_tag string|number тег или идентификатор награды
---@return table результат
function M.get_reward(id_or_tag)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    return core.call_api("rewards.getReward", id_or_tag)
end

---Проверка выдачи награды
---@param id_or_tag string|number тег или идентификатор награды
---@return boolean результат
function M.has(id_or_tag)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    return core.call_api("rewards.has", id_or_tag) == true
end

---Проверка принятия награды
---@param id_or_tag string|number тег или идентификатор награды
---@return boolean результат
function M.has_accepted(id_or_tag)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    return core.call_api("rewards.hasAccepted", id_or_tag) == true
end

---Награда выдана, но не получена
---@param id_or_tag string|number тег или идентификатор награды
---@return boolean результат
function M.has_unaccepted(id_or_tag)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    return core.call_api("rewards.hasUnaccepted", id_or_tag) == true
end

M.callbacks = callbacks.rewards

return M