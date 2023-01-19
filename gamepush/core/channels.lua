local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")
local callbacks = require("gamepush.core.callbacks")

---Создание канала
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(channel)
function M.create_channel(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.createChannel", { parameters }, callback)
end

---Обновление канала
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(channel)
function M.update_channel(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.updateChannel", { parameters }, callback)
end

---Удаление канала
---@param parameters table параметры
---@param callback function функция обратного вызова: callback()
function M.delete_channel(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.deleteChannel", { parameters }, callback)
end

---Получить информацию о канале по ID
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(channel)
function M.fetch_channel(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchChannel", { parameters }, callback)
end

---Получить список каналов
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.fetch_channels(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchChannels", { parameters }, callback)
end

---Подгрузить список каналов
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.fetch_more_channels(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchMoreChannels", { parameters }, callback)
end

---Запрос на вступление в публичный канал
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.join(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.join", { parameters }, callback)
end

---Отмена запроса на вступление
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.cancel_join(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.cancelJoin", { parameters }, callback)
end

---Выход из канала
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.leave(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.leave", { parameters }, callback)
end

---Исключение участника из канала
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.kick(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.kick", { parameters }, callback)
end

---Получить участников
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.fetch_members(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchMembers", { parameters }, callback)
end

---Подгрузить участников
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.fetch_more_members(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchMoreMembers", { parameters }, callback)
end

---Мьют игрока в канале
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.mute(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.mute", { parameters }, callback)
end

---Отменить мьют игрока
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.unmute(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.unmute", { parameters }, callback)
end

---Отправка приглашения
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.send_invite(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.sendInvite", { parameters }, callback)
end

---Отмена приглашения
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.cancel_invite(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.cancelInvite", { parameters }, callback)
end

---Принять приглашение
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.accept_invite(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.acceptInvite", { parameters }, callback)
end

---Отклонить приглашение
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.reject_invite(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.rejectInvite", { parameters }, callback)
end

---Получить список приглашений игрока в каналы
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.fetch_invites(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchInvites", { parameters }, callback)
end

---Подгрузить список приглашений игрока в каналы
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.fetch_more_invites(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchMoreInvites", { parameters }, callback)
end

---Получить список отправленных приглашений из канала
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.fetch_channel_invites(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchChannelInvites", { parameters }, callback)
end

---Подгрузить список отправленных приглашений из канала
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.fetch_more_channel_invites(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchMoreChannelInvites", { parameters }, callback)
end

---Получить список разосланных приглашений игрокам в каналы
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.fetch_sent_invites(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchSentInvites", { parameters }, callback)
end

---Подгрузить список разосланных приглашений игрокам в каналы
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.fetch_more_sent_invites(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchMoreSentInvites", { parameters }, callback)
end

---Принять запрос на вступление
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.accept_join_request(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.acceptJoinRequest", { parameters }, callback)
end

---Отклонить запрос на вступление
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.reject_join_request(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.rejectJoinRequest", { parameters }, callback)
end

---Получить список входящих запросов на вступление в выбранном канале
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.fetch_join_requests(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchJoinRequests", { parameters }, callback)
end

---Подгрузить список входящих запросов на вступление в выбранном канале
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.fetch_more_join_requests(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchMoreJoinRequests", { parameters }, callback)
end

---Получить список разосланных запросов игроком на вступление
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.fetch_sent_join_requests(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchSentJoinRequests", { parameters }, callback)
end

---Подгрузить список разосланных запросов игроком на вступление
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.fetch_more_sent_join_requests(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchMoreSentJoinRequests", { parameters }, callback)
end

---Отправка сообщения
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.send_message(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.sendMessage", { parameters }, callback)
end

---Отправка личного сообщения
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.send_personal_message(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.sendPersonalMessage", { parameters }, callback)
end

---Отправка сообщения в фид
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.send_feed_message(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.sendFeedMessage", { parameters }, callback)
end

---Изменение сообщения
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.edit_message(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.editMessage", { parameters }, callback)
end

---Удаление сообщения
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.delete_message(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.deleteMessage", { parameters }, callback)
end

---Получить список сообщений в выбранном канале
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.fetch_messages(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchMessages", { parameters }, callback)
end

---Получить список личных сообщений с другим игроком
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.fetch_personal_messages(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchPersonalMessages", { parameters }, callback)
end

---Получить список сообщений в фиде игрока
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.fetch_feed_messages(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchFeedMessages", { parameters }, callback)
end

---Подгрузить список сообщений в выбранном канале
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.fetch_more_messages(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchMoreMessages", { parameters }, callback)
end

---Подгрузить список личных сообщений с другим игроком
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.fetch_more_personal_messages(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchMorePersonalMessages", { parameters }, callback)
end

---Подгрузить список сообщений в фиде игрока
---@param parameters table параметры
---@param callback function функция обратного вызова: callback(result)
function M.fetch_more_feed_messages(parameters, callback)
    helpers.check_table_required(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("channels.fetchMoreFeedMessages", { parameters }, callback)
end

M.callbacks = callbacks.channels

return M