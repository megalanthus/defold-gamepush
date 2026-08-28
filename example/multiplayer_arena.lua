local gamepush = require("gamepush.gamepush")

local M = {}

local PLAYER_SIZE = 24
local APPLE_SIZE = 14
local BOX_SIZE = 36
local BULLET_SIZE = 6
local PLAYER_SPEED = 220
local BULLET_SPEED = 420
local SHOOT_COOLDOWN = 0.28
local APPLE_INTERVAL = 3
local MAX_APPLES = 5
local BOX_HP = 3
local PADDING = 28
local MAX_HP = 3
local HP_HIT = 1
local DEATH_DELAY = 0.45
local HIDE_TIME = 0.35
local BLINK_TIME = 1.5
local HIT_LOCK = 0.12
local HP_BAR_W = 24
local HP_BAR_H = 4

local COLORS = {
    vmath.vector4(0.25, 0.65, 1.0, 1),
    vmath.vector4(1.0, 0.42, 0.32, 1),
    vmath.vector4(0.4, 0.9, 0.45, 1),
    vmath.vector4(1.0, 0.85, 0.25, 1),
    vmath.vector4(0.85, 0.45, 1.0, 1),
    vmath.vector4(0.3, 0.9, 0.9, 1),
    vmath.vector4(1.0, 0.6, 0.2, 1),
    vmath.vector4(0.7, 0.75, 0.85, 1)
}

local HASH_TOUCH = hash("touch")
local HASH_LEFT = hash("left")
local HASH_RIGHT = hash("right")
local HASH_UP = hash("up")
local HASH_DOWN = hash("down")
local HASH_W = hash("w")
local HASH_A = hash("a")
local HASH_S = hash("s")
local HASH_D = hash("d")
local HASH_SPACE = hash("space")
local HASH_ARENA = hash("arena")

local keys = {}
local nodes = {
    players = {},
    apples = {},
    boxes = {},
    bullets = {},
    hud = nil,
    scoreboard = nil
}

local function arena_node()
    return gui.get_node("arena")
end

local function arena_size()
    local size = gui.get_size(arena_node())
    return size.x, size.y
end

