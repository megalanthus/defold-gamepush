local M = {}

local version = string.format("GamePush for Defold v1.1.4")
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")
local callbacks = require("gamepush.core.callbacks")

M.callbacks = callbacks.common

M.languages = {
    ENGLISH = "en",
    RUSSIAN = "ru",
    FRENCH = "fr",
    ITALIAN = "it",
    GERMAN = "de",
    SPANISH = "es",
    CHINESE = "zh",
    PORTUGUESE = "pt",
    KOREAN = "ko",
    JAPANESE = "ja",
    TURKISH = "tr",
    ARAB = "ar",
    HINDI = "hi",
    INDONESIAN = "id"
}

---Инициализация GamePush
---@param callback function функция обратного вызова по завершению инициализации: callback(success)
function M.init(callback)
    core.init(callback)
end

---Получить текущий язык
---@return string код языка в формате ISO 639-1
function M.language()
    return core.call_api("language")
end

---Установить язык
---@param language_code string код языка в формате ISO 639-1
function M.change_language(language_code)
    if type(language_code) ~= "string" then
        error("The language code must be a string!", 2)
    end
    core.call_api("changeLanguage", language_code)
end

---Мобильное устройство?
---@return boolean
function M.is_mobile()
    return core.call_api("isMobile") == true
end

---Режим экрана: портретный/альбомный?
---@return boolean
function M.is_portrait()
    return core.call_api("isPortrait") == true
end

---В разработке?
---@return boolean
function M.is_dev()
    return core.call_api("isDev") == true
end

---Хост игры в доверенных источниках?
---@return boolean
function M.is_allowed_origin()
    return core.call_api("isAllowedOrigin") == true
end

---Возвращает серверное время
---@return string
function M.get_server_time()
    return core.call_api("serverTime")
end

---На паузе?
---@return boolean
function M.is_paused()
    return core.call_api("isPaused") == true
end

---Поставить на паузу
function M.pause()
    core.call_api("pause")
end

---Возобновить
function M.resume()
    core.call_api("resume")
end

---Установить фоновое изображение игры
---@param parameters table параметры
function M.set_background(parameters)
    helpers.check_table_required(parameters)
    core.call_api("setBackground", { parameters })
end

---Старт игры
function M.game_start()
    core.call_api("gameStart")
end

---Запуск геймплея
function M.gameplay_start()
    core.call_api("gameplayStart")
end

---Завершение геймплея
function M.gameplay_stop()
    core.call_api("gameplayStop")
end

---Возвращает версию плагина
---@return string
function M.get_plugin_version()
    return version
end

M.app = require("gamepush.core.app")
M.platform = require("gamepush.core.platform")
M.player = require("gamepush.core.player")
M.players = require("gamepush.core.players")
M.payments = require("gamepush.core.payments")
M.leaderboard = require("gamepush.core.leaderboard")
M.channels = require("gamepush.core.channels")
M.events = require("gamepush.core.events")
M.rewards = require("gamepush.core.rewards")
M.schedulers = require("gamepush.core.schedulers")
M.triggers = require("gamepush.core.triggers")
M.ads = require("gamepush.core.ads")
M.achievements = require("gamepush.core.achievements")
M.socials = require("gamepush.core.socials")
M.variables = require("gamepush.core.variables")
M.games_collections = require("gamepush.core.games_collections")
M.images = require("gamepush.core.images")
M.files = require("gamepush.core.files")
M.documents = require("gamepush.core.documents")
M.analytics = require("gamepush.core.analytics")
M.fullscreen = require("gamepush.core.fullscreen")

return M