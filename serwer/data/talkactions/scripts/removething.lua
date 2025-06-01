function onSay(player, words, param)
    -- Sprawdza, czy gracz ma odpowiednie uprawnienia dostępu.
    if not player:getGroup():getAccess() then
        return true
    end

    local position = player:getPosition()
    position:getNextPosition(player:getDirection()) -- Przesuwa pozycję na pole przed graczem.

    local tile = Tile(position)
    -- Sprawdza, czy pole istnieje.
    if not tile then
        player:sendCancelMessage("Obiekt nie znaleziono.")
        return false
    end

    local thing = tile:getTopVisibleThing(player)
    -- Sprawdza, czy na polu znajduje się widoczny obiekt.
    if not thing then
        player:sendCancelMessage("Rzeczy nie znaleziono.")
        return false
    end

    -- Jeśli obiekt jest istotą (np. potworem, NPC, innym graczem), usuwa go.
    if thing:isCreature() then
        thing:remove()
    -- Jeśli obiekt jest przedmiotem.
    elseif thing:isItem() then
        -- Zapobiega usunięciu kafelka ziemi.
        if thing == tile:getGround() then
            player:sendCancelMessage("Nie możesz usunąć kafelka ziemi.")
            return false
        end
        -- Usuwa przedmiot. Jeśli 'param' jest liczbą, usuwa określoną ilość, w przeciwnym razie usuwa wszystko (-1).
        thing:remove(tonumber(param) or -1)
    end

    -- Wysyła efekt magiczny na pozycji, aby wizualnie potwierdzić działanie komendy.
    position:sendMagicEffect(CONST_ME_MAGIC_RED)
    return false
end