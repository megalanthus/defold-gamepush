local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")
local callbacks = require("gamepush.core.callbacks")

---Показать окно подтверждения
---@param parameters table|nil параметры окна: title, description, textConfirm, textCancel, invertButtonColors, hideCancelButton
---@param callback function|nil callback(is_confirmed)
function M.show_confirm(parameters, callback)
    helpers.check_table(parameters)
    helpers.check_callback(callback)
    if parameters then
        core.call_api("windows.showConfirm", { parameters }, callback)
    else
        core.call_api("windows.showConfirm", nil, callback)
    end
end

M.callbacks = callbacks.windows

return M
