function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    local target = Player(param)

    if player:getAccountType() > ACCOUNT_TYPE_GAMEMASTER then
        target = Creature(param)
    end
    if target == nil then
        player:sendCancelMessage("Gracz nie znaleziony.")
        return false
    end

    player:teleportTo(target:getPosition())
    return false
end