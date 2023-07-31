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
---@param reward string|number тег или идентификатор награды
---@return table результат
function M.get_reward(reward)
    helpers.check_string_or_number(reward, "reward")
    return core.call_api("rewards.getReward", reward)
end

---Проверка выдачи награды
---@param reward string|number тег или идентификатор награды
---@return boolean результат
function M.has(reward)
    helpers.check_string_or_number(reward, "reward")
    return core.call_api("rewards.has", reward) == true
end

---Проверка принятия награды
---@param reward string|number тег или идентификатор награды
---@return boolean результат
function M.has_accepted(reward)
    helpers.check_string_or_number(reward, "reward")
    return core.call_api("rewards.hasAccepted", reward) == true
end

---Награда выдана, но не получена
---@param reward string|number тег или идентификатор награды
---@return boolean результат
function M.has_unaccepted(reward)
    helpers.check_string_or_number(reward, "reward")
    return core.call_api("rewards.hasUnaccepted", reward) == true
end

M.callbacks = callbacks.rewards

return M