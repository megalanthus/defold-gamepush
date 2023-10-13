local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")

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

---Предложить игроку оставить отзыв на игру
---@param callback function функция обратного вызова: callback(result)
function M.request_review(callback)
    helpers.check_callback(callback)
    core.call_api("app.requestReview", nil, callback)
end

---Проверить поддержку возможности оставить отзыв на игру
---@return boolean
function M.can_request_review()
    return core.call_api("app.canRequestReview") == true
end

---Проверить был ли оставлен отзыв
---@return boolean
function M.is_already_reviewed()
    return core.call_api("app.isAlreadyReviewed") == true
end

---Предложить игроку создать ярлык или добавить игру в избранное
---@return boolean
function M.add_shortcut(callback)
    helpers.check_callback(callback)
    core.call_api("app.addShortcut", nil, callback)
end

---Проверить поддержку возможности создать ярлык или добавить игру в избранное
---@return boolean
function M.can_add_shortcut()
    return core.call_api("app.canAddShortcut") == true
end

return M