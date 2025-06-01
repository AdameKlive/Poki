function onSay(player, words, param)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Informacje o serwerze:"
                    .. "\nMnożnik doświadczenia: " .. Game.getExperienceStage(player:getLevel())
                    .. "\nMnożnik umiejętności: " .. configManager.getNumber(configKeys.RATE_SKILL)
                    .. "\nMnożnik magii: " .. configManager.getNumber(configKeys.RATE_MAGIC)
                    .. "\nMnożnik łupu: " .. configManager.getNumber(configKeys.RATE_LOOT))
    return false
end