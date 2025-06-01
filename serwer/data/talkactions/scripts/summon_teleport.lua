local delay = 10*60 -- Opóźnienie w sekundach (10 minut)
local availableCities = 59 -- Liczba dostępnych miast

function onSay(player, words, param)
    -- Jeśli nie podano parametru, wyświetla listę dostępnych miast
    if param == "" then
        local msg = "Dostępne miasta: \n\n"
        for i = 1, availableCities do
            local town = Town(i)
            if town then
                msg = msg .. town:getName() .. "\n"
            end
        end
        player:showTextDialog(2263, msg)
        return false
    end

    -- Sprawdza, czy gracz nie jest objęty blokadą PZ (Protection Zone)
    if player:isPzLocked() then
        player:sendCancelMessage("Przepraszamy, to niemożliwe w strefie ochronnej PZ.")
        return false        
    end

    -- Sprawdza czas od ostatniej teleportacji
    local timeSinceLast = os.time() - player:getStorageValue(storageDelayTeleport)
    if timeSinceLast < delay then
        player:sendCancelMessage("Przepraszamy, to niemożliwe. Musisz odczekać " .. delay - timeSinceLast .. " sekund, aby ponownie się teleportować.")
        return false        
    end

    -- Sprawdza, czy gracz ma przywołanego Pokemona
    if not hasSummons(player) then
        player:sendCancelMessage("Przepraszamy, to niemożliwe. Potrzebujesz Pokemona, aby użyć teleportacji.")
        return false
    end

    -- Sprawdza, czy przywołany Pokemon może teleportować
    local summon = player:getSummon()
    local summonName = summon:getName()
    local monsterType = MonsterType(summonName)
    if monsterType:canTeleport() == 0 then
        player:sendCancelMessage("Przepraszamy, to niemożliwe. Twój Pokemon nie może teleportować.")
        return false        
    end

    -- Próbuje znaleźć miasto po nazwie lub ID
    local town = Town(param)
    if town == nil then
        town = Town(tonumber(param))
    end

    -- Jeśli miasto nie zostało znalezione
    if town == nil then
        player:sendCancelMessage("Miasto nie znaleziono.")
        return false
    end

    -- Sprawdza, czy miasto jest dostępne (w zakresie availableCities)
    if town:getId() > availableCities then
        player:sendCancelMessage("Przepraszamy, miasto niedostępne.")
        return false
    end

    -- Dodatkowe sprawdzenie dla miast powyżej ID 49 (wymaga ukończenia konkretnego questa)
    if town:getId() > 49 then
        if player:getStorageValue(quests.cathemAll.prizes[1].uid) < 2 then
            player:sendCancelMessage("Przepraszamy, to niemożliwe. Musisz ukończyć zadanie 'catch'em all' przed teleportacją do tego miasta.")
            return false
        end
    end

    -- Wyłącza tryb nurkowania, jeśli jest aktywny
    if player:isOnDive() then
        player:setStorageValue(storageDive, -1)
        player:removeCondition(CONDITION_OUTFIT)
    end

    -- Kończy pojedynek z NPC, jeśli jest aktywny
    if player:isDuelingWithNpc() then
        player:unsetDuelWithNpc()
    end

    -- Wykonuje teleportację
    player:say(summonName .. ", zabierz mnie do " .. town:getName() .. "!", TALKTYPE_SAY)
    player:teleportTo(town:getTemplePosition())
    player:setStorageValue(storageDelayTeleport, os.time())
    return false
end