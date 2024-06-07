// https://kripken.github.io/emscripten-site/docs/porting/connecting_cpp_and_javascript/Interacting-with-code.html
let LibraryGamePush = {
    // This can be accessed from the bootstrap code in the .html file
    $GamePushLib: {
        _callback: null,
        _gp: null,
        _data: {},

        init_callbacks: function (gp, callback_ids) {
            for (let callback_group in callback_ids) {
                let base_object = callback_group === "common" ? gp : gp[callback_group];
                let group_callback_ids = callback_ids[callback_group];
                for (let event_name in group_callback_ids) {
                    base_object.on(event_name, (result) => GamePushLib.send(group_callback_ids[event_name], result));
                }
            }
        },

        send: function (callback_id, data) {
            if (GamePushLib._callback && callback_id > 0) {
                let message = data === undefined || data === null ? "" :
                    typeof (data) === "object" ? JSON.stringify({object: data}) :
                        JSON.stringify({value: data});
				let msg = stringToNewUTF8(message);
                {{{makeDynCall("vii", "GamePushLib._callback")}}}(callback_id, msg);
                Module._free(msg);
            }
        },

        call_api: function (method, parameters, callback_id, native_api) {
            let method_name = UTF8ToString(method);
            let string_parameters = UTF8ToString(parameters);
            let save_as_var = null;
            let saved_object = null;
            if (native_api) {
                let method_parse = method_name.split("=");
                if (method_parse[1]) {
                    save_as_var = method_parse[0];
                    method_name = method_parse[1];
                }
                method_parse = method_name.split(":");
                if (method_parse[1]) {
                    saved_object = GamePushLib._data[method_parse[0]];
                    if (!saved_object) {
                        let error = `The "${method_parse[0]}" object has not been previously saved!`;
                        return JSON.stringify({error: error});
                    }
                    method_name = method_parse[1];
                }
            }
            let path = method_name.split(".");
            let parent_object = native_api ? saved_object ? saved_object :
                GamePushLib._gp.platform.getNativeSDK() : GamePushLib._gp;
            let result_object = parent_object;
            let last_index = path.length - 1
            for (let index = 0; index < path.length; index++) {
                let item = path[index];
                if (parent_object[item]) {
                    if (index === last_index) {
                        result_object = parent_object[item];
                    } else {
                        parent_object = parent_object[item];
                    }
                } else {
                    let error = `Field or function "${method_name}" not found!`;
                    return JSON.stringify({error: error});
                }
            }
            let array_parameters = JSON.parse(string_parameters);
            switch (typeof result_object) {
                case "string":
                case "number":
                case "boolean":
                    return JSON.stringify({value: result_object});
                case "object":
                    try {
                        return JSON.stringify({object: JSON.stringify(result_object)});
                    } catch (error) {
                        return JSON.stringify({error: error});
                    }
                case "function":
                    try {
                        let called_function = result_object.bind(parent_object);
                        if (callback_id === 0) {
                            let result = called_function(...array_parameters);
                            switch (typeof result) {
                                case "string":
                                case "number":
                                case "boolean":
                                    return JSON.stringify({value: result});
                                case "object":
                                    return JSON.stringify({object: result});
                                case "undefined":
                                    return;
                            }
                            return JSON.stringify({error: `"${typeof result}" type not supported!`});
                        } else {
                            called_function(...array_parameters).then(
                                function (success) {
                                    if (save_as_var) {
                                        GamePushLib._data[save_as_var] = success;
                                    }
                                    GamePushLib.send(callback_id, success);
                                }).catch(
                                function (error) {
                                    GamePushLib.send(callback_id, JSON.stringify({error: error}));
                                })
                        }
                    } catch (error) {
                        return JSON.stringify({error: error});
                    }
                    return;
                default:
                    return JSON.stringify({error: `"${typeof result_object}" type not supported!`});
            }
        },
    },

    // These can be called from within the extension, in C++
    GamePush_RegisterCallback: function (callback) {
        GamePushLib._callback = callback;
    },

    GamePush_RemoveCallback: function () {
        GamePushLib._callback = null;
    },

    GamePush_Init: function (parameters, callback_id) {
        let callback_ids = JSON.parse(UTF8ToString(parameters));
        GamePushLib.init = function (gp, initResult) {
            GamePushLib._gp = gp;
            if (initResult === true) {
                GamePushLib.init_callbacks(gp, callback_ids);
            }
            GamePushLib.send(callback_id, initResult);
        }
        if (window.GamePushInit !== undefined) {
            GamePushLib.init(window.GamePushInstance, window.GamePushInit);
        }
    },

    GamePush_CallApi: function (method, parameters, callback_id, native_api) {
        let result = GamePushLib.call_api(method, parameters, callback_id, native_api);
        if (result) {
            if (callback_id > 0) {
                GamePushLib.send(callback_id, result);
            } else {
				return stringToUTF8OnStack(result);
            }
        }
    },
}

autoAddDeps(LibraryGamePush, '$GamePushLib');
addToLibrary(LibraryGamePush);