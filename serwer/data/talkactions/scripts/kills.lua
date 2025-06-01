function onSay(player, words, param)
    local fragTime = configManager.getNumber(configKeys.FRAG_TIME)
    if fragTime <= 0 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Nie masz żadnych nieuzasadnionych zabójstw.")
        return false
    end

    local skullTime = player:getSkullTime()
    if skullTime <= 0 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Nie masz żadnych nieuzasadnionych zabójstw.")
        return false
    end

    local kills = math.ceil(skullTime / fragTime)
    local remainingSeconds = math.floor((skullTime % fragTime) / 1000)

    local hours = math.floor(remainingSeconds / 3600)
    local minutes = math.floor((remainingSeconds % 3600) / 60)
    local seconds = remainingSeconds % 60

    local message = "Masz " .. kills .. " nieuzasadnione zabójstwo" .. (kills > 1 and "a" or "") .. ". Liczba nieuzasadnionych zabójstw zmniejszy się za: "
    if hours ~= 0 then
        if hours == 1 then
            message = message .. hours .. " godzinę, "
        else
            message = message .. hours .. " godziny, "
        end
    end

    if hours ~= 0 or minutes ~= 0 then
        if minutes == 1 then
            message = message .. minutes .. " minutę i "
        else
            message = message .. minutes .. " minuty i "
        end
    end

    if seconds == 1 then
        message = message .. seconds .. " sekundę."
    else
        message = message .. seconds .. " sekund."
    end

    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, message)
    return false
end