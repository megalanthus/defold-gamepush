local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")
local callbacks = require("gamepush.core.callbacks")

---Открыть оверлей с играми
---@param parameters table параметры
---@param callback function функция обратного вызова по результату открытия оверлея: callback()
function M.open(parameters, callback)
    helpers.check_table(parameters)
    helpers.check_callback(callback)
    core.call_api("gamesCollections.open", { parameters }, callback)
end

---Получить коллекцию игр
---@param parameters table параметры
---@param callback function функция обратного вызова по результату получения коллекции игр: callback(result)
---@return table
function M.fetch(parameters, callback)
    helpers.check_table(parameters)
    helpers.check_callback(callback)
    core.call_api("gamesCollections.fetch", { parameters }, callback)
end

M.callbacks = callbacks.games_collections

return M