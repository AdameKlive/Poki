function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end

    local itemCount = cleanMap()
    if itemCount > 0 then
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "Usunięto " .. itemCount .. " przedmiot" .. (itemCount > 1 and "ów" or "") .. " z mapy.")
    end
    return false
end