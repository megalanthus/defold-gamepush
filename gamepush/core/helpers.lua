local M = {}

function M.check_callback(callback)
    if callback == nil or type(callback) == "function" then
        return
    end
    error(string.format("The callback parameter must be a function!"), 3)
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

function M.check_number_value(value, parameter_name, can_be_nil)
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

function M.check_table(tbl, parameter_name)
    if tbl == nil or type(tbl) == "table" then
        return
    end
    error(string.format("The '%s' parameter must be a table!", parameter_name), 3)
end

function M.check_table_required(tbl, parameter_name)
    if type(tbl) ~= "table" then
        error(string.format("The '%s' parameter must be a table!", parameter_name), 3)
    end
end

function M.make_parameters_id_or_tag(id_or_tag, id_or_tag_name)
    if id_or_tag == nil then
        error(string.format("%s id or tag is required!", id_or_tag_name), 3)
    end
    local parameters = {}
    if type(id_or_tag) == "number" then
        parameters.id = id_or_tag
    elseif type(id_or_tag) == "string" then
        parameters.tag = id_or_tag
    else
        error(string.format("%s must be a number or a string!", id_or_tag_name), 3)
    end
    return parameters
end

return M