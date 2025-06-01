function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end

    local tile = Tile(player:getPosition())
    local house = tile and tile:getHouse()
    if house == nil then
        player:sendCancelMessage("Nie jesteś w domu.")
        return false
    end

    if param == "" or param == "none" then
        house:setOwnerGuid(0)
        return false
    end

    local targetPlayer = Player(param)
    if targetPlayer == nil then
        player:sendCancelMessage("Gracz nie znaleziony.")
        return false
    end

    house:setOwnerGuid(targetPlayer:getGuid())
    return false
end