local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)          npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)       npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)        end
function onThink()      npcHandler:onThink()        end

local voices = { {text = 'Przejścia do Tibii, Foldy i Vegi.'} }
npcHandler:addModule(VoiceModule:new(voices))

-- Podróżowanie
local function addTravelKeyword(keyword, text, cost, destination)
    local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Chcesz popłynąć ' .. text, cost = cost})
        travelKeyword:addChildKeyword({'tak'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = cost, destination = destination})
        travelKeyword:addChildKeyword({'nie'}, StdModule.say, {npcHandler = npcHandler, text = 'Chętnie służylibyśmy ci pomocą w innym czasie.', reset = true})
end

addTravelKeyword('tibia', 'z powrotem do Tibii?', 0, Position(32235, 31674, 7))
addTravelKeyword('vega', 'na Vegę za |TRAVELCOST|?', 10, Position(32020, 31692, 7))
addTravelKeyword('folda', 'na Foldę za |TRAVELCOST|?', 10, Position(32046, 31578, 7))

-- Podstawowe
keywordHandler:addKeyword({'przejście'}, StdModule.say, {npcHandler = npcHandler, text = 'Dokąd chcesz się udać? Do {Tibia}, {Folda} czy {Vega}?'})
keywordHandler:addKeyword({'praca'}, StdModule.say, {npcHandler = npcHandler, text = 'Jestem kapitanem tego statku.'})
keywordHandler:addKeyword({'kapitan'}, StdModule.say, {npcHandler = npcHandler, text = 'Jestem kapitanem tego statku.'})

npcHandler:addModule(FocusModule:new())