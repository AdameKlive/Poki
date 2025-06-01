function onSay(player, words, param)
    -- Sprawdzamy, czy gracz ma odpowiednie uprawnienia dostępu.
    if not player:getGroup():getAccess() then
        return true
    end

    -- Próbujemy znaleźć gracza o podanej nazwie.
    local creature = Player(param)
    if not creature then
        player:sendCancelMessage("Nie znaleziono gracza o tej nazwie.")
        return false
    end

    local oldPosition = creature:getPosition()
    local newPosition = player:getPosition() -- Nowa pozycja to aktualna pozycja gracza używającego komendy.
    
    -- Sprawdzamy, czy nowa pozycja jest prawidłowa.
    if newPosition and newPosition.x == 0 then
        player:sendCancelMessage("Nie możesz teleportować " .. creature:getName() .. ".")
        return false
    -- Jeśli nowa pozycja jest prawidłowa i teleportacja się powiedzie.
    elseif newPosition and creature:teleportTo(newPosition) then
        -- Jeśli teleportowany gracz nie jest w trybie ducha (niewidzialny), odtwarzamy efekty magiczne.
        if not creature:isInGhostMode() then
            oldPosition:sendMagicEffect(CONST_ME_POFF)      -- Efekt zniknięcia w starej pozycji.
            newPosition:sendMagicEffect(CONST_ME_TELEPORT)   -- Efekt teleportacji w nowej pozycji.
        end
    end
    return false
end