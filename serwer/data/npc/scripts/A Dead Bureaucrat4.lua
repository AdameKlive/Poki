local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)          npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)       npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)        end
function onThink()      npcHandler:onThink()        end

local voices = {
    { text = 'Gdzież ja podziałam ten formularz?' },
    { text = 'Witaj Pumin. Tak, witaj.' }
}

npcHandler:addModule(VoiceModule:new(voices))

local config = {
    [1] = "C Z A R O D Z I E J",
    [2] = "D R U I D",
    [3] = "P A L A D Y N",
    [4] = "R Y C E R Z"
}

local function greetCallback(cid)
    npcHandler:setMessage(MESSAGE_GREET, "Witaj " .. (Player(cid):getSex() == PLAYERSEX_FEMALE and "piękna damo" or "przystojny panie") .. ", witaj w atrium Domeny Pumina. Zanim pozwolimy Ci przejść, potrzebujemy od Ciebie kilku informacji. Dokąd chcesz się udać?")
    return true
end

local function creatureSayCallback(cid, type, msg)
    if not npcHandler:isFocused(cid) then
        return false
    end

    local player = Player(cid)
    local vocationId = player:getVocation():getBase():getId()

    if msgcontains(msg, "Pumin") then
        if player:getStorageValue(Storage.PitsOfInferno.Pumin) == 1 then
            npcHandler:say("Nie jestem pewna, czy wiesz, co robisz, ale tak czy inaczej. Jak masz na imię?", cid)
            npcHandler.topic[cid] = 1
        end
    elseif msgcontains(msg, player:getName()) then
        if npcHandler.topic[cid] == 1 then
            npcHandler:say("W porządku |PLAYERNAME|. Profesja?", cid)
            npcHandler.topic[cid] = 2
        end
    elseif msgcontains(msg, Vocation(vocationId):getName()) then
        if npcHandler.topic[cid] == 2 then
            npcHandler:say(config[vocationId] .. ", zgadza się?! Czego ode mnie chcesz?", cid)
            npcHandler.topic[cid] = 3
        end
    elseif msgcontains(msg, "356") then
        if npcHandler.topic[cid] == 3 then
            player:setStorageValue(Storage.PitsOfInferno.Pumin, 2)
            npcHandler:say("Przepraszam, potrzebujesz Formularza 145, aby otrzymać Formularz 356. Wróć, gdy go będziesz mieć", cid)
            npcHandler.topic[cid] = 0
        elseif player:getStorageValue(Storage.PitsOfInferno.Pumin) == 7 then
            player:setStorageValue(Storage.PitsOfInferno.Pumin, 8)
            npcHandler:say("Jesteś lepszy niż myślałam! Gratulacje, oto jest: Formularz 356!", cid)
        end
    end
    return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Do widzenia i nie zapomnij o mnie!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Do widzenia i nie zapomnij o mnie!")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())