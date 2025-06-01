local config = {
    days = 30,
    maxDays = 45,
    price = 200000
}

function onSay(player, words, param)
    if configManager.getBoolean(configKeys.FREE_PREMIUM) then
        return true
    end

    if player:getPremiumDays() + config.days <= config.maxDays then
        if player:removeMoney(config.price) then
            player:addPremiumDays(config.days)
            player:sendTextMessage(MESSAGE_INFO_DESCR, "Kupiłeś " .. config.days .." dni konta premium.")
        else
            player:sendCancelMessage("Nie masz wystarczająco pieniędzy. " .. config.days .. " dni konta premium kosztuje " .. config.price .. " złotych monet.")
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
        end
    else
        player:sendCancelMessage("Nie możesz mieć więcej niż " .. config.maxDays .. " dni konta premium.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
    end
    return false
end