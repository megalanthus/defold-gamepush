local M = {}

M["environment"] = {
    app = {
        id = "app_id"
    },
    browser = {
        lang = "ru"
    },
    i18n = {
        lang = "ru",
        tld = "ru"
    }
}
M["feedback.canReview"] = function()
    return { value = true }
end
M["lb=getLeaderboards"] = {}
M["lb:getLeaderboardEntries"] = {
    leaderboard = {
    },
    ranges = {
        start = 0,
        size = 10
    },
    userRank = 0,
    entries = {
        score = 100,
        rank = 1,
        player = {},
    }
}
return M