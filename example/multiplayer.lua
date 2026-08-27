local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")
local arena = require("example.multiplayer_arena")

local CHANNEL_TEMPLATE = "test_channel_template"
local ROOM_TAG = "mp-arena"
local channel_id = 66
local pending_create = false
local pending_join = false
local lobby_visible = false
local lobby_buttons = {}

local HOWTO = [[How to test the multiplayer arena:

1. Open GamePush panel → your project → Channels → Add template.
2. Template tag (template:): test_channel_template
3. Any name, e.g. MP Arena.
4. Max members: 8 or more.
5. Do not enable Private — the second browser cannot join.
6. Enable Visible in search. No password.
7. Save the template.
8. Browser A: Create room.
   Browser B: Refresh rooms and click a row.

The same tag is used in the Channels section.]]

local function is_error_result(result)
    return type(result) == "table" and (result.success == false or result.error)
end

local function log_howto()
    utils.to_log(HOWTO)
end

local is_already_in_channel
local connect_and_start
local show_lobby
local hide_lobby
local refresh_rooms
local join_channel

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
    local prev_error_join = gamepush.channels.callbacks.error_join
    gamepush.channels.callbacks.error_join = function(error)
        if pending_join and is_already_in_channel(error) then
            pending_join = false
            utils.to_log("Already in channel, connecting #" .. tostring(channel_id))
            connect_and_start()
            return
        end
        if prev_error_join then
            prev_error_join(error)
        end
        if pending_join then
            pending_join = false
            utils.to_log("Join channel error:", error)
        end
    end
end

is_already_in_channel = function(result)
    local err = result
    if type(result) == "table" then
        err = result.error or result.message or result
    end
    return tostring(err):find("already_in_channel", 1, true) ~= nil
end

local function prompt_channel_id()
    if not html5 then
        return true
    end
    local current = tostring(channel_id or "")
    local result = html5.run(string.format("window.prompt('Channel ID','%s')", current))
    if result == nil or result == "" or result == "null" or result == "undefined" then
        return false
    end
    local numeric = tonumber(result)
    if not numeric then
        return false
    end
    channel_id = numeric
    return true
end

local function clear_lobby_buttons()
    utils.delete_buttons(lobby_buttons)
    lobby_buttons = {}
end

local function add_lobby_button(name, x, y, callback)
    local template = gui.get_node("template/button")
    local cloned = gui.clone_tree(template)
    local node = cloned[hash("template/button")]
    local label = cloned[hash("template/label")]
    gui.set_text(label, name)
    gui.set_position(node, vmath.vector3(x, y, 0))
    gui.set_layer(node, hash("label"))
    gui.set_visible(node, true)
    table.insert(lobby_buttons, { name = name, node = node, callback = callback })
end

hide_lobby = function()
    lobby_visible = false
    gui.set_visible(gui.get_node("label_log"), false)
    clear_lobby_buttons()
end

connect_and_start = function()
    gamepush.multiplayer.connect({ channelId = channel_id }, function(result)
        utils.to_log("Multiplayer connect:", result, "channel #" .. tostring(channel_id))
        if is_error_result(result) then
            return
        end
        hide_lobby()
        arena.start(channel_id)
    end)
end

join_channel = function(id)
    if gamepush.multiplayer.is_connected() then
        utils.to_log("Already connected, channel #" .. tostring(channel_id))
        return
    end
    channel_id = id
    hook_create_error()
    arena.prepare()
    pending_join = true
    gamepush.channels.join({ channelId = channel_id }, function(result)
        pending_join = false
        if is_already_in_channel(result) then
            utils.to_log("Already in channel, connecting #" .. tostring(channel_id))
            connect_and_start()
            return
        end
        if is_error_result(result) then
            utils.to_log("Join channel error:", result)
            return
        end
        utils.to_log("Join channel:", result, "channel #" .. tostring(channel_id))
        connect_and_start()
    end)
end

local function room_items(result)
    if type(result) ~= "table" then
        return {}
    end
    if type(result.items) == "table" then
        return result.items
    end
    if result.id then
        return { result }
    end
    return result
end

refresh_rooms = function()
    if not lobby_visible then
        return
    end
    gamepush.channels.fetch_channels({
        tags = { ROOM_TAG },
        onlyJoined = false,
        onlyOwned = false,
        limit = 50
    }, function(result)
        if not lobby_visible then
            return
        end
        clear_lobby_buttons()
        add_lobby_button("Refresh rooms", 800, 400, refresh_rooms)
        local y = 360
        local count = 0
        for _, channel in pairs(room_items(result)) do
            if type(channel) == "table" and channel.id then
                count = count + 1
                if count <= 8 then
                    local members = channel.membersCount or channel.members_count or 0
                    local capacity = channel.capacity or 8
                    local label = string.format("#%s  %s/%s", tostring(channel.id), tostring(members), tostring(capacity))
                    local id = channel.id
                    add_lobby_button(label, 800, y, function()
                        join_channel(id)
                    end)
                    y = y - 40
                end
            end
        end
        if count == 0 then
            add_lobby_button("No rooms", 800, y, function() end)
        end
    end)
end

show_lobby = function()
    if arena.active then
        return
    end
    lobby_visible = true
    gui.set_visible(gui.get_node("label_log"), true)
    log_howto()
    hook_create_error()
    clear_lobby_buttons()
    add_lobby_button("Refresh rooms", 800, 400, refresh_rooms)
    refresh_rooms()
end

local function create_room()
    hook_create_error()
    pending_create = true
    arena.prepare()
    gamepush.channels.create_channel({
        template = CHANNEL_TEMPLATE,
        tags = { ROOM_TAG },
        capacity = 8,
        name = "mp-arena",
        visible = true,
        private = false
    }, function(channel)
        pending_create = false
        if type(channel) ~= "table" or not channel.id then
            utils.to_log(HOWTO, "Create room failed. Add template test_channel_template in the GamePush panel.", channel)
            show_lobby()
            return
        end
        channel_id = channel.id
        utils.to_log("Room created, channel #" .. tostring(channel_id))
        connect_and_start()
    end)
end

local function join_room()
    if gamepush.multiplayer.is_connected() then
        utils.to_log("Already connected, channel #" .. tostring(channel_id))
        return
    end
    if not prompt_channel_id() then
        utils.to_log("Join cancelled")
        return
    end
    join_channel(channel_id)
end

local function leave_room()
    arena.stop()
    gamepush.multiplayer.off_tick()
    gamepush.multiplayer.off_message()
    gamepush.multiplayer.disconnect({ channelId = channel_id }, function(result)
        utils.to_log("Leave room:", result)
        show_lobby()
    end)
    show_lobby()
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
    { name = "How to test", callback = function()
        show_lobby()
    end },
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
    show_lobby()
end

function M.show_lobby()
    show_lobby()
end

function M.hide_lobby()
    hide_lobby()
end

function M.handle_input(x, y)
    if not lobby_visible then
        return
    end
    utils.handle_buttons(lobby_buttons, x, y)
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
