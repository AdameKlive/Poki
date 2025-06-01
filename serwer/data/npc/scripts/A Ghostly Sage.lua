local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

-- Definicja węzła dialogowego dla słowa kluczowego 'teleport'
local travelNode = keywordHandler:addKeyword({'teleport'}, StdModule.say, {npcHandler = npcHandler, text = 'Zostaniesz stąd przeniesiony. Czy na pewno chcesz stawić czoła temu teleportowi?'})
	-- Dziecko słowa kluczowego 'teleport' dla odpowiedzi 'yes'
	travelNode:addChildKeyword({'tak'}, StdModule.travel, {npcHandler = npcHandler, premium = true, destination = Position(32834, 32275, 9) })
	-- Dziecko słowa kluczowego 'teleport' dla odpowiedzi 'no'
	travelNode:addChildKeyword({'nie'}, StdModule.say, {npcHandler = npcHandler, reset = true, text = 'Zatem zostań tutaj w tych upiornych salach.'})

-- Dodaje słowo kluczowe 'passage'
keywordHandler:addKeyword({'przejście'}, StdModule.say, {npcHandler = npcHandler, text = 'Mogę zaoferować ci {teleport}.'})
-- Dodaje słowo kluczowe 'job'
keywordHandler:addKeyword({'praca'}, StdModule.say, {npcHandler = npcHandler, text = 'Nie przejmuj się mną.'})

-- Ustawia wiadomości powitalne i pożegnalne NPC
npcHandler:setMessage(MESSAGE_GREET, "Ach, czuję, że śmiertelnik znowu kroczy tymi starożytnymi salami. Wybacz, ledwo cię zauważam. Jestem tak pogrążony w myślach.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Do widzenia.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Zatem żegnaj.")

-- Dodaje moduł FocusModule, który zarządza skupieniem NPC na graczu
npcHandler:addModule(FocusModule:new())