local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)          npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)       npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)        end
function onThink()              npcHandler:onThink()                    end

-- Misja (Tibia Tales: Rest In Hallowed Ground)
local startMissionKeyword = keywordHandler:addKeyword({'misja'}, StdModule.say, {npcHandler = npcHandler, text = 'Cóż, sam bym to zrobił, ale nie mogę opuścić miasta na dłużej. Czy byłbyś tak uprzejmy i przyniósł mi fiolkę święconej wody z Klasztoru Białego Kruka?'}, function(player) return player:getStorageValue(Storage.TibiaTales.RestInHallowedGround.Questline) == -1 end)
    startMissionKeyword:addChildKeyword({'tak'}, StdModule.say, {npcHandler = npcHandler, text = 'Dziękuję Ci bardzo z góry. Moc święconej wody z Klasztoru Białego Kruka jest legendarna. Jest ona niezbędna do mojego zadania. Porozmawiamy o tym, gdy wrócisz.', reset = true}, nil, function(player) player:setStorageValue(Storage.TibiaTales.RestInHallowedGround.Questline, 1) end)
    startMissionKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'To Twoja decyzja. Zapytam następną wierzącą duszę, która odwiedzi świątynię krwi Banora.', reset = true})

local function addMissionKeyword(text, value, newValue, addItem)
    keywordHandler:addKeyword({'misja'}, StdModule.say, {npcHandler = npcHandler, text = text},
        function(player) return player:getStorageValue(Storage.TibiaTales.RestInHallowedGround.Questline) == value end,
        function(player)
            if newValue then
                player:setStorageValue(Storage.TibiaTales.RestInHallowedGround.Questline, newValue)
            end

            if addItem then
                player:addItem(7498, 1)
            end
        end
    )
end

addMissionKeyword('Przede wszystkim musisz znaleźć sposób, aby dostać się na Wyspę Królów i zdobyć trochę święconej wody z Klasztoru Białego Kruka.', 1)
addMissionKeyword('Słyszałeś o nieświętym cmentarzu na północ od Edron? Idź tam i wylej trochę święconej wody na każdy grób. Gdy skończysz, wróć do mnie.', 2, 3)
addMissionKeyword('Czuję, że duchy jeszcze nie zaznały spokoju. Musi być jeszcze kilka grobów do uświęcenia.', 3)
addMissionKeyword('Doceniam twoją pomoc. Niech Banor zawsze będzie po twojej stronie. Oto twoja nagroda to paczka zawierająca pięć mikstur many i pięć mikstur zdrowia.', 4, 5, true)

keywordHandler:addKeyword({'misja'}, StdModule.say, {npcHandler = npcHandler, text = 'Twoją misją tutaj na Tibii jest być uprzejmym i przyjaznym. Bogowie cię wynagrodzą, obiecuję!'})

-- Twist of Fate
local blessKeyword = keywordHandler:addKeyword({'twist of fate'}, StdModule.say, {npcHandler = npcHandler,
        text = {
            'To specjalne błogosławieństwo, które mogę Ci udzielić, gdy uzyskasz co najmniej jedno z pozostałych błogosławieństw i które działa nieco inaczej. ...',
            'Działa tylko wtedy, gdy zostaniesz zabity przez innych awanturników, co oznacza, że co najmniej połowa obrażeń prowadzących do Twojej śmierci została spowodowana przez innych, a nie przez potwory czy otoczenie. ...',
            '{Twist of fate} nie zmniejszy kary za śmierć jak inne błogosławieństwa, ale zamiast tego zapobiegnie utracie innych błogosławieństw, a także amuletu straty, jeśli go nosisz. Kosztuje tyle samo, co inne błogosławieństwa. ...',
            'Czy chciałbyś otrzymać tę ochronę za ofiarę |PVPBLESSCOST| złota, dziecko?'
        }
    })
    blessKeyword:addChildKeyword({'tak'}, StdModule.bless, {npcHandler = npcHandler, text = 'Przyjmij więc ochronę Twist of Fate, pielgrzymie.', cost = '|PVPBLESSCOST|', bless = 6})
    blessKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Dobrze. Możesz swobodnie odrzucić moją ofertę.', reset = true})

-- Adventurer Stone
keywordHandler:addKeyword({'adventurer stone'}, StdModule.say, {npcHandler = npcHandler, text = 'Dobrze dbaj o swój kamień poszukiwacza przygód.'}, function(player) return player:getItemById(18559, true) end)

