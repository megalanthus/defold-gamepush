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
---@param product number|string id или tag продукта
---@param callback function функция обратного вызова по результату покупки продукта: callback(result)
function M.purchase(product, callback)
    local parameters = helpers.make_parameters_id_or_tag(product, "Product")
    helpers.check_callback(callback)
    core.call_api("payments.purchase", { parameters }, callback)
end

---Использование покупки
---@param product number|string id или tag продукта
---@param callback function функция обратного вызова по результату использования продукта: callback(result)
function M.consume(product, callback)
    local parameters = helpers.make_parameters_id_or_tag(product, "Product")
    helpers.check_callback(callback)
    core.call_api("payments.consume", { parameters }, callback)
end

---Проверка наличия покупки
---@param product number|string id или tag продукта
---@return boolean результат
function M.has(product)
    local parameters = helpers.make_parameters_id_or_tag(product, "Product")
    return core.call_api("payments.has", parameters.id or parameters.tag) == true
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
---@param product number|string id или tag продукта
---@param callback function функция обратного вызова по результату подписки: callback(result)
function M.subscribe(product, callback)
    local parameters = helpers.make_parameters_id_or_tag(product, "Product")
    helpers.check_callback(callback)
    core.call_api("payments.subscribe", { parameters }, callback)
end

---Отмена подписки
---@param product number|string id или tag продукта
---@param callback function функция обратного вызова по результату подписки: callback(result)
function M.unsubscribe(product, callback)
    local parameters = helpers.make_parameters_id_or_tag(product, "Product")
    helpers.check_callback(callback)
    core.call_api("payments.unsubscribe", { parameters }, callback)
end

M.callbacks = callbacks.payments

return M