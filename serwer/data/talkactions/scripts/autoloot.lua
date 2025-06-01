function onSay(player, words, param)
    if player:isAutoLooting() then
        player:disableAutoLoot()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Automatyczne zbieranie łupów wyłączone.")
    else
        player:enableAutoLoot()
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Automatyczne zbieranie łupów włączone.")
    end
    return false
end