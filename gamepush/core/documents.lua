local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")
local callbacks = require("gamepush.core.callbacks")

---Открыть политику конфиденциальности
---@param parameters table
function M.open(parameters)
    helpers.check_table_required(parameters, "parameters")
    core.call_api("documents.open", { parameters })
end

---Получить политику конфиденциальности
---@param parameters table
---@param callback function функция обратного вызова по результату получения политики конфиденциальности: callback(document)
function M.fetch(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("documents.fetch", { parameters }, callback)
end

M.callbacks = callbacks.documents

return M