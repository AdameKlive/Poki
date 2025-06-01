function onSay(player, words, param)
    -- Sprawdza, czy gracz ma odpowiednie uprawnienia dostępu.
    if not player:getGroup():getAccess() then
        return true
    end

    -- Pobiera ID konta i ostatni adres IP gracza z bazy danych na podstawie podanej nazwy.
    local resultId = db.storeQuery("SELECT `account_id`, `lastip` FROM `players` WHERE `name` = " .. db.escapeString(param))
    if resultId == false then
        -- Jeśli gracz o podanej nazwie nie istnieje w bazie danych.
        player:sendCancelMessage("Gracz o tej nazwie nie istnieje lub nie można go znaleźć.")
        return false
    end

    -- Usuwa bany konta i IP asynchronicznie, aby nie blokować serwera.
    db.asyncQuery("DELETE FROM `account_bans` WHERE `account_id` = " .. result.getDataInt(resultId, "account_id"))
    db.asyncQuery("DELETE FROM `ip_bans` WHERE `ip` = " .. result.getDataInt(resultId, "lastip"))
    
    -- Zwalnia zasoby zapytania do bazy danych.
    result.free(resultId)
    
    -- Informuje gracza, który użył komendy, o pomyślnym odbanowaniu.
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, param .. " został odbanowany.")
    return false
end