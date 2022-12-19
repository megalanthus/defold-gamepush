local M = {}
local core = require("gamepush.core.core")

---Название игры
---@return string
function M.title()
    return core.call_api("app.title")
end

---Описание игры
---@return string
function M.description()
    return core.call_api("app.description")
end

---Изображение
---@return string
function M.image()
    return core.call_api("app.image")
end

---Url игры
---@return string
function M.url()
    return core.call_api("app.url")
end

return M