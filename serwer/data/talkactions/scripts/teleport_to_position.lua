function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    local split = param:split(",")

    if split[3] == nil then
        player:sendCancelMessage("Niewystarczające parametry.")
        return false
    end

    local position = Position(split[1], split[2], split[3])
--    position = player:getClosestFreePosition(position, false) -- Ta linia jest zakomentowana, więc nie jest używana

    if position.x == 0 then
        player:sendCancelMessage("Nie możesz się tam teleportować.")
        return false
    end

    player:teleportTo(position)
    return false
end