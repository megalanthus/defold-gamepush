local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local channel_id = 0

local function create_channel()
    local parameters = {
        template = "test_channel_template",
        capacity = 4,
        name = "my test channel"
    }
    gamepush.channels.create_channel(parameters, function(channel)
        utils.to_log("Create channel:", channel)
        channel_id = channel.id
    end)
end

local function update_channel()
    local parameters = {
        channelId = channel_id,
        capacity = 8,
        name = "my test channel 22"
    }
    gamepush.channels.update_channel(parameters, function(channel)
        utils.to_log("Update channel:", channel)
    end)
end

local function delete_channel()
    local parameters = { channelId = channel_id }
    gamepush.channels.delete_channel(parameters, function(channel)
        utils.to_log("Delete channel:", channel)
    end)
end

local function fetch_channel()
    local parameters = { channelId = 66 }
    gamepush.channels.fetch_channel(parameters, function(channel)
        utils.to_log("Fetch channel:", channel)
    end)
end

local function fetch_channels()
    local parameters = {}
    gamepush.channels.fetch_channels(parameters, function(channel)
        utils.to_log("Fetch channel:", channel)
    end)
end

local function fetch_more_channels()
    local parameters = {}
    gamepush.channels.fetch_more_channels(parameters, function(channel)
        utils.to_log("Fetch channel:", channel)
    end)
end

local function join()
    local parameters = { channelId = 66 }
    gamepush.channels.join(parameters, function(result)
        utils.to_log("Join:", result)
    end)
end

local function cancel_join()
    local parameters = { channelId = 66 }
    gamepush.channels.cancel_join(parameters, function(result)
        utils.to_log("Cancel join:", result)
    end)
end

local function leave()
    local parameters = { channelId = 66 }
    gamepush.channels.leave(parameters, function(result)
        utils.to_log("Leave:", result)
    end)
end

local function kick()
    local parameters = { channelId = 66, playerId = 65679923 }
    gamepush.channels.kick(parameters, function(result)
        utils.to_log("kick:", result)
    end)
end

local function fetch_members()
    local parameters = { channelId = 66 }
    gamepush.channels.fetch_members(parameters, function(result)
        utils.to_log("Fetch members:", result)
    end)
end

local function fetch_more_members()
    local parameters = { channelId = 66 }
    gamepush.channels.fetch_more_members(parameters, function(result)
        utils.to_log("Fetch more members:", result)
    end)
end

local function mute()
    local parameters = { channelId = 66, playerId = 65679923, seconds = 120 }
    gamepush.channels.mute(parameters, function(result)
        utils.to_log("Mute:", result)
    end)
end

local function unmute()
    local parameters = { channelId = 66, playerId = 65679923, seconds = 120 }
    gamepush.channels.unmute(parameters, function(result)
        utils.to_log("Unmute:", result)
    end)
end

local function send_invite()
    local parameters = { channelId = 66, playerId = 78420397 }
    gamepush.channels.send_invite(parameters, function(result)
        utils.to_log("Send invite:", result)
    end)
end

local function cancel_invite()
    local parameters = { channelId = 66, playerId = 78420397 }
    gamepush.channels.cancel_invite(parameters, function(result)
        utils.to_log("Cancel invite:", result)
    end)
end

local function accept_invite()
    local parameters = { channelId = 66 }
    gamepush.channels.accept_invite(parameters, function(result)
        utils.to_log("Accept invite:", result)
    end)
end

local function reject_invite()
    local parameters = { channelId = 66, playerId = 78420397 }
    gamepush.channels.reject_invite(parameters, function(result)
        utils.to_log("Reject invite:", result)
    end)
end

local function fetch_invites()
    local parameters = { limit = 100 }
    gamepush.channels.fetch_invites(parameters, function(result)
        utils.to_log("Fetch invites:", result)
    end)
end

local function fetch_more_invites()
    local parameters = { limit = 100 }
    gamepush.channels.fetch_more_invites(parameters, function(result)
        utils.to_log("Fetch more invites:", result)
    end)
end

local function fetch_channel_invites()
    local parameters = { channelId = 66 }
    gamepush.channels.fetch_channel_invites(parameters, function(result)
        utils.to_log("Fetch channel invites:", result)
    end)
end

local function fetch_more_channel_invites()
    local parameters = { channelId = 66 }
    gamepush.channels.fetch_more_channel_invites(parameters, function(result)
        utils.to_log("Fetch more channel invites:", result)
    end)
