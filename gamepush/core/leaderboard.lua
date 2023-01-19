local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")

---Показать таблицу лидеров во внутриигровом оверлее
---@param parameters table|nil параметры вывода
function M.open(parameters)
    helpers.check_table(parameters)
    core.call_api("leaderboard.open", { parameters })
end

---Получить таблицу лидеров
---@param parameters table|nil параметры вывода
---@param callback function функция обратного вызова по результату получения получения таблицы: callback(leaders)
function M.fetch(parameters, callback)
    helpers.check_table(parameters)
    helpers.check_callback(callback)
    core.call_api("leaderboard.fetch", { parameters }, callback)
end

---Получить рейтинг игрока
---@param parameters table|nil параметры вывода
---@param callback function функция обратного вызова по результату получения получения таблицы: callback(leaders)
function M.fetch_player_rating(parameters, callback)
    helpers.check_table(parameters)
    helpers.check_callback(callback)
    core.call_api("leaderboard.fetchPlayerRating", { parameters }, callback)
end

---Показать изолированную таблицу лидеров во внутриигровом оверлее
---@param parameters table|nil параметры вывода
---@param callback function функция обратного вызова по результату показа: callback(result)
function M.open_scoped(parameters, callback)
    helpers.check_table_required(parameters)
    helpers.check_callback(callback)
    core.call_api("leaderboard.openScoped", { parameters }, callback)
end

---Получить изолированную таблицу лидеров
---@param parameters table|nil параметры вывода
---@param callback function функция обратного вызова по результату получения получения таблицы: callback(leaders)
function M.fetch_scoped(parameters, callback)
    helpers.check_table_required(parameters)
    helpers.check_callback(callback)
    core.call_api("leaderboard.fetchScoped", { parameters }, callback)
end

---Публикация рекорда игрока в изолированную таблицу
---@param parameters table таблица с параметрами и рекордом для записи
---@param callback function функция обратного вызова по результату публикации рекорда: callback(result)
function M.publish_record(parameters, callback)
    helpers.check_table_required(parameters)
    helpers.check_callback(callback)
    core.call_api("leaderboard.publishRecord", { parameters }, callback)
end

---Получить рейтинг игрока в изолированной таблице
---@param parameters table параметры вывода
---@param callback function функция обратного вызова по результату получения получения таблицы: callback(leaders)
function M.fetch_player_rating_scoped(parameters, callback)
    helpers.check_table_required(parameters)
    helpers.check_callback(callback)
    core.call_api("leaderboard.fetchPlayerRatingScoped", { parameters }, callback)
end

return M