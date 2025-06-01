local banDays = 7

function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    local name = param
    local reason = ''

    local separatorPos = param:find(',')
    if separatorPos ~= nil then
        name = param:sub(0, separatorPos - 1)
        reason = string.trim(param:sub(separatorPos + 1))
    end

    local accountId = getAccountNumberByPlayerName(name)
    if accountId == 0 then
        -- Jeśli gracz o podanej nazwie nie istnieje lub nie można znaleźć jego ID konta
        player:sendCancelMessage("Nie znaleziono gracza o tej nazwie lub nie jest dostępny.")
        return false
    end

    local resultId = db.storeQuery("SELECT 1 FROM `account_bans` WHERE `account_id` = " .. accountId)
    if resultId ~= false then
        result.free(resultId)
        -- Jeśli konto jest już zbanowane
        player:sendCancelMessage("To konto jest już zbanowane.")
        return false
    end

    local timeNow = os.time()
    db.query("INSERT INTO `account_bans` (`account_id`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (" ..
             accountId .. ", " .. db.escapeString(reason) .. ", " .. timeNow .. ", " .. timeNow + (banDays * 86400) .. ", " .. player:getGuid() .. ")")

    local target = Player(name)
    if target ~= nil then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, target:getName() .. " został zbanowany.")
        target:remove() -- Usuwa gracza z gry (rozłącza go)
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, name .. " został zbanowany.")
    end
    return false -- Zwracamy false, ponieważ polecenie zostało przetworzone
end