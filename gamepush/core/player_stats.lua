local M = {}
local core = require("gamepush.core.core")

---Количество дней в игре
---@return boolean
function M.active_days()
    return core.call_api("player.stats.activeDays")
end

---Количество дней в игре подряд
---@return boolean
function M.active_days_consecutive()
    return core.call_api("player.stats.activeDaysConsecutive")
end

---Количество секунд, проведенных в игре сегодня
---@return boolean
function M.playtime_today()
    return core.call_api("player.stats.playtimeToday")
end

---Количество секунд, проведенных в игре за все время
---@return boolean
function M.playtime_all()
    return core.call_api("player.stats.playtimeAll")
end

return M