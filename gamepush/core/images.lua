local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")
local callbacks = require("gamepush.core.callbacks")

---Загрузить изображение
---@param parameters table
---@param callback function функция обратного вызова по результату загрузки изображения: callback(image)
function M.upload(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("images.upload", { parameters }, callback)
end

---Загрузить изображение по URL
---@param parameters table
---@param callback function функция обратного вызова по результату загрузки изображения: callback(image)
function M.upload_url(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("images.uploadUrl", { parameters }, callback)
end

---Выбрать файл
---@param callback function функция обратного вызова по результату выбора изображения: callback(result)
function M.choice_file(callback)
    helpers.check_callback(callback)
    core.call_api("images.chooseFile", nil, callback)
end

---Получить изображения
---@param parameters table
---@param callback function функция обратного вызова по результату получения изображений: callback(result)
function M.fetch(parameters, callback)
    helpers.check_table(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("images.fetch", { parameters }, callback)
end

---Получить еще изображений
---@param parameters table
---@param callback function функция обратного вызова по результату получения изображений: callback(result)
function M.fetch_more(parameters, callback)
    helpers.check_table(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("images.fetchMore", { parameters }, callback)
end

---Изменить размер изображения
---@param uri string ссылка на изображение
---@param width number требуемая ширина изображения
---@param height number требуемая высота изображения
---@param crop boolean обрезка изображения
---@return string возвращает ссылку на обрезанное изображение
function M.resize(uri, width, height, crop)
    helpers.check_string(uri, "uri")
    helpers.check_number_value(width, "width", true)
    helpers.check_number_value(height, "height", true)
    helpers.check_boolean(crop, "crop", true)
    return core.call_api("images.resize", { uri, width, height, crop }).value
end

---Проверить возможность загрузки изображений
---@return boolean возможность загрузки изображений
function M.can_upload()
    return core.call_api("images.canUpload").value == true
end

M.callbacks = callbacks.images

return M