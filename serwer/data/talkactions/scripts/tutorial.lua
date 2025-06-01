local tutorialOptions = {
    [1] = {title = 'POKEMONY', message = 'Aby przywołać swojego startowego Pokemona, wyjdź z centrum Pokemon, używając strzałek. Przenieś swoją pokebolę w odpowiednie miejsce (pod Pokedexem) i kliknij na nią prawym przyciskiem myszy.'},
    [2] = {title = 'ROZKAZYWANIE', message = 'Możesz przesuwać swojego potwora, klikając przycisk ORDER, znajdujący się obok Pokedexu, i wybierając cel. Twój potwór może poruszać się tylko o 1 kratkę naraz.'},
    [3] = {title = 'POKEDEX', message = 'Możesz użyć przycisku POKEDEX, znajdującego się obok przycisku ORDER, aby uzyskać informacje o Pokemonach. Twoja postać zdobywa doświadczenie za pierwsze użycie na każdym Pokemonie.'},
    [4] = {title = 'ŁAPANIE', message = 'Dzięki pustym pokebolom dostępnym w Twoim plecaku możesz łapać Pokemony, które zabijesz. Aby złapać, kliknij prawym przyciskiem myszy na pustą pokebolę i kliknij na ciało potwora, którego właśnie zabiłeś.'},
    [5] = {title = 'ODRADZANIE', message = 'Dzięki ożywiaczom (revives), również dostępnym w Twoim plecaku, możesz ożywiać swoje Pokemony. Aby ożywić swoje Pokemony, kliknij prawym przyciskiem myszy na ożywiaczu i kliknij na pokebolę potwora, którego chcesz ożywić.'},
    [6] = {title = 'ULTIMATE POTION', message = 'Użyj swoich Ultimate Potion, aby leczyć zarówno siebie, jak i swojego Pokemona podczas bitwy.'},
    [7] = {title = 'LECZENIE', message = 'Aby wyleczyć siebie i wszystkie swoje potwory za darmo, powiedz "hi", a następnie "heal" do NPC Healer.'},
    [8] = {title = 'TUTORIAL', message = 'Powodzenia w Twojej podróży! Aby ponownie uruchomić ten tutorial, wpisz !tutorial. Odwiedź PokeTibijka.pl by zobaczyć wszystkie zmiany! Deweloper: AdameK.'}
}

function doSendNextTutorial(cid, actualId)
    local player = Player(cid)
    if not player then return false end
    if actualId > #tutorialOptions then return false end

    local window = ModalWindow {title = tutorialOptions[actualId].title, message = tutorialOptions[actualId].message}
    window:addButton('Następny', (
        function(button, choice)
            doSendNextTutorial(player:getId(), actualId + 1)
        end
      )
    )

    window:setDefaultEnterButton('Następny')
    window:addButton('Zamknij')
    window:setDefaultEscapeButton('Zamknij')
    window:sendToPlayer(player)

end

function doSendTutorial(cid)
    local player = Player(cid)
    if not player then return false end
    
    local window = ModalWindow { title = 'Tutorial', message = 'Witaj w naszym tutorialu! Kliknij "Następny", aby nauczyć się grać.' }
    window:addButton('Następny', (
        function(button, choice)
            doSendNextTutorial(player:getId(), 1)
        end
      )
    )
    window:setDefaultEnterButton('Następny')
    window:addButton('Zamknij')
    window:setDefaultEscapeButton('Zamknij')
    window:sendToPlayer(player)

end

function onSay(player, words, param)
    -- 'local points = player:getLevel()' jest zdefiniowane, ale nieużywane.
    -- Zgodnie z instrukcjami, pozostaje w kodzie, ale warto to zauważyć.
    local points = player:getLevel() 
    doSendTutorial(player:getId())
    return false
end