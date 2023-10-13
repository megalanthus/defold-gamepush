local M = {}
local core = require("gamepush.core.core")

---Тост с информацией
---@param ... any информация для вывода
function M.info(...)
    core.call_api("logger.info", { ... })
end

---Тост с предупреждением
---@param ... any информация для вывода
function M.warn(...)
    core.call_api("logger.warn", { ... })
end

---Тост с ошибкой
---@param ... any информация для вывода
function M.error(...)
    core.call_api("logger.error", { ... })
end

---Лог в консоль
---@param ... any информация для вывода
function M.log(...)
    core.call_api("logger.log", { ... })
end

return M