local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")
local callbacks = require("gamepush.core.callbacks")

M.MODE_FAST = "fast"
M.MODE_SMOOTH = "smooth"

---Подключиться к мультиплеерной комнате
---@param parameters table параметры: channelId
---@param callback function|nil callback(result)
function M.connect(parameters, callback)
    helpers.check_table_required(parameters)
    helpers.check_callback(callback)
    core.call_api("multiplayer.connect", { parameters }, callback)
end

---Отключиться от текущей комнаты
---@param parameters table|nil параметры: channelId
---@param callback function|nil callback(result)
function M.disconnect(parameters, callback)
    helpers.check_table(parameters)
    helpers.check_callback(callback)
    if parameters then
        core.call_api("multiplayer.disconnect", { parameters }, callback)
    else
        core.call_api("multiplayer.disconnect", nil, callback)
    end
end

---Определить синхронизируемые поля игрока
---@param schema table схема полей
function M.define_player_schema(schema)
    helpers.check_table_required(schema)
    core.call_api("multiplayer.definePlayerSchema", { schema })
end

---Определить синхронизируемые общие поля
---@param schema table схема полей
function M.define_global_schema(schema)
    helpers.check_table_required(schema)
    core.call_api("multiplayer.defineGlobalSchema", { schema })
end

---Инициализировать игроков на хосте
---@param initializer function function(player_id, player_info) return state
function M.set_player_initializer(initializer)
    if type(initializer) ~= "function" then
        error("The initializer must be a function!", 2)
    end
    callbacks.multiplayer.player_initializer = function(data)
        local state = initializer(data.playerId, data.playerInfo)
        core.call_api("multiplayer._completePlayerInit", { data.requestId, state or {} })
    end
    core.call_api("multiplayer.setPlayerInitializer")
end

---Обновить состояние текущего игрока
---@param state table частичное состояние
function M.set_player_state(state)
    helpers.check_table_required(state)
    core.call_api("multiplayer.setPlayerState", { state })
end

---Установить глобальное состояние (только хост)
---@param state table состояние мира
function M.set_global_state(state)
    helpers.check_table_required(state)
    core.call_api("multiplayer.setGlobalState", { state })
end

---Выбрать режим синхронизации
---@param mode string fast|smooth
function M.set_mode(mode)
    helpers.check_string(mode, "mode")
    core.call_api("multiplayer.setMode", { mode })
end

---Подписаться на игровой тик SDK
function M.on_tick()
    core.call_api("multiplayer.onTick")
end

---Отписаться от игрового тика SDK
function M.off_tick()
    core.call_api("multiplayer.offTick")
end

---Отправить одноразовое событие другим игрокам
---@param event_name string тип сообщения
---@param data any JSON-совместимые данные
---@param target_or_options string|number|table|nil цель, playerId или { target, echo }
function M.send_message(event_name, data, target_or_options)
    helpers.check_string(event_name, "event_name")
    local parameters = { event_name, data }
    if target_or_options ~= nil then
        table.insert(parameters, target_or_options)
    end
    core.call_api("multiplayer.sendMessage", parameters)
end

---Подписаться на сообщения мультиплеера
function M.on_message()
    core.call_api("multiplayer.onMessage")
end

---Отписаться от сообщений мультиплеера
function M.off_message()
    core.call_api("multiplayer.offMessage")
end

---Подключён ли игрок
---@return boolean
function M.is_connected()
    return core.call_api("multiplayer.isConnected") == true
end

---Является ли текущий игрок хостом
---@return boolean
function M.is_host()
    return core.call_api("multiplayer.isHost") == true
end

---Список подключённых игроков
---@return table
function M.connected_players()
    return core.call_api("multiplayer.connectedPlayers")
end

---Текущие показатели сети
---@return table
function M.network_stats()
    return core.call_api("multiplayer.networkStats")
end

---Состояние текущего игрока
---@return table
function M.my_state()
    return core.call_api("multiplayer.myState")
end

---Карта состояний всех игроков
---@return table
function M.players_state()
    return core.call_api("multiplayer.playersState")
end

---Последнее глобальное состояние
---@return table
function M.global_state()
    return core.call_api("multiplayer.globalState")
end

M.callbacks = callbacks.multiplayer

return M
