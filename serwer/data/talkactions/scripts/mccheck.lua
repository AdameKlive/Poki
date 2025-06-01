function onSay(player, words, param)
    -- Sprawdza, czy gracz ma odpowiednie uprawnienia dostępu
    if not player:getGroup():getAccess() then
        return true
    end

    -- Sprawdza, czy typ konta gracza jest niższy niż GAMEMASTER, jeśli tak, blokuje wykonanie
    if player:getAccountType() < ACCOUNT_TYPE_GOD then
        return false
    end

    -- Wysyła wiadomość do gracza, informując o rozpoczęciu sprawdzania
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Lista sprawdzania multiclient:")

    local ipList = {} -- Tworzy pustą tabelę do przechowywania graczy pogrupowanych według IP
    local players = Game.getPlayers() -- Pobiera wszystkich graczy online

    -- Iteruje przez wszystkich graczy online
    for i = 1, #players do
        local tmpPlayer = players[i] -- Pobiera bieżącego gracza
        local ip = tmpPlayer:getIp() -- Pobiera adres IP gracza
        if ip ~= 0 then -- Sprawdza, czy adres IP jest prawidłowy (nie jest zerowy)
            local list = ipList[ip] -- Próbuje pobrać listę graczy dla danego IP
            if not list then -- Jeśli lista dla tego IP nie istnieje
                ipList[ip] = {} -- Tworzy nową listę dla tego IP
                list = ipList[ip] -- Przypisuje nowo utworzoną listę
            end
            list[#list + 1] = tmpPlayer -- Dodaje bieżącego gracza do listy pod danym IP
        end
    end

    -- Iteruje przez zebrane adresy IP i listy graczy
    for ip, list in pairs(ipList) do
        local listLength = #list -- Pobiera liczbę graczy na danym IP
        if listLength > 1 then -- Jeśli na danym IP jest więcej niż jeden gracz
            local tmpPlayer = list[1] -- Pobiera pierwszego gracza z listy
            -- Formatuje początkową wiadomość z adresem IP, nazwą i poziomem pierwszego gracza
            local message = ("%s: %s [%d]"):format(Game.convertIpToString(ip), tmpPlayer:getName(), tmpPlayer:getLevel())
            -- Dodaje pozostałych graczy do wiadomości
            for i = 2, listLength do
                tmpPlayer = list[i]
                message = ("%s, %s [%d]"):format(message, tmpPlayer:getName(), tmpPlayer:getLevel())
            end
            -- Wysyła sformatowaną wiadomość do gracza, który użył komendy
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, message .. ".")
        end
    end
    return false -- Zwraca false, wskazując, że komenda została przetworzona
end