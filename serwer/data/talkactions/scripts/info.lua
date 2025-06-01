function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    local target = Player(param)
    if not target then
        player:sendCancelMessage("Gracz nie znaleziony.")
        return false
    end

    if target:getAccountType() > player:getAccountType() then
        player:sendCancelMessage("Nie możesz uzyskać informacji o tym graczu.")
        return false
    end

    local targetIp = target:getIp()
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Nazwa: " .. target:getName())
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Dostęp: " .. (target:getGroup():getAccess() and "1" or "0"))
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Poziom: " .. target:getLevel())
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Poziom Magii: " .. target:getMagicLevel())
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Prędkość: " .. target:getSpeed())
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Pozycja: " .. string.format("(%0.5d / %0.5d / %0.3d)", target:getPosition().x, target:getPosition().y, target:getPosition().z))
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "IP: " .. Game.convertIpToString(targetIp))

    local players = {}
    for _, targetPlayer in ipairs(Game.getPlayers()) do
        if targetPlayer:getIp() == targetIp and targetPlayer ~= target then
            players[#players + 1] = targetPlayer:getName() .. " [" .. targetPlayer:getLevel() .. "]"
        end
    end

    if #players > 0 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Inni gracze na tym samym IP: " .. table.concat(players, ", ") .. ".")
    end
    return false
end