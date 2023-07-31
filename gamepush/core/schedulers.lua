local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")
local callbacks = require("gamepush.core.callbacks")

---Принять награду за день
---@param id_or_tag string|number тег или идентификатор планировщика
---@param day number день
---@param callback function функция обратного вызова по результату выдачи награды: callback(result)
function M.claim_day(id_or_tag, day, callback)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    helpers.check_number(day, "day")
    helpers.check_callback(callback)
    core.call_api("schedulers.claimDay", { id_or_tag, day }, callback)
end

---Принять награду за день за дополнительную активность
---@param id_or_tag string|number тег или идентификатор планировщика
---@param day number день
---@param trigger_id_or_tag string тег или идентификатор триггера
---@param callback function функция обратного вызова по результату выдачи награды: callback(result)
function M.claim_day_additional(id_or_tag, day, trigger_id_or_tag, callback)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    helpers.check_number(day, "day")
    helpers.check_string(trigger_id_or_tag, "trigger_id_or_tag")
    helpers.check_callback(callback)
    core.call_api("schedulers.claimDayAdditional", { id_or_tag, day, trigger_id_or_tag }, callback)
end

---Принять награду за день за все активности
---@param id_or_tag string|number тег или идентификатор планировщика
---@param day number день
---@param callback function функция обратного вызова по результату выдачи награды: callback(result)
function M.claim_all_day(id_or_tag, day, callback)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    helpers.check_number(day, "day")
    helpers.check_callback(callback)
    core.call_api("schedulers.claimAllDay", { id_or_tag, day }, callback)
end

---Принять награду за все выполненные дни
---@param id_or_tag string|number тег или идентификатор планировщика
---@param callback function функция обратного вызова по результату выдачи награды: callback(result)
function M.claim_all_days(id_or_tag, callback)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    helpers.check_callback(callback)
    core.call_api("schedulers.claimAllDays", id_or_tag, callback)
end

---Список планировщиков
---@return table результат
function M.list()
    return core.call_api("schedulers.list")
end

---Список активных планировщиков игрока
---@return table результат
function M.active_list()
    return core.call_api("schedulers.activeList")
end

---Получение информации о планировщике
---@param id_or_tag string|number тег или идентификатор планировщика
---@return table результат
function M.get_scheduler(id_or_tag)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    return core.call_api("schedulers.getScheduler", id_or_tag)
end

---Получение информации о дне планировщика
---@param id_or_tag string|number тег или идентификатор планировщика
---@param day number день
---@return table результат
function M.get_scheduler_day(id_or_tag, day)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    helpers.check_number(day, "day")
    return core.call_api("schedulers.getSchedulerDay", { id_or_tag, day })
end

---Получение информации о текущем дне планировщика
---@param id_or_tag string|number тег или идентификатор планировщика
---@return table результат
function M.get_scheduler_current_day(id_or_tag)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    return core.call_api("schedulers.getSchedulerCurrentDay", id_or_tag)
end

---Игрок участвует в планировщике
---@param id_or_tag string|number тег или идентификатор планировщика
---@return table результат
function M.is_registered(id_or_tag)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    return core.call_api("schedulers.isRegistered", id_or_tag) == true
end

---Сегодня принята награда
---@param id_or_tag string|number тег или идентификатор планировщика
---@return table результат
function M.is_today_reward_claimed(id_or_tag)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    return core.call_api("schedulers.isTodayRewardClaimed", id_or_tag) == true
end

---Можно забрать награду за день
---@param id_or_tag string|number тег или идентификатор планировщика
---@param day number день
---@return table результат
function M.can_claim_day(id_or_tag, day)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    helpers.check_number(day, "day")
    return core.call_api("schedulers.canClaimDay", { id_or_tag, day }) == true
end

---Можно забрать награду за дополнительную активность за день
---@param id_or_tag string|number тег или идентификатор планировщика
---@param day number день
---@param trigger_id_or_tag string тег или идентификатор триггера
---@return table результат
function M.can_claim_day_additional(id_or_tag, day, trigger_id_or_tag)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    helpers.check_number(day, "day")
    helpers.check_string(trigger_id_or_tag, "trigger_id_or_tag")
    return core.call_api("schedulers.canClaimDayAdditional", { id_or_tag, day, trigger_id_or_tag }) == true
end

---Можно забрать награду за все активности за день
---@param id_or_tag string|number тег или идентификатор планировщика
---@param day number день
---@return table результат
function M.can_claim_all_day(id_or_tag, day)
    helpers.check_string_or_number(id_or_tag, "id_or_tag")
    helpers.check_number(day, "day")
    return core.call_api("schedulers.canClaimAllDay", { id_or_tag, day }) == true
end

M.callbacks = callbacks.schedulers

return M