local function player_color(player_id)
    local index = (math.abs(tonumber(player_id) or 0) % #COLORS) + 1
    return COLORS[index]
end

local function to_number_id(value)
    return tonumber(value) or value
end

local function flag_alive(value)
    return value ~= false and value ~= 0
end

local function flag_invuln(value)
    return value == true or value == 1
end

local function overlaps(ax, ay, as, bx, by, bs)
    local a_half = as / 2
    local b_half = bs / 2
    return math.abs(ax - bx) < a_half + b_half and math.abs(ay - by) < a_half + b_half
end

local function clamp(value, min_value, max_value)
    if value < min_value then
        return min_value
    end
    if value > max_value then
        return max_value
    end
    return value
end

local function spawn_xy(player_id)
    local width, height = arena_size()
    local index = math.abs(tonumber(player_id) or 0)
    local x = PADDING + 40 + (index % 5) * ((width - 120) / 5)
    local y = PADDING + 50 + (index % 3) * 30
    return x, y
end

local function lookup_state(states, player_id)
    if type(states) ~= "table" then
        return nil
    end
    return states[player_id] or states[tostring(player_id)] or states[tonumber(player_id)]
end

local function is_hittable(state)
    if type(state) ~= "table" then
        return false
    end
    if not flag_alive(state.alive) then
        return false
    end
    if flag_invuln(state.invulnerable) then
        return false
    end
    return (state.hp or 0) > 0
end

local function local_can_shoot()
    return M.alive == true
end

local function local_can_move()
    return M.alive == true
end

local function local_can_be_hit()
    return is_hittable({ alive = M.alive, invulnerable = M.invulnerable, hp = M.hp })
end

local function ensure_box(store, key, size, color)
    local entry = store[key]
    if not entry then
        local box = gui.new_box_node(vmath.vector3(0), vmath.vector3(size, size, 0))
        gui.set_parent(box, arena_node())
        gui.set_pivot(box, gui.PIVOT_CENTER)
        gui.set_layer(box, HASH_ARENA)
        gui.set_color(box, color)
        entry = { box = box }
        store[key] = entry
    else
        gui.set_color(entry.box, color)
    end
    return entry
end

local function ensure_player(player_id)
    local key = tostring(player_id)
    local entry = nodes.players[key]
    if not entry then
        entry = ensure_box(nodes.players, key, PLAYER_SIZE, player_color(player_id))
        local label = gui.new_text_node(vmath.vector3(0, PLAYER_SIZE * 0.85, 0), tostring(player_id))
        gui.set_parent(label, entry.box)
        gui.set_pivot(label, gui.PIVOT_CENTER)
        gui.set_font(label, "system_font")
        gui.set_color(label, vmath.vector4(1, 1, 1, 1))
        gui.set_scale(label, vmath.vector3(0.45))
        gui.set_layer(label, HASH_ARENA)
        local bar_bg = gui.new_box_node(vmath.vector3(0, -PLAYER_SIZE * 0.7, 0), vmath.vector3(HP_BAR_W, HP_BAR_H, 0))
        gui.set_parent(bar_bg, entry.box)
        gui.set_pivot(bar_bg, gui.PIVOT_CENTER)
        gui.set_layer(bar_bg, HASH_ARENA)
        gui.set_color(bar_bg, vmath.vector4(0.15, 0.15, 0.15, 1))
        local bar = gui.new_box_node(vmath.vector3(-HP_BAR_W / 2, -PLAYER_SIZE * 0.7, 0), vmath.vector3(HP_BAR_W, HP_BAR_H, 0))
        gui.set_parent(bar, entry.box)
        gui.set_pivot(bar, gui.PIVOT_W)
        gui.set_layer(bar, HASH_ARENA)
        gui.set_color(bar, vmath.vector4(0.3, 0.85, 0.35, 1))
        entry.label = label
        entry.bar_bg = bar_bg
        entry.bar = bar
    end
    gui.set_text(entry.label, tostring(player_id))
    return entry
end

local function set_hp_bar(entry, hp)
    local ratio = clamp((hp or 0) / MAX_HP, 0, 1)
    gui.set_size(entry.bar, vmath.vector3(HP_BAR_W * ratio, HP_BAR_H, 0))
    gui.set_color(entry.bar, vmath.vector4(0.9 - 0.6 * ratio, 0.25 + 0.6 * ratio, 0.25, 1))
end

local function delete_store(store)
    for key, entry in pairs(store) do
        if entry.box then
            gui.delete_node(entry.box)
        end
        store[key] = nil
    end
end

local function prune_store(store, keep)
    for key, entry in pairs(store) do
        if not keep[key] then
            if entry.box then
                gui.delete_node(entry.box)
            end
            store[key] = nil
        end
    end
end

local function update_visibility()
    local visible = M.section_visible and M.active
    gui.set_visible(arena_node(), visible)
    if nodes.hud then
        gui.set_visible(nodes.hud, visible)
    end
    if nodes.scoreboard then
        gui.set_visible(nodes.scoreboard, visible)
    end
end

local function seed_world()
    local width, height = arena_size()
    local boxes = {}
    for i = 1, 6 do
        boxes[i] = {
            id = i,
            x = 70 + (i - 1) * 90,
            y = height * 0.45 + (i % 2) * 70,
            hp = BOX_HP
        }
    end
    return { apples = {}, boxes = boxes }
end

local function apply_schemas()
    gamepush.multiplayer.set_mode(gamepush.multiplayer.MODE_FAST)
    gamepush.multiplayer.define_player_schema({
        x = { interpolate = true },
        y = { interpolate = true },
        dir_x = { interpolate = false },
        dir_y = { interpolate = false },
        score = { interpolate = false },
        hp = { interpolate = false },
        kills = { interpolate = false },
        deaths = { interpolate = false },
        alive = { interpolate = false },
        invulnerable = { interpolate = false }
    })
    gamepush.multiplayer.define_global_schema({
        apples = {
            id = { readonly = true },
            x = { interpolate = false },
            y = { interpolate = false }
        },
        boxes = {
            id = { readonly = true },
            x = { interpolate = false },
            y = { interpolate = false },
            hp = { interpolate = false }
        }
    })
end

local function apply_player_initializer()
    gamepush.multiplayer.set_player_initializer(function(player_id)
        local x, y = spawn_xy(player_id)
        return {
            x = x,
            y = y,
            dir_x = 1,
            dir_y = 0,
            score = 0,
            hp = MAX_HP,
            kills = 0,
            deaths = 0,
            alive = true,
            invulnerable = false
        }
    end)
end

local function room_ready()
    return M.active and M.role_ready and gamepush.multiplayer.is_connected()
end

local function push_player_state()
    if not room_ready() then
        return
    end
    gamepush.multiplayer.set_player_state({
        x = M.local_x,
        y = M.local_y,
        dir_x = M.dir_x,
        dir_y = M.dir_y,
        score = M.score,
        hp = M.hp,
        kills = M.kills,
        deaths = M.deaths,
        alive = M.alive,
        invulnerable = M.invulnerable
    })
end

local function mark_role_ready()
    M.has_role = true
    if M.active then
        M.role_ready = true
    end
end

local function become_host()
    if not M.active then
        M.has_role = true
        return
    end
    M.has_role = true
    M.role_ready = true
    apply_player_initializer()
    local latest = gamepush.multiplayer.global_state()
    if latest and (latest.boxes or latest.apples) then
        M.host_state = latest
        M.host_state.apples = M.host_state.apples or {}
        M.host_state.boxes = M.host_state.boxes or {}
    else
        M.host_state = seed_world()
    end
    local max_id = 0
    for _, box in pairs(M.host_state.boxes) do
        max_id = math.max(max_id, tonumber(box.id) or 0)
    end
    for _, apple in pairs(M.host_state.apples) do
        max_id = math.max(max_id, tonumber(apple.id) or 0)
    end
    M.next_id = max_id + 1
    M.apple_timer = APPLE_INTERVAL
    gamepush.multiplayer.set_global_state(M.host_state)
end

local function spawn_bullet(x, y, dir_x, dir_y, owner_id)
    table.insert(M.bullets, {
        x = x,
        y = y,
        dx = dir_x,
        dy = dir_y,
        owner_id = owner_id
    })
end

local function begin_death(killer_id)
    if not M.alive then
        return
    end
    M.alive = false
    M.invulnerable = false
    M.hp = 0
    M.deaths = (M.deaths or 0) + 1
    M.death_timer = DEATH_DELAY
    M.hide_timer = HIDE_TIME
    keys = {}
    if room_ready() then
        gamepush.multiplayer.send_message("player_killed", { killerId = killer_id }, { echo = true })
    end
    push_player_state()
end

local function do_respawn()
    local x, y = spawn_xy(gamepush.player.id())
    M.local_x = x
    M.local_y = y
    M.hp = MAX_HP
    M.alive = true
    M.invulnerable = true
    M.blink_timer = BLINK_TIME
    push_player_state()
end

local function apply_hit(owner_id)
    if not local_can_be_hit() then
        return
    end
    if (M.hit_lock or 0) > 0 then
        return
    end
    M.hit_lock = HIT_LOCK
    M.hp = (M.hp or MAX_HP) - HP_HIT
    if M.hp <= 0 then
        M.hp = 0
        begin_death(owner_id)
    else
        push_player_state()
    end
end

local function handle_message(payload)
    if not M.active or not payload then
        return
    end
    local event_name = payload.eventName or payload.event_name
    local data = payload.data or {}
    local sender_id = payload.senderId or payload.sender_id
    local states = gamepush.multiplayer.players_state() or {}
    if event_name == "shoot" then
        local sender_state = lookup_state(states, sender_id)
        if sender_state and not flag_alive(sender_state.alive) then
            return
        end
        spawn_bullet(data.x or 0, data.y or 0, data.dir_x or 1, data.dir_y or 0, sender_id or data.owner_id)
        return
    end
    if event_name == "hit_player" then
        local target_id = tostring(data.targetId or data.target_id)
        if target_id == tostring(gamepush.player.id()) then
            apply_hit(data.ownerId or data.owner_id or sender_id)
        end
        return
    end
    if event_name == "player_killed" then
        local killer_id = tostring(data.killerId or data.killer_id or "")
        if killer_id ~= "" and killer_id == tostring(gamepush.player.id()) then
            local victim = tostring(sender_id or "")
            if victim ~= killer_id and not M.kill_credit[victim] then
                M.kill_credit[victim] = true
                M.kills = (M.kills or 0) + 1
                push_player_state()
            end
        end
        return
    end
    if not gamepush.multiplayer.is_host() or not M.host_state then
        return
    end
    if event_name == "collect_apple" then
        local apple_id = to_number_id(data.id)
        local apples = {}
        for _, apple in pairs(M.host_state.apples) do
            if to_number_id(apple.id) ~= apple_id then
                table.insert(apples, apple)
            end
        end
        M.host_state.apples = apples
        gamepush.multiplayer.set_global_state(M.host_state)
    elseif event_name == "hit_box" then
        local box_id = to_number_id(data.id)
        local boxes = {}
        for _, box in pairs(M.host_state.boxes) do
            if to_number_id(box.id) == box_id then
                box.hp = (box.hp or BOX_HP) - 1
                if box.hp > 0 then
                    table.insert(boxes, box)
                end
            else
                table.insert(boxes, box)
            end
        end
        M.host_state.boxes = boxes
        gamepush.multiplayer.set_global_state(M.host_state)
    end
end

local function wire_callbacks()
    if M.wired then
        return
    end
    M.wired = true
    local prev_host = gamepush.multiplayer.callbacks.became_host
    gamepush.multiplayer.callbacks.became_host = function(...)
        if prev_host then
            prev_host(...)
        end
        become_host()
    end
    local prev_peer = gamepush.multiplayer.callbacks.became_peer
    gamepush.multiplayer.callbacks.became_peer = function(...)
        if prev_peer then
            prev_peer(...)
        end
        mark_role_ready()
    end
    local prev_message = gamepush.multiplayer.callbacks.message
    gamepush.multiplayer.callbacks.message = function(payload)
        if prev_message then
            prev_message(payload)
        end
        handle_message(payload)
    end
end

local function sync_local_from_state()
    local my_state = gamepush.multiplayer.my_state()
    if my_state and my_state.x then
        M.local_x = my_state.x
        M.local_y = my_state.y
        M.dir_x = my_state.dir_x or 1
        M.dir_y = my_state.dir_y or 0
        M.score = my_state.score or 0
        if my_state.hp ~= nil then
            M.hp = my_state.hp
        end
        if my_state.kills ~= nil then
            M.kills = my_state.kills
        end
        if my_state.deaths ~= nil then
            M.deaths = my_state.deaths
        end
        return true
    end
    return false
end

local function shoot(dir_x, dir_y)
    if not room_ready() or not local_can_shoot() then
        return
    end
    if M.shoot_cooldown > 0 then
        return
    end
    local length = math.sqrt(dir_x * dir_x + dir_y * dir_y)
    if length < 0.01 then
        dir_x, dir_y = M.dir_x, M.dir_y
        length = math.sqrt(dir_x * dir_x + dir_y * dir_y)
    end
    if length < 0.01 then
        dir_x, dir_y = 1, 0
        length = 1
    end
    dir_x = dir_x / length
    dir_y = dir_y / length
    M.dir_x = dir_x
    M.dir_y = dir_y
    M.shoot_cooldown = SHOOT_COOLDOWN
    gamepush.multiplayer.send_message("shoot", {
        x = M.local_x + dir_x * (PLAYER_SIZE * 0.7),
        y = M.local_y + dir_y * (PLAYER_SIZE * 0.7),
        dir_x = dir_x,
        dir_y = dir_y,
        owner_id = gamepush.player.id()
    }, { target = "all", echo = true })
end

local function update_host(dt)
    if not gamepush.multiplayer.is_host() or not M.host_state then
        return
    end
    M.apple_timer = (M.apple_timer or APPLE_INTERVAL) - dt
    local apple_count = 0
    for _ in pairs(M.host_state.apples) do
        apple_count = apple_count + 1
    end
    if M.apple_timer <= 0 and apple_count < MAX_APPLES then
        M.apple_timer = APPLE_INTERVAL
        local width, height = arena_size()
        table.insert(M.host_state.apples, {
            id = M.next_id,
            x = PADDING + math.random() * (width - PADDING * 2),
            y = PADDING + math.random() * (height - PADDING * 2)
        })
        M.next_id = M.next_id + 1
        gamepush.multiplayer.set_global_state(M.host_state)
    end
end

local function update_life(dt)
    M.blink_clock = (M.blink_clock or 0) + dt
    M.hit_lock = math.max(0, (M.hit_lock or 0) - dt)
    M.corpses = M.corpses or {}
    for key, corpse in pairs(M.corpses) do
        corpse.timer = (corpse.timer or 0) - dt
        if corpse.timer <= 0 then
            M.corpses[key] = nil
        end
    end
    if not M.alive then
        if (M.death_timer or 0) > 0 then
            M.death_timer = M.death_timer - dt
            push_player_state()
            return
        end
        if (M.hide_timer or 0) > 0 then
            M.hide_timer = M.hide_timer - dt
            push_player_state()
            return
        end
        do_respawn()
        return
    end
    if M.invulnerable then
        M.blink_timer = (M.blink_timer or 0) - dt
        if M.blink_timer <= 0 then
            M.invulnerable = false
        end
    end
end

local function update_local(dt)
    local width, height = arena_size()
    if local_can_move() then
        local dx, dy = 0, 0
        if keys[HASH_LEFT] or keys[HASH_A] then
            dx = dx - 1
        end
        if keys[HASH_RIGHT] or keys[HASH_D] then
            dx = dx + 1
        end
        if keys[HASH_UP] or keys[HASH_W] then
            dy = dy + 1
        end
        if keys[HASH_DOWN] or keys[HASH_S] then
            dy = dy - 1
        end
        if dx ~= 0 or dy ~= 0 then
            local length = math.sqrt(dx * dx + dy * dy)
            dx, dy = dx / length, dy / length
            M.dir_x, M.dir_y = dx, dy
            M.local_x = clamp(M.local_x + dx * PLAYER_SPEED * dt, PADDING, width - PADDING)
            M.local_y = clamp(M.local_y + dy * PLAYER_SPEED * dt, PADDING, height - PADDING)
        end
    end
    push_player_state()
end

local function update_bullets(dt)
    local width, height = arena_size()
    local world = gamepush.multiplayer.global_state() or {}
    local boxes = world.boxes or {}
    local states = gamepush.multiplayer.players_state() or {}
    local my_id = tostring(gamepush.player.id())
    local next_bullets = {}
    for _, bullet in ipairs(M.bullets) do
        bullet.x = bullet.x + bullet.dx * BULLET_SPEED * dt
        bullet.y = bullet.y + bullet.dy * BULLET_SPEED * dt
        local in_bounds = bullet.x > 0 and bullet.y > 0 and bullet.x < width and bullet.y < height
        if in_bounds then
            local hit = false
            local owner_state = lookup_state(states, bullet.owner_id)
            local owner_alive = not owner_state or flag_alive(owner_state.alive)
            local owner_key = tostring(bullet.owner_id)
            if owner_alive and owner_key ~= my_id and local_can_be_hit() then
                if overlaps(bullet.x, bullet.y, BULLET_SIZE, M.local_x, M.local_y, PLAYER_SIZE) then
                    apply_hit(bullet.owner_id)
                    hit = true
                end
            end
            if not hit and owner_alive and owner_key == my_id then
                for player_id, state in pairs(states) do
                    local key = tostring(player_id)
                    if key ~= my_id and is_hittable(state) then
                        local px, py = state.x, state.y
                        if px and py and overlaps(bullet.x, bullet.y, BULLET_SIZE, px, py, PLAYER_SIZE) then
                            if room_ready() then
                                gamepush.multiplayer.send_message("hit_player", {
                                    targetId = player_id,
                                    ownerId = bullet.owner_id
                                }, { echo = true })
                            end
                            hit = true
                            break
                        end
                    end
                end
            end
            if not hit then
                for _, box in pairs(boxes) do
                    if overlaps(bullet.x, bullet.y, BULLET_SIZE, box.x, box.y, BOX_SIZE) then
                        local box_id = to_number_id(box.id)
                        if not M.pending_hit[box_id] then
                            M.pending_hit[box_id] = true
                            if room_ready() then
                                gamepush.multiplayer.send_message("hit_box", { id = box_id }, { echo = true })
                            end
                        end
                        hit = true
                        break
                    end
                end
            end
            if not hit then
                table.insert(next_bullets, bullet)
            end
        end
    end
    M.bullets = next_bullets
end

local function collect_apples()
    if not local_can_move() then
        return
    end
    local world = gamepush.multiplayer.global_state() or {}
    for _, apple in pairs(world.apples or {}) do
        local apple_id = to_number_id(apple.id)
        if overlaps(M.local_x, M.local_y, PLAYER_SIZE, apple.x, apple.y, APPLE_SIZE) then
            if not M.pending_collect[apple_id] then
                M.pending_collect[apple_id] = true
                M.score = (M.score or 0) + 1
                if M.alive then
                    M.hp = math.min(MAX_HP, (M.hp or 0) + HP_HIT)
                    push_player_state()
                end
                if room_ready() then
                    gamepush.multiplayer.send_message("collect_apple", { id = apple_id }, { echo = true })
                end
            end
        end
    end
    local apples_alive = {}
    for _, apple in pairs(world.apples or {}) do
        apples_alive[to_number_id(apple.id)] = true
    end
    for apple_id in pairs(M.pending_collect) do
        if not apples_alive[apple_id] then
            M.pending_collect[apple_id] = nil
        end
    end
    local boxes_alive = {}
    for _, box in pairs(world.boxes or {}) do
        boxes_alive[to_number_id(box.id)] = true
    end
    for box_id in pairs(M.pending_hit) do
        if not boxes_alive[box_id] then
            M.pending_hit[box_id] = nil
        end
    end
end

local function draw()
    local keep_players = {}
    local my_id = tostring(gamepush.player.id())
    local states = gamepush.multiplayer.players_state() or {}
    M.corpses = M.corpses or {}
    local blink_on = math.floor((M.blink_clock or 0) * 8) % 2 == 0
    for player_id, state in pairs(states) do
        local key = tostring(player_id)
        local living = flag_alive(state.alive)
        local invuln = flag_invuln(state.invulnerable)
        local x, y = state.x, state.y
        local hp = state.hp or MAX_HP
        if key == my_id then
            living = M.alive or (M.death_timer or 0) > 0
            invuln = M.invulnerable
            x, y = M.local_x, M.local_y
            hp = M.hp
        elseif living then
            M.corpses[key] = nil
        elseif x and y then
            if not M.corpses[key] then
                M.corpses[key] = { id = player_id, x = x, y = y, timer = DEATH_DELAY }
            end
        end
        if living then
            keep_players[key] = true
            local entry = ensure_player(player_id)
            if x and y then
                gui.set_position(entry.box, vmath.vector3(x, y, 0))
            end
            set_hp_bar(entry, hp)
            gui.set_visible(entry.box, not invuln or blink_on)
        end
    end
    for key, corpse in pairs(M.corpses) do
        if not keep_players[key] and (corpse.timer or 0) > 0 then
            keep_players[key] = true
            local entry = ensure_player(corpse.id)
            gui.set_position(entry.box, vmath.vector3(corpse.x, corpse.y, 0))
            set_hp_bar(entry, 0)
            gui.set_visible(entry.box, true)
        end
    end
    if my_id and my_id ~= "nil" and (M.alive or (M.death_timer or 0) > 0) and not keep_players[my_id] then
        keep_players[my_id] = true
        local entry = ensure_player(gamepush.player.id())
        gui.set_position(entry.box, vmath.vector3(M.local_x, M.local_y, 0))
        set_hp_bar(entry, M.hp)
        gui.set_visible(entry.box, not M.invulnerable or blink_on)
    end
    prune_store(nodes.players, keep_players)

    local world = gamepush.multiplayer.global_state() or {}
    local keep_apples = {}
    for _, apple in pairs(world.apples or {}) do
        local key = tostring(apple.id)
        keep_apples[key] = true
        local entry = ensure_box(nodes.apples, key, APPLE_SIZE, vmath.vector4(0.95, 0.2, 0.2, 1))
        gui.set_position(entry.box, vmath.vector3(apple.x, apple.y, 0))
    end
    prune_store(nodes.apples, keep_apples)

    local keep_boxes = {}
    for _, box in pairs(world.boxes or {}) do
        local key = tostring(box.id)
        keep_boxes[key] = true
        local hp = box.hp or BOX_HP
        local shade = 0.35 + 0.2 * (hp / BOX_HP)
        local entry = ensure_box(nodes.boxes, key, BOX_SIZE, vmath.vector4(shade, shade * 0.7, 0.25, 1))
        gui.set_position(entry.box, vmath.vector3(box.x, box.y, 0))
    end
    prune_store(nodes.boxes, keep_boxes)

    local keep_bullets = {}
    for index, bullet in ipairs(M.bullets) do
        local key = tostring(index)
        keep_bullets[key] = true
        local entry = ensure_box(nodes.bullets, key, BULLET_SIZE, vmath.vector4(1, 0.92, 0.35, 1))
        gui.set_position(entry.box, vmath.vector3(bullet.x, bullet.y, 0))
    end
    prune_store(nodes.bullets, keep_bullets)

    if not nodes.hud then
        nodes.hud = gui.new_text_node(vmath.vector3(8, 548, 0), "")
        gui.set_parent(nodes.hud, arena_node())
        gui.set_pivot(nodes.hud, gui.PIVOT_NW)
        gui.set_font(nodes.hud, "system_font")
        gui.set_color(nodes.hud, vmath.vector4(1, 1, 1, 1))
        gui.set_scale(nodes.hud, vmath.vector3(0.42))
        gui.set_layer(nodes.hud, HASH_ARENA)
    end
    local role = gamepush.multiplayer.is_host() and "host" or "peer"
    gui.set_text(nodes.hud, string.format(
        "channel #%s  %s  apples %d\nWASD move  Space/click shoot",
        tostring(M.channel_id or "-"),
        role,
        M.score or 0
    ))

    if not nodes.scoreboard then
        nodes.scoreboard = gui.new_text_node(vmath.vector3(632, 548, 0), "")
        gui.set_parent(nodes.scoreboard, arena_node())
        gui.set_pivot(nodes.scoreboard, gui.PIVOT_NE)
        gui.set_font(nodes.scoreboard, "system_font")
        gui.set_color(nodes.scoreboard, vmath.vector4(1, 1, 1, 1))
        gui.set_scale(nodes.scoreboard, vmath.vector3(0.38))
        gui.set_layer(nodes.scoreboard, HASH_ARENA)
    end
    local rows = {}
    local seen = {}
    for player_id, state in pairs(states) do
        local key = tostring(player_id)
        seen[key] = true
        local kills, deaths = state.kills or 0, state.deaths or 0
        if key == my_id then
            kills, deaths = M.kills or 0, M.deaths or 0
        end
        table.insert(rows, { id = key, kills = kills, deaths = deaths })
    end
    if my_id and my_id ~= "nil" and not seen[my_id] then
        table.insert(rows, { id = my_id, kills = M.kills or 0, deaths = M.deaths or 0 })
    end
    table.sort(rows, function(a, b)
        if a.kills == b.kills then
            return a.id < b.id
        end
        return a.kills > b.kills
    end)
    local text = ""
    for _, row in ipairs(rows) do
        text = text .. string.format("%s  K:%d  D:%d\n", row.id, row.kills, row.deaths)
    end
    gui.set_text(nodes.scoreboard, text)
end

function M.is_visible()
    return M.section_visible and M.active
end

function M.on_section_changed(is_multiplayer_section)
    M.section_visible = is_multiplayer_section
    update_visibility()
end

function M.prepare()
    wire_callbacks()
end

function M.start(channel_id)
    M.channel_id = channel_id
    M.active = true
    M.role_ready = M.has_role == true
    M.spawned_from_state = false
    M.bullets = {}
    M.pending_collect = {}
    M.pending_hit = {}
    M.kill_credit = {}
    M.corpses = {}
    M.shoot_cooldown = 0
    M.hp = MAX_HP
    M.kills = 0
    M.deaths = 0
    M.alive = true
    M.invulnerable = false
    M.death_timer = 0
    M.hide_timer = 0
    M.blink_timer = 0
    M.blink_clock = 0
    M.hit_lock = 0
    local x, y = spawn_xy(gamepush.player.id())
    M.local_x = x
    M.local_y = y
    M.dir_x = 1
    M.dir_y = 0
    M.score = 0
    M.host_state = nil
    wire_callbacks()
    if gamepush.multiplayer.is_connected() then
        apply_schemas()
    end
    gamepush.multiplayer.on_message()
    if gamepush.multiplayer.is_host() then
        become_host()
    elseif M.has_role or gamepush.multiplayer.is_connected() then
        M.role_ready = true
    end
    if sync_local_from_state() then
        M.spawned_from_state = true
    end
    update_visibility()
end

function M.stop()
    M.active = false
    M.role_ready = false
    M.has_role = false
    M.spawned_from_state = false
    M.alive = false
    M.bullets = {}
    M.corpses = {}
    keys = {}
    delete_store(nodes.players)
    delete_store(nodes.apples)
    delete_store(nodes.boxes)
    delete_store(nodes.bullets)
    if nodes.hud then
        gui.delete_node(nodes.hud)
    end
    nodes.hud = nil
    if nodes.scoreboard then
        gui.delete_node(nodes.scoreboard)
    end
    nodes.scoreboard = nil
    gamepush.multiplayer.off_message()
    update_visibility()
end

function M.update(dt)
    if not M.is_visible() then
        return
    end
    if not M.spawned_from_state and sync_local_from_state() then
        M.spawned_from_state = true
    end
    M.shoot_cooldown = math.max(0, (M.shoot_cooldown or 0) - dt)
    update_life(dt)
    local states = gamepush.multiplayer.players_state() or {}
    for victim in pairs(M.kill_credit) do
        local st = lookup_state(states, victim)
        if st and flag_alive(st.alive) and (st.hp or 0) > 0 then
            M.kill_credit[victim] = nil
        end
    end
    update_local(dt)
    update_host(dt)
    update_bullets(dt)
    collect_apples()
    draw()
end

function M.on_input(action_id, action)
    if not M.is_visible() then
        return false
    end
    if action_id == HASH_TOUCH then
        if gui.pick_node(arena_node(), action.x, action.y) then
            if action.pressed and local_can_shoot() then
                local pos = gui.get_position(arena_node())
                shoot(action.x - pos.x - M.local_x, action.y - pos.y - M.local_y)
            end
            return true
        end
        return false
    end
    if action_id == HASH_SPACE then
        if action.pressed and local_can_shoot() then
            shoot(M.dir_x, M.dir_y)
        end
        return true
    end
    if action_id == HASH_LEFT or action_id == HASH_RIGHT or action_id == HASH_UP or action_id == HASH_DOWN
        or action_id == HASH_W or action_id == HASH_A or action_id == HASH_S or action_id == HASH_D then
        if not local_can_move() then
            keys[action_id] = nil
            return true
        end
        if action.released then
            keys[action_id] = nil
        elseif action.pressed or not action.released then
            keys[action_id] = true
        end
        return true
    end
    return false
end

return M
