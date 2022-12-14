local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")

---Посещение или просмотр страницы
---@param url string адрес страницы
function M.hit(url)
    helpers.check_string(url, "url")
    core.call_api("analytics.hit", { url })
end

---Отправка достижения цели
---@param event string событие
---@param value string|number|boolean|nil значение
function M.goal(event, value)
    helpers.check_string(event, "event")
    if value then
        helpers.check_value(value)
    end
    core.call_api("analytics.goal", { event, value })
end

return M