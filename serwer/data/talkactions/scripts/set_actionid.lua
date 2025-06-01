function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    local position = player:getPosition()
    position:getNextPosition(player:getDirection())

    local tile = Tile(position)
    if not tile then
        player:sendCancelMessage("Obiekt nie znaleziony.")
        return false
    end

    local actionId = tonumber(param)
    if not actionId then
        player:sendCancelMessage("Nieprawidłowy parametr.")
        return false
    end

    local thing = tile:getTopVisibleThing(player)
    if not thing then
        player:sendCancelMessage("Element nie znaleziony.")
        return false
    end

    if thing:isCreature() then
        player:sendCancelMessage("Niemożliwe dla stworzeń.")
        return false
    elseif thing:isItem() then
        if thing == tile:getGround() then
            thing:setActionId(tonumber(actionId))
        end
        return false
    end

    position:sendMagicEffect(CONST_ME_MAGIC_RED)
    return false
end