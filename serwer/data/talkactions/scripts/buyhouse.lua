function onSay(player, words, param)
    local housePrice = configManager.getNumber(configKeys.HOUSE_PRICE)
    if housePrice == -1 then
        return true
    end

    if not player:isPremium() then
        player:sendCancelMessage("Potrzebujesz konta premium.")
        return false
    end

    local position = player:getPosition()
    position:getNextPosition(player:getDirection())

    local tile = Tile(position)
    local house = tile and tile:getHouse()
    if house == nil then
        player:sendCancelMessage("Musisz patrzeć na drzwi domu, który chcesz kupić.")
        return false
    end

    if house:getOwnerGuid() > 0 then
        player:sendCancelMessage("Ten dom ma już właściciela.")
        return false
    end

    if player:getHouse() then
        player:sendCancelMessage("Jesteś już właścicielem domu.")
        return false
    end

    local price = house:getTileCount() * housePrice
    if not player:removeMoney(price) then
        player:sendCancelMessage("Nie masz wystarczająco pieniędzy.")
        return false
    end

    house:setOwnerGuid(player:getGuid())
    player:sendTextMessage(MESSAGE_INFO_DESCR, "Pomyślnie kupiłeś ten dom. Upewnij się, że masz pieniądze na czynsz w banku.")
    return false
end