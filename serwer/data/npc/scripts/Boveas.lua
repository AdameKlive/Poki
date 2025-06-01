local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)          npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)       npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

npcHandler:setMessage(MESSAGE_GREET, "Cześć! Mam nadzieję, że nie zamierzasz mnie zabić!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Do widzenia, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Do widzenia, |PLAYERNAME|.")
npcHandler:addModule(FocusModule:new())