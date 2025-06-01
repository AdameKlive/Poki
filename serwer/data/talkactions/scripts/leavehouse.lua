function onSay(player, words, param)
    local position = player:getPosition()
    local tile = Tile(position)
    local house = tile and tile:getHouse()
    if house == nil then
        player:sendCancelMessage("Nie jesteś w domu.")
        position:sendMagicEffect(CONST_ME_POFF)
        return false
    end

    if house:getOwnerGuid() ~= player:getGuid() then
        player:sendCancelMessage("Nie jesteś właścicielem tego domu.")
        position:sendMagicEffect(CONST_ME_POFF)
        return false
    end

    house:setOwnerGuid(0)
    player:sendTextMessage(MESSAGE_INFO_DESCR, "Pomyślnie opuściłeś swój dom.")
    position:sendMagicEffect(CONST_ME_POFF)
    return false
end