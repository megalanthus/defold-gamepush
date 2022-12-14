local M = {
    common = {
        pause = nil,
        resume = nil
    },
    player = {
        sync = nil,
        load = nil,
        login = nil,
        fetch_fields = nil,
        change = nil
    },
    payments = {
        purchase = nil,
        purchase_error = nil,
        consume = nil,
        consume_error = nil,
        fetch_products = nil,
        fetch_products_error = nil,
        subscribe = nil,
        subscribe_error = nil,
        unsubscribe = nil,
        unsubscribe_error = nil
    },
    ads = {
        start = nil,
        close = nil,
        fullscreen_start = nil,
        fullscreen_close = nil,
        preloader_start = nil,
        preloader_close = nil,
        rewarded_start = nil,
        rewarded_close = nil,
        rewarded_reward = nil,
        sticky_start = nil,
        sticky_render = nil,
        sticky_refresh = nil,
        sticky_close = nil
    },
    achievements = {
        unlock = nil,
        unlock_error = nil,
        open = nil,
        close = nil,
        fetch = nil,
        fetch_error = nil
    },
    variables = {
        fetch = nil,
        fetch_error = nil
    },
    games_collections = {
        open = nil,
        close = nil,
        fetch = nil,
        fetch_error = nil
    },
    images = {
        upload = nil,
        upload_error = nil,
        choose = nil,
        choose_error = nil,
        fetch = nil,
        fetch_error = nil,
        fetch_more = nil,
        fetch_more_error = nil
    },
    files = {
        upload = nil,
        upload_error = nil,
        load_content = nil,
        load_content_error = nil,
        choose = nil,
        choose_error = nil,
        fetch = nil,
        fetch_error = nil,
        fetch_more = nil,
        fetch_more_error = nil
    },
    documents = {
        open = nil,
        close = nil,
        fetch = nil,
        fetch_error = nil
    },
    fullscreen = {
        open = nil,
        close = nil,
        change = nil
    }
}

return M