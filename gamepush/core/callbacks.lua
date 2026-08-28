local M = {
    common = {
        change_orientation = nil,
        pause = nil,
        resume = nil,
        event_connect = nil
    },
    player = {
        sync = nil,
        load = nil,
        login = nil,
        fetch_fields = nil,
        change = nil,
        logout = nil
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

        open_chat = nil,
        close_chat = nil,
        error_open_chat = nil,

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

        accept_join_request = nil,
        error_accept_join_request = nil,
        reject_join_request = nil,
        error_reject_join_request = nil,
        event_reject_join_request = nil,
        fetch_join_requests = nil,
        error_fetch_join_requests = nil,
        fetch_more_join_requests = nil,
        error_fetch_more_join_requests = nil,
        fetch_sent_join_requests = nil,
        error_fetch_sent_join_requests = nil,
        fetch_more_sent_join_requests = nil,
        error_fetch_more_sent_join_requests = nil,

        send_message = nil,
        error_send_message = nil,
        event_message = nil,
        edit_message = nil,
        error_edit_message = nil,
        event_edit_message = nil,
        delete_message = nil,
        error_delete_message = nil,
        event_delete_message = nil,
        fetch_messages = nil,
        error_fetch_messages = nil,
        fetch_more_messages = nil,
        error_fetch_more_messages = nil,
        set_value = nil,
        error_set_value = nil,
        add_value = nil,
        error_add_value = nil,
        event_change_value = nil
    },
    events = {
        join = nil,
        error_join = nil
    },
    rewards = {
        give = nil,
        error_give = nil,
        accept = nil,
        error_accept = nil
    },
    schedulers = {
        claim_day = nil,
        error_claim_day = nil,
        claim_day_additional = nil,
        error_claim_day_additional = nil,
        claim_all_day = nil,
        error_claim_all_day = nil,
        claim_all_days = nil,
        error_claim_all_days = nil,
        join = nil,
        error_join = nil
    },
    triggers = {
        activate = nil,
        claim = nil,
        error_claim = nil
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
        progress = nil,
        error_progress = nil,
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
    },
    sounds = {
        mute = nil,
        unmute = nil,
        mute_sfx = nil,
        unmute_sfx = nil,
        mute_music = nil,
        unmute_music = nil
    },
    socials = {
        share = nil,
        post = nil,
        invite = nil,
        join_community = nil
    },
    storage = {
        set = nil,
        get = nil,
        set_global = nil,
        get_global = nil
    },
    segments = {
        enter = nil,
        leave = nil
    },
    feedbacks = {
        create_feedback = nil,
        error_create_feedback = nil,
        open_feedbacks_list = nil,
        error_open_feedbacks_list = nil,
        fetch_feedbacks = nil,
        error_fetch_feedbacks = nil,
        fetch_more_feedbacks = nil,
        error_fetch_more_feedbacks = nil,
        send_message = nil,
        error_send_message = nil,
        event_feedback_message = nil,
        event_feedback_created = nil,
        event_feedback_status_updated = nil,
        event_feedback_platform_status_updated = nil
    },
    reactions = {
        set = nil,
        unset = nil,
        set_error = nil,
        unset_error = nil,
        event_set = nil,
        event_unset = nil
    },
    uniques = {
        register = nil,
        error_register = nil,
        check = nil,
        error_check = nil,
        delete = nil,
        error_delete = nil
    },
    multiplayer = {
        connect = nil,
        disconnect = nil,
        player_joined = nil,
        player_left = nil,
        became_host = nil,
        became_peer = nil,
        host_migrated = nil,
        players_updated = nil,
        global_state_updated = nil,
        error_connect = nil,
        error_send_state = nil,
        error_disconnect = nil,
        tick = nil,
        message = nil,
        player_initializer = nil
    },
    windows = {
        confirm_close = nil
    }
}

return M