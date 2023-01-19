local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function is_available()
    utils.to_log("Payments is available:", gamepush.payments.is_available())
end

local function purchase()
    gamepush.payments.purchase({ id = 749 }, function(result)
        utils.to_log("Payments purchase:", result)
    end)
end

local function consume()
    gamepush.payments.consume({ id = 749 }, function(result)
        utils.to_log("Payments consume:", result)
    end)
end

local function has()
    utils.to_log("Payments has:", gamepush.payments.has(749))
end

local function fetch_products()
    gamepush.payments.fetch_products(function(result)
        utils.to_log("Payments fetch products:", result)
    end)
end

local function is_subscriptions_available()
    utils.to_log("Subscriptions is available:", gamepush.payments.is_subscriptions_available())
end

local function subscribe()
    gamepush.payments.subscribe({ tag = "Test_subscription" }, function(result)
        utils.to_log("Subscribe:", result)
    end)
end

local function unsubscribe()
    gamepush.payments.unsubscribe({ tag = "Test_subscription" }, function(result)
        utils.to_log("Unsubscribe:", result)
    end)
end

local M = {
    { name = "Is available", callback = is_available },
    { name = "Purchase", callback = purchase },
    { name = "Consume", callback = consume },
    { name = "Has", callback = has },
    { name = "Fetch products", callback = fetch_products },
    { name = "Is subscriptions available", callback = is_subscriptions_available },
    { name = "Subscribe", callback = subscribe },
    { name = "Unsubscribe", callback = unsubscribe },
}

gamepush.payments.callbacks.purchase = function(result)
    utils.to_console("Payments purchase:", result)
end
gamepush.payments.callbacks.error_purchase = function(error)
    utils.to_console("Payments purchase error:", error)
end
gamepush.payments.callbacks.consume = function(result)
    utils.to_console("Payments consume:", result)
end
gamepush.payments.callbacks.error_consume = function(error)
    utils.to_console("Payments consume error:", error)
end
gamepush.payments.callbacks.fetch_products = function(result)
    utils.to_console("Payments fetch products:", result)
end
gamepush.payments.callbacks.error_fetch_products = function(error)
    utils.to_console("Payments fetch products error:", error)
end

gamepush.payments.callbacks.subscribe = function(result)
    utils.to_console("Subscribe:", result)
end
gamepush.payments.callbacks.error_subscribe = function(error)
    utils.to_console("Subscribe error:", error)
end
gamepush.payments.callbacks.unsubscribe = function(result)
    utils.to_console("Unsubscribe:", result)
end
gamepush.payments.callbacks.error_unsubscribe = function(error)
    utils.to_console("Unsubscribe error:", error)
end

return M