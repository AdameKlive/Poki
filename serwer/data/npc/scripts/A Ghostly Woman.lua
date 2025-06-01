local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

-- Definicja głosu NPC
local voices = { {text = 'Samotnie... tak samotnie. Tak zimno.'} }
npcHandler:addModule(VoiceModule:new(voices))

-- Definicja słowa kluczowego "job"
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "Kiedyś byłem członkiem zakonu Rycerzy Koszmaru. Teraz jestem tylko cieniem, który przemierza te zimne korytarze."})

-- Wiadomości NPC
npcHandler:setMessage(MESSAGE_GREET, "Czuję cię. Słyszę twoje myśli. Jesteś... żywy.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Samotnie... tak samotnie. Tak zimno.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Samotnie... tak samotnie. Tak zimno.")

-- Dodanie modułu FocusModule
npcHandler:addModule(FocusModule:new())