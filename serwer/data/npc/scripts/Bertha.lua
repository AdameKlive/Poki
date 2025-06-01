local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'Cześć, potrzebujesz jakichś ogólnych towarów lub papieru?'} }
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	if msgcontains(msg, "football") then
		npcHandler:say("Chcesz kupić piłkę nożną za 111 sztuk złota?", cid)
		npcHandler.topic[cid] = 1
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			local player = Player(cid)
			if player:getMoney() >= 111 then
				npcHandler:say("Proszę bardzo.", cid)
				player:addItem(2109, 1)
				player:removeMoney(111)
			else
				npcHandler:say("Nie masz wystarczająco pieniędzy.", cid)
			end
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

keywordHandler:addKeyword({'equipment'}, StdModule.say, {npcHandler = npcHandler, text = "Sprzedaję ekwipunek na Twoją przygodę! Po prostu poproś mnie o {handel}, aby zobaczyć moje towary."})

npcHandler:setMessage(MESSAGE_GREET, "Och, proszę wejdź, |PLAYERNAME|. Co mogę dla ciebie zrobić? Jeśli potrzebujesz sprzętu na przygodę, poproś mnie o {handel}.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Do widzenia, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Do widzenia, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Oczywiście, po prostu przejrzyj moje towary. {Piłki nożne} należy kupić osobno.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())