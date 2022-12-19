// https://kripken.github.io/emscripten-site/docs/porting/connecting_cpp_and_javascript/Interacting-with-code.html
let LibraryGamePush = {
    // This can be accessed from the bootstrap code in the .html file
    $GamePushLib: {
        _callback: null,
        _gp: null,
        _data: {},

        init_callbacks: function (gp, callback_ids) {
            gp.on("pause", () => GamePushLib.send(callback_ids.common_pause));
            gp.on("resume", () => GamePushLib.send(callback_ids.common_resume));
            gp.player.on("sync", (success) => GamePushLib.send(callback_ids.player_sync, success));
            gp.player.on("load", (success) => GamePushLib.send(callback_ids.player_load, success));
            gp.player.on("login", (success) => GamePushLib.send(callback_ids.player_login, success));
            gp.player.on("fetchFields", (success) => GamePushLib.send(callback_ids.player_fetch_fields, success));
            gp.player.on("change", () => GamePushLib.send(callback_ids.player_change));
            gp.payments.on("purchase", (result) => GamePushLib.send(callback_ids.payments_purchase, result));
            gp.payments.on("error:purchase", (error) => GamePushLib.send(callback_ids.payments_purchase_error, error));
            gp.payments.on("consume", (result) => GamePushLib.send(callback_ids.payments_consume, result));
            gp.payments.on("error:consume", (error) => GamePushLib.send(callback_ids.payments_consume_error, error));
            gp.payments.on("fetchProducts", (result) => GamePushLib.send(callback_ids.payments_fetch_products, result));
            gp.payments.on("error:fetchProducts", (error) => GamePushLib.send(callback_ids.payments_fetch_products_error, error));
            gp.payments.on("subscribe", (result) => GamePushLib.send(callback_ids.payments_subscribe, result));
            gp.payments.on("error:subscribe", (error) => GamePushLib.send(callback_ids.payments_subscribe_error, error));
            gp.payments.on("unsubscribe", (result) => GamePushLib.send(callback_ids.payments_unsubscribe, result));
            gp.payments.on("error:unsubscribe", (error) => GamePushLib.send(callback_ids.payments_unsubscribe_error, error));
            gp.ads.on("start", () => GamePushLib.send(callback_ids.ads_start));
            gp.ads.on("close", (success) => GamePushLib.send(callback_ids.ads_close, success));
            gp.ads.on("fullscreen:start", () => GamePushLib.send(callback_ids.ads_fullscreen_start));
            gp.ads.on("fullscreen:close", (success) => GamePushLib.send(callback_ids.ads_fullscreen_close, success));
            gp.ads.on("preloader:start", () => GamePushLib.send(callback_ids.ads_preloader_start));
            gp.ads.on("preloader:close", (success) => GamePushLib.send(callback_ids.ads_preloader_close, success));
            gp.ads.on("rewarded:start", () => GamePushLib.send(callback_ids.ads_rewarded_start));
            gp.ads.on("rewarded:close", (success) => GamePushLib.send(callback_ids.ads_rewarded_close, success));
            gp.ads.on("rewarded:reward", () => GamePushLib.send(callback_ids.ads_rewarded_reward));
            gp.ads.on("sticky:start", () => GamePushLib.send(callback_ids.ads_sticky_start));
            gp.ads.on("sticky:render", () => GamePushLib.send(callback_ids.ads_sticky_render));
            gp.ads.on("sticky:refresh", () => GamePushLib.send(callback_ids.ads_sticky_refresh));
            gp.ads.on("sticky:close", () => GamePushLib.send(callback_ids.ads_sticky_close));
            gp.achievements.on("unlock", (achievement) => GamePushLib.send(callback_ids.achievements_unlock, achievement));
            gp.achievements.on("error:unlock", (error) => GamePushLib.send(callback_ids.achievements_unlock_error, error));
            gp.achievements.on("open", () => GamePushLib.send(callback_ids.achievements_open));
            gp.achievements.on("close", () => GamePushLib.send(callback_ids.achievements_close));
            gp.achievements.on("fetch", (result) => GamePushLib.send(callback_ids.achievements_fetch, result));
            gp.achievements.on("error:fetch", (error) => GamePushLib.send(callback_ids.achievements_fetch_error, error));
            gp.variables.on("fetch", () => GamePushLib.send(callback_ids.variables_fetch));
            gp.variables.on("error:fetch", (error) => GamePushLib.send(callback_ids.variables_fetch_error, error));
            gp.gamesCollections.on("open", () => GamePushLib.send(callback_ids.games_collections_open));
            gp.gamesCollections.on("close", () => GamePushLib.send(callback_ids.games_collections_close));
            gp.gamesCollections.on("fetch", (result) => GamePushLib.send(callback_ids.games_collections_fetch, result));
            gp.gamesCollections.on("error:fetch", (error) => GamePushLib.send(callback_ids.games_collections_fetch_error, error));
            gp.images.on("upload", (image) => GamePushLib.send(callback_ids.images_upload, image));
            gp.images.on("error:upload", (error) => GamePushLib.send(callback_ids.images_upload_error, error));
            gp.images.on("choose", (result) => GamePushLib.send(callback_ids.images_choose, result));
            gp.images.on("error:choose", (error) => GamePushLib.send(callback_ids.images_choose_error, error));
            gp.images.on("fetch", (result) => GamePushLib.send(callback_ids.images_fetch, result));
            gp.images.on("error:fetch", (error) => GamePushLib.send(callback_ids.images_fetch_error, error));
            gp.images.on("fetchMore", (result) => GamePushLib.send(callback_ids.images_fetch_more, result));
            gp.images.on("error:fetchMore", (error) => GamePushLib.send(callback_ids.images_fetch_more_error, error));
            gp.files.on("upload", (result) => GamePushLib.send(callback_ids.files_upload, result));
            gp.files.on("error:upload", (error) => GamePushLib.send(callback_ids.files_upload_error, error));
            gp.files.on("loadContent", (text) => GamePushLib.send(callback_ids.files_load_content, text));
            gp.files.on("error:loadContent", (error) => GamePushLib.send(callback_ids.files_load_content_error, error));
            gp.files.on("choose", (result) => GamePushLib.send(callback_ids.files_choose, result));
            gp.files.on("error:choose", (error) => GamePushLib.send(callback_ids.files_choose_error, error));
            gp.files.on("fetch", (result) => GamePushLib.send(callback_ids.files_fetch, result));
            gp.files.on("error:fetch", (error) => GamePushLib.send(callback_ids.files_fetch_error, error));
            gp.files.on("fetchMore", (result) => GamePushLib.send(callback_ids.files_fetch_more, result));
            gp.files.on("error:fetchMore", (error) => GamePushLib.send(callback_ids.files_fetch_more_error, error));
            gp.documents.on("open", () => GamePushLib.send(callback_ids.documents_open));
            gp.documents.on("close", () => GamePushLib.send(callback_ids.documents_close));
            gp.documents.on("fetch", (document) => GamePushLib.send(callback_ids.documents_fetch, document));
            gp.documents.on("error:fetch", (error) => GamePushLib.send(callback_ids.documents_fetch_error, error));
            gp.fullscreen.on("open", () => GamePushLib.send(callback_ids.fullscreen_open));
            gp.fullscreen.on("close", () => GamePushLib.send(callback_ids.fullscreen_close));
            gp.fullscreen.on("change", () => GamePushLib.send(callback_ids.fullscreen_change));
        },

        send: function (callback_id, data) {
            if (GamePushLib._callback && callback_id > 0) {
                let message = data === undefined || data === null ? "" :
                    typeof (data) === "object" ? JSON.stringify({object: data}) :
                        JSON.stringify({value: data});
                let msg = allocate(intArrayFromString(message), ALLOC_NORMAL);
                {{{makeDynCall("viii", "GamePushLib._callback")}}}(callback_id, msg);
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
                return allocate(intArrayFromString(result), ALLOC_NORMAL);
            }
        }
    },
}

autoAddDeps(LibraryGamePush, '$GamePushLib');
mergeInto(LibraryManager.library, LibraryGamePush);