local stoneKeyword = keywordHandler:addKeyword({'adventurer stone'}, StdModule.say, {npcHandler = npcHandler, text = 'Ach, chcesz wymienić swój kamień poszukiwacza przygód za darmo?'}, function(player) return player:getStorageValue(Storage.AdventurersGuild.FreeStone.Amanda) ~= 1 end)
    stoneKeyword:addChildKeyword({'tak'}, StdModule.say, {npcHandler = npcHandler, text = 'Proszę bardzo. Uważaj.', reset = true}, nil, function(player) player:addItem(18559, 1) player:setStorageValue(Storage.AdventurersGuild.FreeStone.Amanda, 1) end)

local stoneKeyword = keywordHandler:addKeyword({'adventurer stone'}, StdModule.say, {npcHandler = npcHandler, text = 'Ach, chcesz wymienić swój kamień poszukiwacza przygód za 30 sztuk złota?'})
    stoneKeyword:addChildKeyword({'tak'}, StdModule.say, {npcHandler = npcHandler, text = 'Proszę bardzo. Uważaj.', reset = true},
        function(player) return player:getMoney() >= 30 end,
        function(player) player:removeMoney(30) player:addItem(18559, 1) end
    )
    stoneKeyword:addChildKeyword({'tak'}, StdModule.say, {npcHandler = npcHandler, text = 'Przepraszam, nie masz wystarczająco pieniędzy.', reset = true})
    stoneKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Nie ma problemu.', reset = true})

-- Wooden Stake
keywordHandler:addKeyword({'stake'}, StdModule.say, {npcHandler = npcHandler, text = 'Myślę, że zapomniałeś zabrać swój pal, moje dziecko.'}, function(player) return player:getStorageValue(Storage.FriendsandTraders.TheBlessedStake) == 6 and player:getItemCount(5941) == 0 end)

local stakeKeyword = keywordHandler:addKeyword({'stake'}, StdModule.say, {npcHandler = npcHandler, text = 'Tak, zostałem poinformowany, co robić. Czy jesteś gotów przyjąć moje słowa modlitwy?'}, function(player) return player:getStorageValue(Storage.FriendsandTraders.TheBlessedStake) == 6 end)
    stakeKeyword:addChildKeyword({'tak'}, StdModule.say, {npcHandler = npcHandler, text = 'Przyjmij więc moją modlitwę: \'Złe klątwy zostaną złamane\'. Teraz zanieś swój pal do Kasmira w Darashii po kolejną część modlitwy. Poinformuję go, co ma robić.', reset = true}, nil,
        function(player) player:setStorageValue(Storage.FriendsandTraders.TheBlessedStake, 7) player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE) end
    )
    stakeKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Będę na ciebie czekać.', reset = true})

keywordHandler:addKeyword({'stake'}, StdModule.say, {npcHandler = npcHandler, text = 'Powinieneś teraz odwiedzić Kasmira w Darashii, moje dziecko.'}, function(player) return player:getStorageValue(Storage.FriendsandTraders.TheBlessedStake) == 7 end)
keywordHandler:addKeyword({'stake'}, StdModule.say, {npcHandler = npcHandler, text = 'Już otrzymałeś moje słowa modlitwy.'}, function(player) return player:getStorageValue(Storage.FriendsandTraders.TheBlessedStake) > 7 end)
keywordHandler:addKeyword({'stake'}, StdModule.say, {npcHandler = npcHandler, text = 'Błogosławiony pal? To dziwna prośba. Może Kasmir wie więcej, w końcu jest jednym z najstarszych mnichów.'})

-- Healing
local function addHealKeyword(text, condition, effect)
    keywordHandler:addKeyword({'lecz'}, StdModule.say, {npcHandler = npcHandler, text = text},
        function(player) return player:getCondition(condition) ~= nil end,
        function(player)
            player:removeCondition(condition)
            player:getPosition():sendMagicEffect(effect)
        end
    )
end

addHealKeyword('Płoniesz. Pozwól mi ugasić te płomienie.', CONDITION_FIRE, CONST_ME_MAGIC_GREEN)
addHealKeyword('Jesteś zatruty. Pozwól mi złagodzić Twój ból.', CONDITION_POISON, CONST_ME_MAGIC_RED)
addHealKeyword('Jesteś pod wpływem elektryczności, moje dziecko. Pozwól mi pomóc Ci przestać drżeć.', CONDITION_ENERGY, CONST_ME_MAGIC_GREEN)

keywordHandler:addKeyword({'lecz'}, StdModule.say, {npcHandler = npcHandler, text = 'Jesteś ranny, moje dziecko. Uleczę Twoje rany.'},
    function(player) return player:getHealth() < 40 end,
    function(player)
        local health = player:getHealth()
        if health < 40 then player:addHealth(40 - health) end
        player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
    end
)
keywordHandler:addKeyword({'lecz'}, StdModule.say, {npcHandler = npcHandler, text = 'Nie wyglądasz tak źle. Przepraszam, nie mogę Ci pomóc. Ale jeśli szukasz dodatkowej ochrony, powinieneś udać się na {pielgrzymkę} popiołów lub uzyskać tutaj ochronę {twist of fate}.'})

