local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)          npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)       npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)        end
function onThink()      npcHandler:onThink()        end

local voices = {
    { text = 'Gdzie ja podziałem ten formularz?' },
    { text = 'Witaj Puminie. Tak, witaj.' }
}

npcHandler:addModule(VoiceModule:new(voices))

local config = {
    [1] = "różdżkę", -- wand (różdżka)
    [2] = "wędkę",   -- rod (wędka)
    [3] = "łuk",     -- bow (łuk)
    [4] = "miecz"    -- sword (miecz)
}

local function greetCallback(cid)
    npcHandler:setMessage(MESSAGE_GREET, "Witaj " .. (Player(cid):getSex() == PLAYERSEX_FEMALE and "piękna pani" or "przystojny panie") .. ", witamy w atrium Domeny Pumina. Potrzebujemy od Ciebie pewnych informacji, zanim pozwolimy Ci przejść. Dokąd chcesz iść?")
    return true
end

local function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end

    local player = Player(cid)
    local vocationId = player:getVocation():getBase():getId()

    if msgcontains(msg, "pumin") then
        if npcHandler.topic[cid] == 0 and player:getStorageValue(Storage.PitsOfInferno.Pumin) < 1 then
            npcHandler:say("Jasne, gdzie indziej. Każdy lubi spotkać mojego mistrza, to wspaniały demon, prawda? Nazywasz się...?", cid)
            npcHandler.topic[cid] = 1
        elseif npcHandler.topic[cid] == 3 then
            player:setStorageValue(Storage.PitsOfInferno.Pumin, 1)
            npcHandler:say("Jakże to interesujące. Muszę to natychmiast powiedzieć mojemu mistrzowi. Proszę, idź do moich kolegów i poproś o Formularz 356. Będzie Ci potrzebny, aby kontynuować.", cid)
            npcHandler.topic[cid] = 0
        end
    elseif msgcontains(msg, player:getName()) then
        if npcHandler.topic[cid] == 1 then
            npcHandler:say("Dobrze, |PLAYERNAME|. Profesja?", cid)
            npcHandler.topic[cid] = 2
        end
    elseif msgcontains(msg, Vocation(vocationId):getName()) then
        if npcHandler.topic[cid] == 2 then
            npcHandler:say("Huhu, proszę, nie rań mnie swoją " .. config[vocationId] .. "! Powód wizyty?", cid)
            npcHandler.topic[cid] = 3
        end
    elseif msgcontains(msg, "411") then
        if player:getStorageValue(Storage.PitsOfInferno.Pumin) == 3 then
            npcHandler:say("Formularz 411? Potrzebujesz Formularza 287, żeby go zdobyć! Czy go masz?", cid)
            npcHandler.topic[cid] = 4
        elseif player:getStorageValue(Storage.PitsOfInferno.Pumin) == 5 then
            npcHandler:say("Formularz 411? Potrzebujesz Formularza 287, żeby go zdobyć! Czy go masz?", cid)
            npcHandler.topic[cid] = 5
        end
    elseif msgcontains(msg, "nie") then
        if npcHandler.topic[cid] == 4 then
            player:setStorageValue(Storage.PitsOfInferno.Pumin, 4)
            npcHandler:say("Och, jaka szkoda. Idź do jednego z moich kolegów. Daję Ci pozwolenie na zdobycie Formularza 287. Do widzenia!", cid)
        end
    elseif msgcontains(msg, "tak") then
        if npcHandler.topic[cid] == 5 then
            player:setStorageValue(Storage.PitsOfInferno.Pumin, 6)
            npcHandler:say("Świetnie. Proszę. Formularz 411. Wracaj, kiedy tylko zechcesz porozmawiać. Do widzenia.", cid)
        end
    elseif msgcontains(msg, "356") then
        if player:getStorageValue(Storage.PitsOfInferno.Pumin) == 8 then
            player:setStorageValue(Storage.PitsOfInferno.Pumin, 9)
            npcHandler:say("NIESAMOWITE, udało ci się!! Baw się dobrze w Domenie Pumina!", cid)
        end
    end
    return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Do widzenia i nie zapomnij o mnie!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Do widzenia i nie zapomnij o mnie!")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())