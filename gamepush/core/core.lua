local M = {}

local helpers = require("gamepush.core.helpers")
local callback_ids = require("gamepush.core.callback_ids")
local callbacks = require("gamepush.core.callbacks")

if not html5 then
    gamepush = require("gamepush.mock")
end

local is_init = false

local function get_event_callback_name(callback_id)
    for callback_group, list_callbacks in pairs(callback_ids) do
        for callback_name, id in pairs(list_callbacks) do
            if callback_id == id then
                callback_name = string.gsub(string.gsub(callback_name, ":", "_"), "%u", function(c)
                    return string.format("_%s", string.lower(c))
                end)
                return callback_group, callback_name
            end
        end
    end
end

local function find_callback(callback_group, callback_name)
    for group, section_callbacks in pairs(callbacks) do
        if group == callback_group then
            return section_callbacks[callback_name]
        end
    end
end

local function decode_result(result)
    if result then
        local is_ok, data = pcall(json.decode, result)
        if is_ok then
            if data and type(data) == "table" then
                if data.error and data.error ~= "" then
                    if type(data.error) == "table" then
                        pprint("Error:", data.error)
                    else
                        print(string.format("Error: %s", data.error))
                    end
                end
                if data.object then
                    local is_object_ok, object = pcall(json.decode, data.object)
                    if is_object_ok then
                        return object
                    else
                        return data.object
                    end
                end
                return data.value
            end
            return data
        else
            return result
        end
    end
end

local function on_event_callback(self, message, id)
    local callback_group, callback_name = get_event_callback_name(id)
    if callback_name ~= nil then
        local callback = find_callback(callback_group, callback_name)
        if callback == nil then
            return
        end
        assert(type(callback) == "function", string.format("callbacks.'%s' must be a function!", callback_name))
        if message == "" then
            callback()
        else
            callback(decode_result(message))
        end
    end
end

---Инициализация GamePush
---@param callback function функция обратного вызова по завершению инициализации: callback(success)
function M.init(callback)
    if is_init then
        error("GamePush already initialized!", 2)
    end
    if callback == nil then
        error("Callback function must be specified!", 2)
    end
    helpers.check_callback(callback)
    if sys.get_config_number("gamepush.id", -1) == -1 then
        error("GamePush game id not set!")
    end
    if sys.get_config_string("gamepush.token", nil) == nil then
        error("GamePush game token not set!")
    end
    is_init = true
    gamepush.init(json.encode(callback_ids), on_event_callback, function(self, message, callback_id)
        callback(decode_result(message))
    end)
end

---Выполнить функцию GamePush API. Если method API является объектом, то в parameters дополнительно можно перечислить
---методы (геттеры).
---@param method string выполняемый метод объект или поле объекта, например: "player.sync"
---@param parameters any параметры метода, если параметров несколько, то таблица (массив) параметров.
---@param callback function функция обратного вызова, если nil, тогда функция сразу вернет результат
---@param native_api boolean если true, то будет вызван нативный метод
---@return any результат выполнения метода, или nil, если задан callback
function M.call_api(method, parameters, callback, native_api)
    if not is_init then
        error("Initialize GamePush before calling functions!", 3)
    end
    if parameters == nil or (type(parameters) == "table" and #parameters == 0) then
        parameters = "[]"
    else
        if type(parameters) ~= "table" then
            parameters = { parameters }
        end
        parameters = json.encode(parameters)
    end
    if callback then
        gamepush.call_api(method, parameters, native_api, function(self, message)
            if message == "" then
                callback()
            else
                callback(decode_result(message))
            end
        end)
    else
        local result = gamepush.call_api(method, parameters, native_api)
        return decode_result(result)
    end
end

return M