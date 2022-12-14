local M = {}
local core = require("gamepush.core.core")
local helpers = require("gamepush.core.helpers")
local callbacks = require("gamepush.core.callbacks")

---Проверка включенного AdBlock
---@return boolean
function M.is_adblock_enabled()
    return core.call_api("ads.isAdblockEnabled").value == true
end

---Проверка доступности баннера
---@return boolean
function M.is_sticky_available()
    return core.call_api("ads.isStickyAvailable").value == true
end

---Проверка доступности полноэкранной рекламы
---@return boolean
function M.is_fullscreen_available()
    return core.call_api("ads.isFullscreenAvailable").value == true
end

---Проверка доступности рекламы за вознаграждение
---@return boolean
function M.is_rewarded_available()
    return core.call_api("ads.isRewardedAvailable").value == true
end

---Проверка доступности preload рекламы
---@return boolean
function M.is_preloader_available()
    return core.call_api("ads.isPreloaderAvailable").value == true
end

---Проверка воспроизведения баннера
---@return boolean
function M.is_sticky_playing()
    return core.call_api("ads.isStickyPlaying").value == true
end

---Проверка воспроизведения полноэкранной рекламы
---@return boolean
function M.is_fullscreen_playing()
    return core.call_api("ads.isFullscreenPlaying").value == true
end

---Проверка воспроизведения рекламы за вознаграждение
---@return boolean
function M.is_rewarded_playing()
    return core.call_api("ads.isRewardedPlaying").value == true
end

---Проверка воспроизведения preload рекламы
---@return boolean
function M.is_preloader_playing()
    return core.call_api("ads.isPreloaderPlaying").value == true
end

---Показать полноэкранную рекламу
---@param callback function функция обратного вызова по завершению рекламы: callback(result)
function M.show_fullscreen(callback)
    helpers.check_callback(callback)
    core.call_api("ads.showFullscreen", nil, callback)
end

---Показать баннерную рекламу (preloader)
---@param callback function функция обратного вызова по завершению рекламы: callback(result)
function M.show_preloader(callback)
    helpers.check_callback(callback)
    core.call_api("ads.showPreloader", nil, callback)
end

---Показать рекламу за вознаграждение
---@param callback function функция обратного вызова по завершению рекламы: callback(result)
function M.show_rewarded_video(callback)
    helpers.check_callback(callback)
    core.call_api("ads.showRewardedVideo", nil, callback)
end

---Показать баннер
---@param callback function функция обратного вызова по результату показа: callback(result)
function M.show_sticky(callback)
    helpers.check_callback(callback)
    core.call_api("ads.showSticky", nil, callback)
end

---Обновить баннер
---@param callback function функция обратного вызова по результату обновления: callback(result)
function M.refresh_sticky(callback)
    helpers.check_callback(callback)
    core.call_api("ads.refreshSticky", nil, callback)
end

---Закрыть баннер
---@param callback function функция обратного вызова по результату закрытия: callback()
function M.close_sticky(callback)
    helpers.check_callback(callback)
    core.call_api("ads.closeSticky", nil, callback)
end

M.callbacks = callbacks.ads

return M