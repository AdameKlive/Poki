local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

npcHandler:setMessage(MESSAGE_GREET, "Witaj, nieznajomy! Te jaskinie muszą wydawać ci się dziwne. Zastanawiam się, co cię tu sprowadza... może jesteś zainteresowany pracą? Mam kilka zadań, przy których przydałaby się pomoc.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Żegnaj!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Żegnaj!")
npcHandler:addModule(FocusModule:new())