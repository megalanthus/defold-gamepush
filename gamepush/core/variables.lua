local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")
local callbacks = require("gamepush.core.callbacks")

M.types = {
    DATA = "data",
    STATS = "stats",
    FLAG = "flag",
    DOC_HTML = "doc_html",
    IMAGE = "image",
    FILE = "file"
}

---Запросить переменные
---@param callback function функция обратного вызова по результату запроса переменных: callback()
function M.fetch(callback)
    helpers.check_callback(callback)
    core.call_api("variables.fetch", nil, callback)
end

---Получить значение переменной
---@param variable string название переменной
function M.get(variable)
    helpers.check_string(variable, "variable")
    return core.call_api("variables.get", { variable })
end

---Проверить существование переменной
---@param variable string название переменной
---@return boolean результат
function M.has(variable)
    helpers.check_string(variable, "variable")
    return core.call_api("variables.has", { variable }) == true
end

---Получить тип переменной
---@param variable string название переменной
---@return string результат
function M.type(variable)
    helpers.check_string(variable, "variable")
    return core.call_api("variables.type", { variable })
end

M.callbacks = callbacks.variables

return M