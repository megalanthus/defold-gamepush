local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")
local callbacks = require("gamepush.core.callbacks")

---Игрок авторизован
---@return boolean
function M.is_logged_in()
    return core.call_api("player.isLoggedIn").value == true
end

---Игрок использует один из способов входа (кука, авторизация, секретный код)
---@return boolean
function M.has_any_credentials()
    return core.call_api("player.hasAnyCredentials").value == true
end

---Игрок авторизован на платформе
---@return boolean
function M.is_logged_in_by_platform()
    return core.call_api("player.isLoggedInByPlatform").value == true
end

---Синхронизация игрока
---@param parameters table параметры
---@param callback function функция обратного вызова по результату синхронизации: callback()
function M.sync(parameters, callback)
    helpers.check_table(parameters, "parameters")
    helpers.check_callback(callback)
    core.call_api("player.sync", { parameters }, callback)
end

---Загрузка игрока с сервера с перезаписью локального
---@param callback function функция обратного вызова по результату синхронизации: callback()
function M.load(callback)
    helpers.check_callback(callback)
    core.call_api("player.load", nil, callback)
end

---Вход
---@param callback function функция обратного вызова по результату входа: callback(result)
function M.login(callback)
    helpers.check_callback(callback)
    core.call_api("player.login", nil, callback)
end

---Получить список полей игрока
---@param callback function функция обратного вызова по результату получения полей игрока: callback()
function M.fetch_fields(callback)
    helpers.check_callback(callback)
    core.call_api("player.fetchFields", nil, callback)
end

---ID игрока
---@return number
function M.id()
    return core.call_api("player.id").value
end

---Очки игрока
---@return number
function M.score()
    return core.call_api("player.score").value
end

---Имя игрока
---@return string
function M.name()
    return core.call_api("player.name").value
end

---Ссылка на аватар игрока
---@return string
function M.avatar()
    return core.call_api("player.avatar").value
end

---Заглушка — пустой ли игрок или данные в нём отличаются умолчательных
---@return boolean
function M.is_stub()
    return core.call_api("player.isStub").value == true
end

---Поля игрока
---@return table
function M.fields()
    return core.call_api("player.fields").value
end

---Получить значение поля key
---@param key string ключ
---@return string|number|boolean значение поля key
function M.get(key)
    helpers.check_key(key)
    return core.call_api("player.get", key).value
end

---Установить значение поля key
---@param key string ключ
---@param value string|number|boolean значение поля key
function M.set(key, value)
    helpers.check_key(key)
    helpers.check_value(value)
    core.call_api("player.set", { key, value })
end

---Добавить значение к полю key
---@param key string ключ
---@param value number добавляемое значение
function M.add(key, value)
    helpers.check_key(key)
    helpers.check_number_value(value, "value")
    core.call_api("player.add", { key, value })
end

---Инвертировать значение поля key
---@param key string ключ
function M.toggle(key)
    helpers.check_key(key)
    core.call_api("player.toggle", key)
end

---Проверить есть ли поле key и оно не пустое (не 0, '', false, null, undefined)
---@param key string ключ
---@return boolean результат
function M.has(key)
    helpers.check_key(key)
    return core.call_api("player.has", key).value
end

---Возвращает состояние игрока объектом
---@return table таблица с данными игрока
function M.to_json()
    return core.call_api("player.toJSON")
end

---Устанавливает состояние игрока из объекта
---@param player table таблица с данными игрока
function M.from_json(player)
    helpers.check_table(player, "player")
    core.call_api("player.fromJSON", { player })
end

---Сбрасывает состояние игрока на умолчательное
function M.reset()
    core.call_api("player.reset")
end

---Удаляет игрока — сбрасывает поля и очищает ID
function M.remove()
    core.call_api("player.remove")
end

---Получить поле по ключу key
---@param key string ключ
---@return table результат
function M.get_field(key)
    helpers.check_key(key)
    return core.call_api("player.getField", key)
end

---Получить переведенное имя поля по ключу key
---@param key string ключ
---@return string результат
function M.get_field_name(key)
    helpers.check_key(key)
    return core.call_api("player.getFieldName", key).value
end

---Получить переведенное имя варианта поля (enum) по ключу key и его значению value
---@param key string ключ
---@param value string значение
---@return table результат
function M.get_field_variant_name(key, value)
    helpers.check_key(key)
    if type(value) ~= "string" then
        error("The value must be a string!", 2)
    end
    return core.call_api("player.getFieldVariantName", { key, value }).value
end

M.callbacks = callbacks.player

return M