end

local function fetch_sent_invites()
    local parameters = { limit = 100 }
    gamepush.channels.fetch_sent_invites(parameters, function(result)
        utils.to_log("Fetch sent invites:", result)
    end)
end

local function fetch_more_sent_invites()
    local parameters = { limit = 100 }
    gamepush.channels.fetch_more_sent_invites(parameters, function(result)
        utils.to_log("Fetch more sent invites:", result)
    end)
end

local M = {
    { name = "Create channel", callback = create_channel },
    { name = "Update channel", callback = update_channel },
    { name = "Delete channel", callback = delete_channel },
    { name = "Fetch channel", callback = fetch_channel },
    { name = "Fetch channels", callback = fetch_channels },
    { name = "Fetch more channels", callback = fetch_more_channels },
    { name = "Join", callback = join },
    { name = "Cancel join", callback = cancel_join },
    { name = "Leave", callback = leave },
    { name = "Kick", callback = kick },
    { name = "Fetch members", callback = fetch_members },
    { name = "Fetch more members", callback = fetch_more_members },
    { name = "Mute", callback = mute },
    { name = "Unmute", callback = unmute },
    { name = "Send invite", callback = send_invite },
    { name = "Cancel invite", callback = cancel_invite },
    { name = "Accept invite", callback = accept_invite },
    { name = "Reject invite", callback = reject_invite },
    { name = "Fetch invites", callback = fetch_invites },
    { name = "Fetch more invites", callback = fetch_more_invites },
    { name = "Fetch channel invites", callback = fetch_channel_invites },
    { name = "Fetch more channel invites", callback = fetch_more_channel_invites },
    { name = "Fetch sent invites", callback = fetch_sent_invites },
    { name = "Fetch more sent invites", callback = fetch_more_sent_invites },
}

gamepush.channels.callbacks.create_channel = function(channel)
    utils.to_console("Create channel:", channel)
end
gamepush.channels.callbacks.error_create_channel = function(error)
    utils.to_console("Error create channel:", error)
end
gamepush.channels.callbacks.update_channel = function(channel)
    utils.to_console("Update channel:", channel)
end
gamepush.channels.callbacks.error_update_channel = function(error)
    utils.to_console("Error update channel:", error)
end
gamepush.channels.callbacks.event_update_channel = function(channel)
    utils.to_console("Event update channel:", channel)
end
gamepush.channels.callbacks.delete_channel = function()
    utils.to_console("Delete channel")
end
gamepush.channels.callbacks.error_delete_channel = function(error)
    utils.to_console("Error delete channel:", error)
end
gamepush.channels.callbacks.event_delete_channel = function(channel)
    utils.to_console("Event delete channel:", channel)
end
gamepush.channels.callbacks.fetch_channel = function(channel)
    utils.to_console("Fetch channel:", channel)
end
gamepush.channels.callbacks.error_fetch_channel = function(error)
    utils.to_console("Error fetch channel:", error)
end
gamepush.channels.callbacks.fetch_channels = function(channel)
    utils.to_console("Fetch channels:", channel)
end
gamepush.channels.callbacks.error_fetch_channels = function(error)
    utils.to_console("Error fetch channels:", error)
end
gamepush.channels.callbacks.fetch_more_channels = function(channel)
    utils.to_console("Fetch more channels:", channel)
end
gamepush.channels.callbacks.error_fetch_more_channels = function(error)
    utils.to_console("Error fetch more channels:", error)
end

gamepush.channels.callbacks.join = function(result)
    utils.to_console("Join:", result)
end
gamepush.channels.callbacks.error_join = function(error)
    utils.to_console("Error join:", error)
end
gamepush.channels.callbacks.event_join = function(member)
    utils.to_console("Event join:", member)
end
gamepush.channels.callbacks.event_join_request = function(request)
    utils.to_console("Event join request:", request)
end
gamepush.channels.callbacks.cancel_join = function(result)
    utils.to_console("Cancel join:", result)
end
gamepush.channels.callbacks.error_cancel_join = function(error)
    utils.to_console("Error cancel join:", error)
end
gamepush.channels.callbacks.event_cancel_join = function(result)
    utils.to_console("Event cancel join:", result)
end
gamepush.channels.callbacks.leave = function(result)
    utils.to_console("Leave:", result)
