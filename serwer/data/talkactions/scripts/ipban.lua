local ipBanDays = 7

function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    local resultId = db.storeQuery("SELECT `account_id`, `lastip` FROM `players` WHERE `name` = " .. db.escapeString(param))
    if resultId == false then
        -- Gracz o podanej nazwie nie został znaleziony w bazie danych.
        player:sendCancelMessage("Gracz o tej nazwie nie istnieje lub nie można go znaleźć.")
        return false
    end

    local targetIp = result.getDataLong(resultId, "lastip")
    result.free(resultId)

    local targetPlayer = Player(param)
    if targetPlayer then
        -- Jeśli gracz jest online, pobierz jego aktualne IP i rozłącz go.
        targetIp = targetPlayer:getIp()
        targetPlayer:remove()
    end

    if targetIp == 0 then
        -- Brak ważnego adresu IP do zbanowania.
        player:sendCancelMessage("Nie można pobrać adresu IP gracza.")
        return false
    end

    resultId = db.storeQuery("SELECT 1 FROM `ip_bans` WHERE `ip` = " .. targetIp)
    if resultId ~= false then
        result.free(resultId)
        -- Adres IP jest już zbanowany.
        player:sendCancelMessage("Ten adres IP jest już zbanowany.")
        return false
    end

    local timeNow = os.time()
    db.query("INSERT INTO `ip_bans` (`ip`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (" ..
             targetIp .. ", '', " .. timeNow .. ", " .. timeNow + (ipBanDays * 86400) .. ", " .. player:getGuid() .. ")")
    
    player:sendTextMessage(MESSAGE_INFO_DESCR, "Adres IP gracza '" .. param .. "' (" .. Game.convertIpToString(targetIp) .. ") został zbanowany na " .. ipBanDays .. " dni.")
    
    return false
end