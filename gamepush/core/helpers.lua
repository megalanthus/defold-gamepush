local M = {}

function M.check_callback(callback)
    if callback ~= nil and type(callback) ~= "function" then
        error(string.format("The 'callback' parameter must be a function!"), 3)
    end
end

function M.check_key(key)
    if type(key) ~= "string" then
        error("The key must be a string!", 3)
    end
end

function M.check_string(str, parameter_name, can_be_nil)
    if (can_be_nil and str == nil) or type(str) == "string" then
        return
    end
    error(string.format("The '%s' must be a string!", parameter_name), 3)
end

function M.check_value(value)
    if type(value) ~= "string" and type(value) ~= "number" and type(value) ~= "boolean" then
        error("The value must be a string, number, or boolean!", 3)
    end
end

function M.check_string_or_number(parameter, parameter_name)
    if type(parameter) ~= "string" and type(parameter) ~= "number" then
        error(string.format("The '%s' must be a string or number!", parameter_name), 3)
    end
end

function M.check_number(value, parameter_name, can_be_nil)
    if (can_be_nil and value == nil) or type(value) == "number" then
        return
    end
    error(string.format("The '%s' must be a number!", parameter_name), 3)
end

function M.check_boolean(value, parameter_name, can_be_nil)
    if (can_be_nil and value == nil) or type(value) == "boolean" then
        return
    end
    error(string.format("The '%s' must be a boolean!", parameter_name), 3)
end

function M.check_table(parameters)
    if parameters ~= nil and type(parameters) ~= "table" then
        error("The 'parameters' must be a table!", 3)
    end
end

function M.check_table_required(parameters)
    if type(parameters) ~= "table" then
        error("The 'parameters' must be a table!", 3)
    end
end

return M