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
        error_purchase = nil,
        consume = nil,
        error_consume = nil,
        fetch_products = nil,
        error_fetch_products = nil,
        subscribe = nil,
        error_subscribe = nil,
        unsubscribe = nil,
        error_unsubscribe = nil
    },
    channels = {
        create_channel = nil,
        error_create_channel = nil,
        update_channel = nil,
        error_update_channel = nil,
        event_update_channel = nil,
        delete_channel = nil,
        error_delete_channel = nil,
        event_delete_channel = nil,
        fetch_channel = nil,
        error_fetch_channel = nil,
        fetch_channels = nil,
        error_fetch_channels = nil,
        fetch_more_channels = nil,
        error_fetch_more_channels = nil,

        join = nil,
        error_join = nil,
        event_join = nil,
        event_join_request = nil,
        cancel_join = nil,
        error_cancel_join = nil,
        event_cancel_join = nil,
        leave = nil,
        error_leave = nil,
        event_leave = nil,
        kick = nil,
        error_kick = nil,
        fetch_members = nil,
        error_fetch_members = nil,
        fetch_more_members = nil,
        error_fetch_more_members = nil,
        mute = nil,
        error_mute = nil,
        event_mute = nil,
        unmute = nil,
        error_unmute = nil,
        event_unmute = nil,

        send_invite = nil,
        error_send_invite = nil,
        event_invite = nil,
        cancel_invite = nil,
        error_cancel_invite = nil,
        event_cancel_invite = nil,
        accept_invite = nil,
        error_accept_invite = nil,
        reject_invite = nil,
        error_reject_invite = nil,
        event_reject_invite = nil,
        fetch_invites = nil,
        error_fetch_invites = nil,
        fetch_more_invites = nil,
        error_fetch_more_invites = nil,
        fetch_channel_invites = nil,
        error_fetch_channel_invites = nil,
        fetch_more_channel_invites = nil,
        error_fetch_more_channel_invites = nil,
        fetch_sent_invites = nil,
        error_fetch_sent_invites = nil,
        fetch_more_sent_invites = nil,
        error_fetch_more_sent_invites = nil,
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
        error_unlock = nil,
        open = nil,
        close = nil,
        fetch = nil,
        error_fetch = nil
    },
    variables = {
        fetch = nil,
        error_fetch = nil
    },
    games_collections = {
        open = nil,
        close = nil,
        fetch = nil,
        error_fetch = nil
    },
    images = {
        upload = nil,
        error_upload = nil,
        choose = nil,
        error_choose = nil,
        fetch = nil,
        error_fetch = nil,
        fetch_more = nil,
        error_fetch_more = nil
    },
    files = {
        upload = nil,
        error_upload = nil,
        load_content = nil,
        error_load_content = nil,
        choose = nil,
        error_choose = nil,
        fetch = nil,
        error_fetch = nil,
        fetch_more = nil,
        error_fetch_more = nil
    },
    documents = {
        open = nil,
        close = nil,
        fetch = nil,
        error_fetch = nil
    },
    fullscreen = {
        open = nil,
        close = nil,
        change = nil
    }
}

return M