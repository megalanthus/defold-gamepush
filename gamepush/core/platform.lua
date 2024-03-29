local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")

M.NONE = "NONE"
M.CRAZY_GAMES = "CRAZY_GAMES"
M.GAME_DISTRIBUTION = "GAME_DISTRIBUTION"
M.GAME_MONETIZE = "GAME_MONETIZE"
M.OK = "OK"
M.SMARTMARKET = "SMARTMARKET"
M.VK = "VK"
M.YANDEX = "YANDEX"
M.GAMEPIX = "GAMEPIX"
M.POKI = "POKI"
M.VK_PLAY = "VK_PLAY"
M.WG_PLAYGROUND = "WG_PLAYGROUND"

---Тип платформы
---@return string
function M.type()
    return core.call_api("platform.type")
end

---Возможность авторизации
---@return boolean
function M.has_integrated_auth()
    return core.call_api("platform.hasIntegratedAuth") == true
end

---Возможность размещать внешние ссылки
---@return boolean
function M.is_external_links_allowed()
    return core.call_api("platform.isExternalLinksAllowed") == true
end

---Доступен секретный код авторизации
---@return string
function M.is_secret_code_auth_available()
    return core.call_api("platform.isSecretCodeAuthAvailable") == true
end

---Выполнить нативный метод платформы. Если method API является объектом.
---@param method string выполняемый метод объект или поле объекта, например: "feedback.canReview"
---@param parameters any параметры метода, если параметров несколько, то таблица (массив) параметров.
---@param callback function|nil функция обратного вызова
---@return any результат выполнения операции или возвращаемые данные
function M.call_native_sdk(method, parameters, callback)
    if type(method) ~= "string" or method == "" then
        error("The method must be a string!", 2)
    end
    helpers.check_callback(callback)
    return core.call_api(method, parameters, callback, true)
end

return M