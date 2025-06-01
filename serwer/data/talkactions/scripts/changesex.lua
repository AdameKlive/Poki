local premiumDaysCost = 3

function onSay(player, words, param)
    if player:getGroup():getAccess() then
        player:setSex(player:getSex() == PLAYERSEX_FEMALE and PLAYERSEX_MALE or PLAYERSEX_FEMALE)
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Zmieniłeś swoją płeć.")
        return false
    end

    if player:getPremiumDays() >= premiumDaysCost then
        player:removePremiumDays(premiumDaysCost)
        player:setSex(player:getSex() == PLAYERSEX_FEMALE and PLAYERSEX_MALE or PLAYERSEX_FEMALE)
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Zmieniłeś swoją płeć za " .. premiumDaysCost .. " dni konta premium.")
    else
        player:sendCancelMessage("Nie masz wystarczającej liczby dni premium. Zmiana płci kosztuje " .. premiumDaysCost .. " dni konta premium.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
    end
    return false
end