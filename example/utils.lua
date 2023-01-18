local M = {}

local padding = vmath.vector3(10, 10, 0)
local button_id = hash("template/button")
local label_id = hash("template/label")

local function table_to_string(tbl, space_count)
    if tbl == nil then
        return "nil"
    end
    if space_count == nil then
        space_count = 0
    end
    local result = ""
    for key, value in pairs(tbl) do
        local space = ""
        if space_count > 0 then
            space = string.rep(" ", space_count)
        end
        if type(value) == "table" then
            result = string.format("%s%s%s:\n%s", result, space, key, table_to_string(value, space_count + 2))
        else
            result = string.format("%s%s%s: %s\n", result, space, key, tostring(value))
        end
    end
    return result
end

local function to_string(...)
    local data = ""
    for _, value in ipairs { ... } do
        if type(value) == "table" then
            data = string.format("%s%s\n", data, table_to_string(value))
        else
            data = string.format("%s%s\n", data, tostring(value))
        end
    end
    return data
end

function M.to_log(...)
    local data = to_string(...)
    gui.set_text(gui.get_node("label_log"), data)
end

function M.to_console(...)
    local data = to_string(...)
    gui.set_text(gui.get_node("label_console"), data)
    pprint(...)
end

function M.make_buttons(buttons, offset_position)
    local width = gui.get_width()
    local height = gui.get_height()
    local button_template = gui.get_node(button_id)
    local button_size = gui.get_size(button_template)
    gui.set_visible(button_template, false)
    local count_at_width = width / 2 / (button_size.x + padding.x)
    local index = 0
    local position = vmath.vector3()
    for _, button_data in pairs(buttons) do
        local pos = vmath.vector3(index % count_at_width, math.floor(index / count_at_width), 0)
        position = vmath.mul_per_elem((button_size + padding), pos) + button_size / 2 + padding / 2 + offset_position
        position.y = height - position.y
        index = index + 1
        local button = gui.clone_tree(button_template)
        gui.set_text(button[label_id], button_data.name)
        local button_node = button[button_id]
        button_data.node = button_node
        gui.set_position(button_data.node, position)
        gui.set_visible(button_node, true)
    end
    position.x = offset_position.x
    position.y = height - (position.y - button_size.y - padding.y * 2)
    return position
end

function M.handle_buttons(buttons, x, y)
    for _, button in pairs(buttons) do
        if gui.pick_node(button.node, x, y) then
            if button.callback then
                button.callback(button.section)
            end
        end
    end
end

function M.delete_buttons(buttons)
    for _, button in pairs(buttons) do
        gui.delete_node(button.node)
    end
end

return M