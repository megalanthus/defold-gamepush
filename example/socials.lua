local gamepush = require("gamepush.gamepush")
local utils = require("example.utils")

local function is_supports_share()
    utils.to_log(gamepush.socials.is_supports_share())
end

local function is_supports_native_share()
    utils.to_log(gamepush.socials.is_supports_native_share())
end

local function share()
    utils.to_log("Socials share")
    gamepush.socials.share()
end

local function share_param()
    local parameters = {
        text = "I have a new achievement!",
        image = "https://gamepush.com/img/ogimage.png",
        url = "https://gamepush.com"
    }
    utils.to_log("Socials share:", parameters)
    gamepush.socials.share(parameters)
end

local function is_supports_native_posts()
    utils.to_log(gamepush.socials.is_supports_native_posts())
end

local function post()
    utils.to_log("Socials post")
    gamepush.socials.post()
end

local function post_param()
    local parameters = {
        text = "I have a new achievement!",
        image = "https://gamepush.com/img/ogimage.png",
        url = "https://gamepush.com"
    }
    utils.to_log("Socials post:", parameters)
    gamepush.socials.post(parameters)
end

local function is_supports_native_invite()
    utils.to_log(gamepush.socials.is_supports_native_invite())
end

local function invite()
    utils.to_log("Socials invite")
    gamepush.socials.invite()
end

local function invite_param()
    local parameters = {
        text = "I invite you to gamepush!",
    }
    utils.to_log("Socials invite:", parameters)
    gamepush.socials.invite(parameters)
end

local function can_join_community()
    utils.to_log(gamepush.socials.can_join_community())
end

local function is_supports_native_community_join()
    utils.to_log(gamepush.socials.is_supports_native_community_join())
end

local function join()
    utils.to_log("Socials join community")
    gamepush.socials.join_community()
end

local function make_share_url()
    local url = gamepush.socials.make_share_url({ from = "player", gift = "gold", count = 100 })
    utils.to_log(url)
    pprint(url)
end

local function get_share_param()
    local from = gamepush.socials.get_share_param("from")
    local gift = gamepush.socials.get_share_param("gift")
    local count = gamepush.socials.get_share_param("count")
    utils.to_log(string.format("from: '%s'\ngift: '%s'\ncount: '%s'", from, gift, count))
end

local M = {
    { name = "Is supports share", callback = is_supports_share },
    { name = "Is supports native share", callback = is_supports_native_share },
    { name = "Share", callback = share },
    { name = "Share with param", callback = share_param },
    { name = "Is supports native posts", callback = is_supports_native_posts },
    { name = "Post", callback = post },
    { name = "Post with param", callback = post_param },
    { name = "Is supports native invite", callback = is_supports_native_invite },
    { name = "Invite", callback = invite },
    { name = "Invite with param", callback = invite_param },
    { name = "Can join community", callback = can_join_community },
    { name = "Is supports native community join", callback = is_supports_native_community_join },
    { name = "Join", callback = join },
    { name = "Make share url", callback = make_share_url },
    { name = "Get share parameter", callback = get_share_param },
}

return M