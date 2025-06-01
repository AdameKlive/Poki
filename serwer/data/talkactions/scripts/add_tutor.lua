function onSay(player, words, param)
    if player:getAccountType() <= ACCOUNT_TYPE_TUTOR then
        return true
    end

    local target = Player(param)
    if target == nil then
        player:sendCancelMessage("Gracz o tej nazwie nie jest online.")
        return false
    end

    if target:getAccountType() ~= ACCOUNT_TYPE_NORMAL then
        player:sendCancelMessage("Możesz awansować na tutora tylko zwykłego gracza.")
        return false
    end

    target:setAccountType(ACCOUNT_TYPE_TUTOR)
    target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Zostałeś awansowany na tutora przez " .. player:getName() .. ".")
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Awansowałeś " .. target:getName() .. " na tutora.")
    return false
end