function onSay(player, words, param)
    -- Sprawdzamy, czy gracz ma odpowiedni typ konta (wyższy niż TUTOR).
    -- Jeśli nie, przerywamy działanie skryptu.
    if player:getAccountType() <= ACCOUNT_TYPE_TUTOR then
        return true
    end

    -- Wyszukujemy gracza w bazie danych na podstawie podanej nazwy.
    local resultId = db.storeQuery("SELECT `name`, `account_id`, (SELECT `type` FROM `accounts` WHERE `accounts`.`id` = `account_id`) AS `account_type` FROM `players` WHERE `name` = " .. db.escapeString(param))
    
    -- Jeśli gracz nie został znaleziony w bazie danych, wysyłamy komunikat błędu.
    if resultId == false then
        player:sendCancelMessage("Gracz o tej nazwie nie istnieje.")
        return false
    end

    -- Sprawdzamy, czy znaleziony gracz ma typ konta TUTOR.
    -- Jeśli nie, wysyłamy komunikat, że można zdegradować tylko tutorów.
    if result.getDataInt(resultId, "account_type") ~= ACCOUNT_TYPE_TUTOR then
        player:sendCancelMessage("Możesz zdegradować tylko tutora do zwykłego gracza.")
        return false
    end

    -- Próbujemy utworzyć obiekt gracza, jeśli jest online.
    local target = Player(param)
    if target ~= nil then
        -- Jeśli gracz jest online, zmieniamy typ jego konta bezpośrednio.
        target:setAccountType(ACCOUNT_TYPE_NORMAL)
    else
        -- Jeśli gracz jest offline, aktualizujemy typ konta w bazie danych.
        db.query("UPDATE `accounts` SET `type` = " .. ACCOUNT_TYPE_NORMAL .. " WHERE `id` = " .. result.getDataInt(resultId, "account_id"))
    end

    -- Wysyłamy wiadomość do gracza używającego komendy, informując o sukcesie degradacji.
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Zdegradowałeś " .. result.getDataString(resultId, "name") .. " do statusu zwykłego gracza.")
    
    -- Zwalniamy zasoby zapytania do bazy danych.
    result.free(resultId)
    return false
end