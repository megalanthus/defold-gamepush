local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")
local arena = require("example.multiplayer_arena")

local CHANNEL_TEMPLATE = "test_channel_template"
local channel_id = 66
local pending_create = false

local HOWTO = [[Как тестировать демо-арену мультиплеера:

1. Откройте панель GamePush (https://gamepush.com/panel/) → ваш проект → Каналы → Добавить шаблон.
2. Тег шаблона (уходит в template:): test_channel_template
3. Название любое, например MP Arena.
4. Максимум участников: 8 или больше.
5. Не включать «Приватный» — иначе второй браузер не войдёт через join, только через инвайт, и connect не сработает.
6. Включить «Видимый в поиске». Пароль не ставить.
7. Сохранить шаблон.
8. В примере: Create room в первом браузере → на арене появится channel #ID → во втором браузере Join room и вставить этот ID.

Тот же тег используется в секции Channels.]]

local function is_error_result(result)
    return type(result) == "table" and (result.success == false or result.error)
end

local function log_howto()
    utils.to_log(HOWTO)
end

local create_error_hooked = false
local function hook_create_error()
    if create_error_hooked then
        return
    end
    create_error_hooked = true
    local prev_error_create = gamepush.channels.callbacks.error_create_channel
    gamepush.channels.callbacks.error_create_channel = function(error)
        if prev_error_create then
            prev_error_create(error)
        end
        if pending_create then
            pending_create = false
            utils.to_log(HOWTO, "Create room error:", error)
        end
    end
end

local function prompt_channel_id()
    if html5 then
        local current = tostring(channel_id or "")
        local result = html5.run(string.format("window.prompt('Channel ID','%s')", current))
        local numeric = tonumber(result)
        if numeric then
            channel_id = numeric
        end
    end
end

local function connect_and_start()
    gamepush.multiplayer.connect({ channelId = channel_id }, function(result)
        utils.to_log("Multiplayer connect:", result, "channel #" .. tostring(channel_id))
        if is_error_result(result) then
            return
        end
        arena.start(channel_id)
    end)
end

local function create_room()
    hook_create_error()
    pending_create = true
    arena.prepare()
    gamepush.channels.create_channel({
        template = CHANNEL_TEMPLATE,
        capacity = 8,
        name = "mp-arena"
    }, function(channel)
        pending_create = false
        if type(channel) ~= "table" or not channel.id then
            utils.to_log(HOWTO, "Create room failed. Add template test_channel_template in the GamePush panel.", channel)
            return
        end
        channel_id = channel.id
        utils.to_log("Room created, channel #" .. tostring(channel_id))
        connect_and_start()
    end)
end

local function join_room()
    prompt_channel_id()
    arena.prepare()
    gamepush.channels.join({ channelId = channel_id }, function(result)
        utils.to_log("Join channel:", result, "channel #" .. tostring(channel_id))
        if is_error_result(result) then
            return
        end
        connect_and_start()
    end)
end

local function leave_room()
    arena.stop()
    gamepush.multiplayer.off_tick()
    gamepush.multiplayer.off_message()
    gamepush.multiplayer.disconnect({ channelId = channel_id }, function(result)
        utils.to_log("Leave room:", result)
    end)
end

local function id_minus()
    channel_id = math.max(1, (tonumber(channel_id) or 1) - 1)
    utils.to_log("Channel ID:", channel_id)
end

local function id_plus()
    channel_id = (tonumber(channel_id) or 0) + 1
    utils.to_log("Channel ID:", channel_id)
end

local function connect()
    gamepush.multiplayer.connect({ channelId = channel_id }, function(result)
        utils.to_log("Multiplayer connect:", result)
    end)
end

local function disconnect()
    gamepush.multiplayer.disconnect({ channelId = channel_id }, function(result)
        utils.to_log("Multiplayer disconnect:", result)
    end)
end

local function is_connected()
    utils.to_log("Is connected:", gamepush.multiplayer.is_connected())
end

local function is_host()
    utils.to_log("Is host:", gamepush.multiplayer.is_host())
end

local function connected_players()
    utils.to_log("Connected players:", gamepush.multiplayer.connected_players())
end

local function network_stats()
    utils.to_log("Network stats:", gamepush.multiplayer.network_stats())
end

local function my_state()
    utils.to_log("My state:", gamepush.multiplayer.my_state())
end

local function players_state()
    utils.to_log("Players state:", gamepush.multiplayer.players_state())
end

local function global_state()
    utils.to_log("Global state:", gamepush.multiplayer.global_state())
end

local function define_player_schema()
    gamepush.multiplayer.define_player_schema({
        x = { interpolate = true },
        y = { interpolate = true },
        hp = { interpolate = false }
    })
    utils.to_log("Player schema defined")
end

local function define_global_schema()
    gamepush.multiplayer.define_global_schema({
        round = {
            number = { interpolate = false },
            timeLeft = { interpolate = true }
        }
    })
    utils.to_log("Global schema defined")
end

local function set_player_initializer()
    gamepush.multiplayer.set_player_initializer(function(player_id, player_info)
        utils.to_console("Initialize player:", player_id, player_info)
        return { x = 100, y = 200, hp = 100 }
    end)
    utils.to_log("Player initializer set")
end

local function set_player_state()
    gamepush.multiplayer.set_player_state({ x = 120, y = 200, hp = 100 })
    utils.to_log("Player state set")
end

local function set_global_state()
    gamepush.multiplayer.set_global_state({
        round = { number = 1, timeLeft = 60 }
    })
    utils.to_log("Global state set")
end

local function set_mode_fast()
    gamepush.multiplayer.set_mode(gamepush.multiplayer.MODE_FAST)
    utils.to_log("Mode: fast")
end

local function set_mode_smooth()
    gamepush.multiplayer.set_mode(gamepush.multiplayer.MODE_SMOOTH)
    utils.to_log("Mode: smooth")
end

local function on_tick()
    gamepush.multiplayer.on_tick()
    utils.to_log("Subscribed to tick")
end

local function off_tick()
    gamepush.multiplayer.off_tick()
    utils.to_log("Unsubscribed from tick")
end

local function on_message()
    gamepush.multiplayer.on_message()
    utils.to_log("Subscribed to messages")
end

local function off_message()
    gamepush.multiplayer.off_message()
    utils.to_log("Unsubscribed from messages")
end

local function send_message()
    gamepush.multiplayer.send_message("emote", { name = "wave" }, { target = "all", echo = true })
    utils.to_log("Message sent")
end

local M = {
    { name = "Create room", callback = create_room },
    { name = "Join room", callback = join_room },
    { name = "Leave room", callback = leave_room },
    { name = "How to test", callback = log_howto },
    { name = "ID -", callback = id_minus },
    { name = "ID +", callback = id_plus },
    { name = "Connect", callback = connect },
    { name = "Disconnect", callback = disconnect },
    { name = "Is connected", callback = is_connected },
    { name = "Is host", callback = is_host },
    { name = "Connected players", callback = connected_players },
    { name = "Network stats", callback = network_stats },
    { name = "My state", callback = my_state },
    { name = "Players state", callback = players_state },
    { name = "Global state", callback = global_state },
    { name = "Define player schema", callback = define_player_schema },
    { name = "Define global schema", callback = define_global_schema },
    { name = "Set player initializer", callback = set_player_initializer },
    { name = "Set player state", callback = set_player_state },
    { name = "Set global state", callback = set_global_state },
    { name = "Set mode fast", callback = set_mode_fast },
    { name = "Set mode smooth", callback = set_mode_smooth },
    { name = "On tick", callback = on_tick },
    { name = "Off tick", callback = off_tick },
    { name = "On message", callback = on_message },
    { name = "Off message", callback = off_message },
    { name = "Send message", callback = send_message },
}

function M.show_howto()
    hook_create_error()
    log_howto()
end

gamepush.multiplayer.callbacks.connect = function(result)
    utils.to_console("Multiplayer connect:", result)
end
gamepush.multiplayer.callbacks.disconnect = function(result)
    utils.to_console("Multiplayer disconnect:", result)
end
gamepush.multiplayer.callbacks.player_joined = function(result)
    utils.to_console("Player joined:", result)
end
gamepush.multiplayer.callbacks.player_left = function(result)
    utils.to_console("Player left:", result)
end
gamepush.multiplayer.callbacks.became_host = function()
    utils.to_console("Became host")
end
gamepush.multiplayer.callbacks.became_peer = function()
    utils.to_console("Became peer")
end
gamepush.multiplayer.callbacks.host_migrated = function(result)
    utils.to_console("Host migrated:", result)
end
gamepush.multiplayer.callbacks.players_updated = function(result)
    if not arena.active then
        utils.to_console("Players updated:", result)
    end
end
gamepush.multiplayer.callbacks.global_state_updated = function(result)
    if not arena.active then
        utils.to_console("Global state updated:", result)
    end
end
gamepush.multiplayer.callbacks.error_connect = function(error)
    utils.to_console("Connect error:", error)
end
gamepush.multiplayer.callbacks.error_send_state = function(error)
    utils.to_console("Send state error:", error)
end
gamepush.multiplayer.callbacks.error_disconnect = function(error)
    utils.to_console("Disconnect error:", error)
end
gamepush.multiplayer.callbacks.message = function(result)
    if not arena.active then
        utils.to_console("Message:", result)
    end
end

return M
