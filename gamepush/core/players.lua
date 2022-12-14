local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")

---Получить данные игроков
---@param parameters table параметры
---@param callback function функция обратного вызова по результату получения данных других игроков: callback(result)
function M.fetch(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("players.fetch", { parameters }, callback)
end

return M