-- Basic
keywordHandler:addKeyword({'pielgrzymka'}, StdModule.say, {npcHandler = npcHandler, text = 'Za każdym razem, gdy otrzymasz śmiertelną ranę, Twoja siła witalna zostaje uszkodzona i istnieje szansa, że stracisz część swojego ekwipunku. Z każdym pojedynczym z pięciu posiadanych {błogosławieństw} to uszkodzenie i szansa na utratę zostaną zmniejszone.'})
keywordHandler:addKeyword({'błogosławieństwa'}, StdModule.say, {npcHandler = npcHandler, text = 'Dostępnych jest pięć błogosławieństw w pięciu świętych miejscach: {duchowa} tarcza, iskra {feniksa}, {uścisk} Tibii, ogień {słońc} i mądrość {samotności}. Dodatkowo, możesz otrzymać {twist of fate} tutaj.'})
keywordHandler:addKeyword({'duchowa'}, StdModule.say, {npcHandler = npcHandler, text = 'Widzę, że otrzymałeś duchową tarczę w świątyni białego kwiatu na południe od Thais.'}, function(player) return player:hasBlessing(1) end)
keywordHandler:addAliasKeyword({'tarcza'})
keywordHandler:addKeyword({'uścisk'}, StdModule.say, {npcHandler = npcHandler, text = 'Czuję, że druidzi na północ od Carlin zapewnili ci Uścisk Tibii.'}, function(player) return player:hasBlessing(2) end)
keywordHandler:addKeyword({'słońc'}, StdModule.say, {npcHandler = npcHandler, text = 'Widzę, że otrzymałeś błogosławieństwo dwóch słońc w wieży słońca w pobliżu Ab\'Dendriel.'}, function(player) return player:hasBlessing(3) end)
keywordHandler:addAliasKeyword({'ogień'})
keywordHandler:addKeyword({'feniksa'}, StdModule.say, {npcHandler = npcHandler, text = 'Czuję, że iskra feniksa została ci już dana przez krasnoludzkich kapłanów ziemi i ognia w Kazordoon.'}, function(player) return player:hasBlessing(4) end)
keywordHandler:addAliasKeyword({'iskra'})
keywordHandler:addKeyword({'samotności'}, StdModule.say, {npcHandler = npcHandler, text = 'Czuję, że rozmawiałeś już z pustelnikiem Eremo na wyspie Cormaya i otrzymałeś to błogosławieństwo.'}, function(player) return player:hasBlessing(5) end)
keywordHandler:addAliasKeyword({'mądrość'})
keywordHandler:addKeyword({'duchowa'}, StdModule.say, {npcHandler = npcHandler, text = 'Możesz poprosić o błogosławieństwo duchowej tarczy w świątyni białego kwiatu na południe od Thais.'})
keywordHandler:addAliasKeyword({'tarcza'})
keywordHandler:addKeyword({'uścisk'}, StdModule.say, {npcHandler = npcHandler, text = 'Druidzi na północ od Carlin zapewnią ci uścisk Tibii.'})
keywordHandler:addKeyword({'słońc'}, StdModule.say, {npcHandler = npcHandler, text = 'Możesz poprosić o błogosławieństwo dwóch słońc w wieży słońca w pobliżu Ab\'Dendriel.'})
keywordHandler:addAliasKeyword({'ogień'})
keywordHandler:addKeyword({'feniksa'}, StdModule.say, {npcHandler = npcHandler, text = 'Iskra feniksa jest udzielana przez krasnoludzkich kapłanów ziemi i ognia w Kazordoon.'})
keywordHandler:addAliasKeyword({'iskra'})
keywordHandler:addKeyword({'samotności'}, StdModule.say, {npcHandler = npcHandler, text = 'Porozmawiaj z pustelnikiem Eremo na wyspie Cormaya o tym błogosławieństwie.'})
keywordHandler:addAliasKeyword({'mądrość'})

npcHandler:setMessage(MESSAGE_GREET, 'Witaj, młody |PLAYERNAME|! Jeśli jesteś ciężko ranny lub zatruty, mogę Cię {uleczyć} za darmo.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Pamiętaj: Jeśli jesteś ciężko ranny lub zatruty, mogę Cię uleczyć za darmo.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Niech bogowie cię błogosławią, |PLAYERNAME|!')

npcHandler:addModule(FocusModule:new())