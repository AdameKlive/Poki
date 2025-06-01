local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function greetCallback(cid)
    local player = Player(cid)
    -- Sprawdza, czy gracz ukończył pierwszą część questa na dodatek do stroju maga-przywoływacza
    if player:getStorageValue(Storage.OutfitQuest.MageSummoner.AddonWand) < 1 then
        -- Jeśli nie ukończył, NPC dziękuje za uratowanie i oferuje nagrodę
        npcHandler:setMessage(MESSAGE_GREET, "Bogom chwała, że wreszcie zostałem uratowany. Nie mam wielu ziemskich dóbr, ale proszę, przyjmij małą nagrodę, zgadzasz się?")
    elseif player:getStorageValue(Storage.OutfitQuest.MageSummoner.AddonWand) >= 1 then
        -- Jeśli ukończył, NPC dziękuje i oferuje teleportację z Dark Cathedral
        npcHandler:setMessage(MESSAGE_GREET, "Dzięki za uratowanie mi życia! Czy mam cię teleportować z Dark Cathedral?")
    end
    return true
end

local function creatureSayCallback(cid, type, msg)
    -- Sprawdza, czy NPC jest skupiony na graczu
    if not npcHandler:isFocused(cid) then
        return false
    end

    local player = Player(cid)
    -- Jeśli gracz powie "Yes" (Tak)
    if msgcontains(msg, "Yes") then
        -- Jeśli gracz nie ukończył pierwszej części questa
        if player:getStorageValue(Storage.OutfitQuest.MageSummoner.AddonWand) < 1 then
            -- NPC ujawnia sekret i ustawia wartości storage'a, wskazujące na postęp w queście
            npcHandler:say("Powiem ci teraz mały sekret. Moja przyjaciółka Lynda w Thais może stworzyć błogosławioną różdżkę. Pozdrów ją ode mnie, może ci pomoże.", cid)
            player:setStorageValue(Storage.OutfitQuest.MageSummoner.AddonWand, 1)
            player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1) -- To dla domyślnego startu questów na stroje i dodatki
        -- Jeśli gracz ukończył pierwszą część questa (lub więcej)
        elseif player:getStorageValue(Storage.OutfitQuest.MageSummoner.AddonWand) >= 1 then
            -- Gracz jest teleportowany na zewnątrz Dark Cathedral
            player:teleportTo(Position(32659, 32340, 7))
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        end
    end
    return true
end

-- Ustawienie funkcji zwrotnych dla powitania i domyślnych wiadomości
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())