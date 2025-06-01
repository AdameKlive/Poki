local delay = 12*60*60

function onSay(player, words, param)
    local timeSinceLast = os.time() - player:getStorageValue(storageDelayDesbugar)
    if timeSinceLast < delay then
        player:sendCancelMessage("Musisz odczekać " .. delay - timeSinceLast .. " sekund, aby ponownie 'odbugować' swoją postać.")
        return false        
    end

    if player:isOnDive() then
        player:setStorageValue(storageDive, -1)
        player:removeCondition(CONDITION_OUTFIT)
    end

    if player:isDuelingWithNpc() then
        player:unsetDuelWithNpc()
    end

    player:teleportTo(player:getTown():getTemplePosition())
    player:setStorageValue(storageDelayDesbugar, os.time())

    return false
end