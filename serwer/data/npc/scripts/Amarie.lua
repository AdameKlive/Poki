local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'Proszę, zostaw mnie w spokoju... Muszę się uczyć.'} }
npcHandler:addModule(VoiceModule:new(voices))

local focusModule = FocusModule:new()
focusModule:addGreetMessage({'hi', 'hello', 'witam'}) -- Wiadomości powitalne (bez zmian)
focusModule:addFarewellMessage({'bye', 'zegnam', 'asgha thrazi'}) -- Wiadomości pożegnalne (bez zmian)
npcHandler:addModule(focusModule)