function onSay(player, words, param)
    local uptime = getWorldUpTime()

    local hours = math.floor(uptime / 3600)
    local minutes = math.floor((uptime - (3600 * hours)) / 60)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Czas działania: " .. hours .. " godzin i " .. minutes .. " minut.")
    return false
end