local M = {}
local core = require("gamepush.core.core")
local callbacks = require("gamepush.core.callbacks")

---Войти в полноэкранный режим
function M.open()
    core.call_api("fullscreen.open")
end

---Выйти из полноэкранного режима
function M.close()
    core.call_api("fullscreen.close")
end

---Переключить полноэкранный режим
function M.toggle()
    core.call_api("fullscreen.toggle")
end

M.callbacks = callbacks.fullscreen

return M