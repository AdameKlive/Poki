local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'Witaj w sklepie z artykułami ogólnymi w Ab\'Dendriel.'} }
npcHandler:addModule(VoiceModule:new(voices))

npcHandler:setMessage(MESSAGE_GREET, "Witaj, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Żegnaj, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Niech Bóg wskazuje ci drogę, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Oczywiście, po prostu przejrzyj moje oferty.")

local focusModule = FocusModule:new()
focusModule:addGreetMessage({'cześć', 'witaj', 'ashari'})
focusModule:addFarewellMessage({'żegnaj', 'do widzenia', 'asgha thrazi'})
npcHandler:addModule(focusModule)