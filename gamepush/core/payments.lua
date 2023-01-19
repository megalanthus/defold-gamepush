local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")
local callbacks = require("gamepush.core.callbacks")

---Проверка поддержки платежей на платформе
---@return boolean результат
function M.is_available()
    return core.call_api("payments.isAvailable") == true
end

---Покупка
---@param parameters table параметры
---@param callback function функция обратного вызова по результату покупки продукта: callback(result)
function M.purchase(parameters, callback)
    helpers.check_table_required(parameters)
    helpers.check_callback(callback)
    core.call_api("payments.purchase", { parameters }, callback)
end

---Использование покупки
---@param parameters table параметры
---@param callback function функция обратного вызова по результату использования продукта: callback(result)
function M.consume(parameters, callback)
    helpers.check_table_required(parameters)
    helpers.check_callback(callback)
    core.call_api("payments.consume", { parameters }, callback)
end

---Проверка наличия покупки
---@param product string|number тег или идентификатор продукта
---@return boolean результат
function M.has(product)
    return core.call_api("payments.has", product) == true
end

---Получение списка продуктов
---@param callback function функция обратного вызова по результату получения списка продуктов: callback(result)
function M.fetch_products(callback)
    helpers.check_callback(callback)
    core.call_api("payments.fetchProducts", nil, callback)
end

---Проверка поддержки подписки на платформе
---@return boolean результат
function M.is_subscriptions_available()
    return core.call_api("payments.isSubscriptionsAvailable") == true
end

---Подписка
---@param parameters table параметры
---@param callback function функция обратного вызова по результату подписки: callback(result)
function M.subscribe(parameters, callback)
    helpers.check_table_required(parameters)
    helpers.check_callback(callback)
    core.call_api("payments.subscribe", { parameters }, callback)
end

---Отмена подписки
---@param parameters table параметры
---@param callback function функция обратного вызова по результату подписки: callback(result)
function M.unsubscribe(parameters, callback)
    helpers.check_table_required(parameters)
    helpers.check_callback(callback)
    core.call_api("payments.unsubscribe", { parameters }, callback)
end

M.callbacks = callbacks.payments

return M