local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")
local callbacks = require("gamepush.core.callbacks")

---Загрузить файл
---@param parameters table
---@param callback function функция обратного вызова по результату загрузки файла: callback(result)
function M.upload(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("files.upload", { parameters }, callback)
end

---Загрузить файл по URL
---@param parameters table
---@param callback function функция обратного вызова по результату загрузки файла: callback(result)
function M.upload_url(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("files.uploadUrl", { parameters }, callback)
end

---Загрузить контент
---@param parameters table
---@param callback function функция обратного вызова по результату загрузки контента: callback(result)
function M.upload_content(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("files.uploadContent", { parameters }, callback)
end

---Получить контент
---@param uri string имя файла для загрузки
---@param callback function функция обратного вызова по результату получения файла: callback(text)
function M.load_content(uri, callback)
    helpers.check_string(uri, "uri")
    helpers.check_callback(callback)
    core.call_api("files.loadContent", { uri }, callback)
end

---Выбрать файл
---@param accept string типы файлов для выбора
---@param callback function функция обратного вызова по результату выбора файла: callback(result)
function M.choose_file(accept, callback)
    helpers.check_string(accept, "accept", true)
    helpers.check_callback(callback)
    core.call_api("files.chooseFile", nil, callback)
end

---Получить файлы
---@param parameters table
---@param callback function функция обратного вызова по результату получения файлов: callback(result)
function M.fetch(parameters, callback)
    helpers.check_table(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("files.fetch", { parameters }, callback)
end

---Получить еще файлы
---@param parameters table
---@param callback function функция обратного вызова по результату получения файлов: callback(result)
function M.fetch_more(parameters, callback)
    helpers.check_table(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("files.fetchMore", { parameters }, callback)
end

---Проверить возможность загрузки файлов
---@return boolean возможность загрузки файлов
function M.can_upload()
    return core.call_api("files.canUpload").value == true
end

M.callbacks = callbacks.files

return M