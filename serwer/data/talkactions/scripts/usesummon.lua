function onSay(player, words, param)
    -- Jeśli przywoływanie jest zablokowane, przerywamy działanie.
    if player:isSummonBlocked() then return false end

    local index = tonumber(param)
    -- Jeśli indeks nie jest liczbą, przerywamy.
    if not index then return false end

    local pokeballs = player:getPokeballs() -- Pobiera listę pokeballi gracza.
    local ball = pokeballs[index] -- Pobiera pokeball o danym indeksie.
    -- local ball = player:getSpecialStorage("pokes")[index] -- Zakomentowana alternatywna linia.

    -- Jeśli wybrany pokeball nie istnieje, wyświetla ostrzeżenie i odświeża pasek.
    if not ball then
        print("OSTRZEŻENIE! Gracz " .. player:getName() .. " miał problemy podczas próby użycia paska pokeballi: nie znaleziono wybranego pokeballa.")
        player:refreshPokemonBar({}, {})
        return false
    end

    -- Sprawdza, czy gracz może wypuścić Pokemona (na podstawie jego poziomu, wzmocnienia i właściciela).
    if player:canReleaseSummon(ball:getSummonLevel(), ball:getSummonBoost(), ball:getSummonOwner()) then
        -- Jeśli gracz ma już przywołanego Pokemona.
        if hasSummons(player) then
            local usingBall = player:getUsingBall() -- Pobiera pokeball aktualnie używany do przywołania.
            -- Jeśli nie można znaleźć używanego pokeballa, wyświetla ostrzeżenie.
            if not usingBall then
                print("OSTRZEŻENIE! Gracz " .. player:getName() .. " miał problemy podczas próby użycia paska pokeballi: doRemoveSummon.")
                player:refreshPokemonBar({}, {})
                return false
            end
            local usingBallKey = getBallKey(usingBall:getId()) -- Pobiera klucz używanego pokeballa.
            -- Usuwa obecnego Pokemona.
            doRemoveSummon(player:getId(), balls[usingBallKey].effectRelease, false, true, balls[usingBallKey].missile)
            usingBall:transform(balls[usingBallKey].usedOn) -- Zmienia wygląd używanego pokeballa na "użyty".
        end

        local ballKey = getBallKey(ball:getId()) -- Pobiera klucz wybranego pokeballa.
        ball:transform(balls[ballKey].usedOff) -- Zmienia wygląd wybranego pokeballa na "nieużywany".
        ball:setSpecialAttribute("isBeingUsed", 1) -- Ustawia specjalny atrybut, wskazujący, że jest używany.
        -- Wypuszcza nowego Pokemona.
        doReleaseSummon(player:getId(), player:getPosition(), balls[ballKey].effectRelease, true, balls[ballKey].missile)
    end

    return false
end