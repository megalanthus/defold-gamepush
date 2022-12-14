local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")
local callbacks = require("gamepush.core.callbacks")

---Открыть оверлей с играми
---@param collection number|string id или tag коллекции
---@param callback function функция обратного вызова по результату открытия оверлея: callback()
function M.open(collection, callback)
    helpers.check_callback(callback)
    local parameters
    if collection then
        parameters = helpers.make_parameters_id_or_tag(collection, "Collection")
    end
    core.call_api("gamesCollections.open", { parameters }, callback)
end

---Получить коллекцию игр
---@param collection number|string id или tag коллекции
---@param callback function функция обратного вызова по результату получения коллекции игр: callback(result)
---@return table
function M.fetch(collection, callback)
    helpers.check_callback(callback)
    local parameters
    if collection then
        parameters = helpers.make_parameters_id_or_tag(collection, "Collection")
    end
    core.call_api("gamesCollections.fetch", { parameters }, callback)
end

M.callbacks = callbacks.games_collections

return M