end
gamepush.channels.callbacks.error_leave = function(error)
    utils.to_console("Error leave:", error)
end
gamepush.channels.callbacks.event_leave = function(result)
    utils.to_console("Event leave:", result)
end
gamepush.channels.callbacks.kick = function(result)
    utils.to_console("Kick:", result)
end
gamepush.channels.callbacks.error_kick = function(error)
    utils.to_console("Error kick:", error)
end
gamepush.channels.callbacks.fetch_members = function(result)
    utils.to_console("Fetch members:", result)
end
gamepush.channels.callbacks.error_fetch_members = function(error)
    utils.to_console("Error fetch members:", error)
end
gamepush.channels.callbacks.fetch_more_members = function(result)
    utils.to_console("Fetch more members:", result)
end
gamepush.channels.callbacks.error_fetch_more_members = function(error)
    utils.to_console("Error fetch more members:", error)
end
gamepush.channels.callbacks.mute = function(result)
    utils.to_console("Mute:", result)
end
gamepush.channels.callbacks.error_mute = function(error)
    utils.to_console("Error mute:", error)
end
gamepush.channels.callbacks.event_mute = function(result)
    utils.to_console("Event mute:", result)
end
gamepush.channels.callbacks.unmute = function(result)
    utils.to_console("Unmute:", result)
end
gamepush.channels.callbacks.error_unmute = function(error)
    utils.to_console("Error unmute:", error)
end
gamepush.channels.callbacks.event_unmute = function(result)
    utils.to_console("Event unmute:", result)
end

gamepush.channels.callbacks.send_invite = function(result)
    utils.to_console("Send invite:", result)
end
gamepush.channels.callbacks.error_send_invite = function(error)
    utils.to_console("Error send invite:", error)
end
gamepush.channels.callbacks.event_invite = function(result)
    utils.to_console("Event invite:", result)
end
gamepush.channels.callbacks.cancel_invite = function(result)
    utils.to_console("Cancel invite:", result)
end
gamepush.channels.callbacks.error_cancel_invite = function(error)
    utils.to_console("Error cancel invite:", error)
end
gamepush.channels.callbacks.event_cancel_invite = function(result)
    utils.to_console("Event cancel invite:", result)
end
gamepush.channels.callbacks.accept_invite = function(result)
    utils.to_console("Accept invite:", result)
end
gamepush.channels.callbacks.error_accept_invite = function(error)
    utils.to_console("Error accept invite:", error)
end
gamepush.channels.callbacks.reject_invite = function(result)
    utils.to_console("Reject invite:", result)
end
gamepush.channels.callbacks.error_reject_invite = function(error)
    utils.to_console("Error reject invite:", error)
end
gamepush.channels.callbacks.event_reject_invite = function(result)
    utils.to_console("Event cancel invite:", result)
end
gamepush.channels.callbacks.fetch_invites = function(result)
    utils.to_console("Fetch invites:", result)
end
gamepush.channels.callbacks.error_fetch_invites = function(error)
    utils.to_console("Error fetch invites:", error)
end
gamepush.channels.callbacks.fetch_more_invites = function(result)
    utils.to_console("Fetch more invites:", result)
end
gamepush.channels.callbacks.error_fetch_more_invites = function(error)
    utils.to_console("Error fetch more invites:", error)
end
gamepush.channels.callbacks.fetch_channel_invites = function(result)
    utils.to_console("Fetch channel invites:", result)
end
gamepush.channels.callbacks.error_fetch_channel_invites = function(error)
    utils.to_console("Error fetch channel invites:", error)
end
gamepush.channels.callbacks.fetch_more_channel_invites = function(result)
    utils.to_console("Fetch more channel invites:", result)
end
gamepush.channels.callbacks.error_fetch_more_channel_invites = function(error)
    utils.to_console("Error fetch more channel invites:", error)
end
gamepush.channels.callbacks.fetch_sent_invites = function(result)
    utils.to_console("Fetch sent invites:", result)
end
gamepush.channels.callbacks.error_fetch_sent_invites = function(error)
    utils.to_console("Error fetch sent invites:", error)
end
gamepush.channels.callbacks.fetch_more_sent_invites = function(result)
    utils.to_console("Fetch more sent invites:", result)
end
gamepush.channels.callbacks.error_fetch_more_sent_invites = function(error)
    utils.to_console("Error fetch more sent invites:", error)
end

return M