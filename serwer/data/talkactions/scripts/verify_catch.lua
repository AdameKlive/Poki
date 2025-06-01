local legendaryIndex = {144, 145, 146, 150, 151, 243, 244, 245, 249, 250, 251, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386}

function onSay(player, words, param)
    local catchRemainTable = {}
    for i = 1, 386 do
        -- Sprawdza, czy Pokemon o danym indeksie nie jest legendarny.
        if not isInArray(legendaryIndex, i) then 
            table.insert(catchRemainTable, i)
        end
    end
    
    -- Pobiera liczbę pozostałych do złapania Pokemonów dla gracza.
    local catchRemain = player:getCatchRemain(catchRemainTable)
    
    if catchRemain == 0 then
        -- Jeśli gracz złapał wszystkie Pokemony z Kanto (niebędące legendarnymi).
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Gratulacje, udało ci się złapać wszystkie Pokemony z Kanto.")
    else
        -- Informuje, ile Pokemonów jeszcze brakuje.
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Brakuje jeszcze " .. catchRemain .. " Pokemonów, aby złapać wszystkie Pokemony z Kanto.")
    end

    return false
end