local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'Wejdź, napij się i zjedz coś.'} }
npcHandler:addModule(VoiceModule:new(voices))

npcHandler:setMessage(MESSAGE_GREET, "Bądź opłakiwany, pielgrzymie w ciele. Bądź opłakiwany w mojej tawernie.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Odwiedź nas ponownie.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Odwiedź nas ponownie.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Jasne, przejrzyj moje oferty.")
npcHandler:addModule(FocusModule:new())