local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function is_available()
    utils.to_log("Payments is available: " .. tostring(gamepush.payments.is_available()))
end

local function purchase()
    gamepush.payments.purchase(749, function(result)
        utils.to_log("Payments purchase:\n" .. utils.table_to_string(result))
    end)
end

local function consume()
    gamepush.payments.consume(749, function(result)
        utils.to_log("Payments consume:\n" .. utils.table_to_string(result))
    end)
end

local function has()
    utils.to_log("Payments has: " .. tostring(gamepush.payments.has(749)))
end

local function fetch_products()
    gamepush.payments.fetch_products(function(result)
        utils.to_log("Payments fetch products:\n" .. utils.table_to_string(result))
    end)
end

local function is_subscriptions_available()
    utils.to_log("Subscriptions is available: " .. tostring(gamepush.payments.is_subscriptions_available()))
end

local function subscribe()
    gamepush.payments.subscribe("Test_subscription", function(result)
        utils.to_log("Subscribe:\n" .. utils.table_to_string(result))
    end)
end

local function unsubscribe()
    gamepush.payments.unsubscribe("Test_subscription", function(result)
        utils.to_log("Unsubscribe:\n" .. utils.table_to_string(result))
    end)
end

local M = {
    { name = "Is available", callback = is_available },
    { name = "Purchase", callback = purchase },
    { name = "Consume", callback = consume },
    { name = "Fetch products", callback = fetch_products },
    { name = "Is subscriptions available", callback = is_subscriptions_available },
    { name = "Subscribe", callback = subscribe },
    { name = "Unsubscribe", callback = unsubscribe },
}

gamepush.payments.callbacks.purchase = function(result)
    utils.to_console("Payments purchase:", result)
end
gamepush.payments.callbacks.purchase_error = function(error)
    utils.to_console("Payments purchase error:", error)
end
gamepush.payments.callbacks.consume = function(result)
    utils.to_console("Payments consume:", result)
end
gamepush.payments.callbacks.consume_error = function(error)
    utils.to_console("Payments consume error:", error)
end
gamepush.payments.callbacks.fetch_products = function(result)
    utils.to_console("Payments fetch products:", result)
end
gamepush.payments.callbacks.fetch_products_error = function(error)
    utils.to_console("Payments fetch products error:", error)
end

gamepush.payments.callbacks.subscribe = function(result)
    utils.to_console("Subscribe:", result)
end
gamepush.payments.callbacks.subscribe_error = function(error)
    utils.to_console("Subscribe error:", error)
end
gamepush.payments.callbacks.unsubscribe = function(result)
    utils.to_console("Unsubscribe:", result)
end
gamepush.payments.callbacks.unsubscribe_error = function(error)
    utils.to_console("Unsubscribe error:", error)
end

return M