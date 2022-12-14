local M = {}

local mock_api = require("gamepush.mock_api")

local event_callback
local mock_native_api

local function send(callback_id, message)
    event_callback(nil, message, callback_id)
end

---Установить заглушки для нативного API
---@param tbl table таблица с заглушками нативного API
function M.set_native_api(tbl)
    if type(tbl) ~= "table" then
        error("Native API must be a table!", 2)
    end
    mock_native_api = tbl
end

function M.init(callback_ids, on_event_callback, callback)
    event_callback = on_event_callback
    mock_api.send = send
    mock_api.init()
    callback(nil, true)
end

function M.call_api(method, parameters, native_api, callback)
    local result
    local method_api
    if native_api == true then
        method_api = mock_native_api[method]
    else
        method_api = mock_api[method]
    end
    if method_api then
        if type(method_api) == "function" then
            result = method_api(unpack(json.decode(parameters)))
        else
            result = method_api
        end
    end
    if callback then
        callback(nil, result)
    else
        return result
    end
end

M.set_native_api(require("gamepush.mock_native_api"))
return M