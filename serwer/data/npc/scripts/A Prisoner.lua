local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	if msgcontains(msg, "zagadka") then
		if player:getStorageValue(Storage.madMageQuest) ~= 1 then
			npcHandler:say("Świetna zagadka, prawda? Jeśli podasz mi prawidłową odpowiedź, dam ci coś. Hehehe!", cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "PD-D-KS-P-PD") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("Hura! Za to dam ci mój klucz do – hmm – powiedzmy... kilku jabłek. Jesteś zainteresowany?", cid)
			npcHandler.topic[cid] = 2
		end
	elseif msgcontains(msg, "tak") then
		if npcHandler.topic[cid] == 2 then
			if player:removeItem(2674, 7) then
				npcHandler:say("Mniam – wyśmienite jabłka. Teraz – co do klucza. Jesteś pewien, że go chcesz?", cid)
				npcHandler.topic[cid] = 3
			else
				npcHandler:say("Najpierw zdobądź więcej jabłek!", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 3 then
			npcHandler:say("Naprawdę, naprawdę?", cid)
			npcHandler.topic[cid] = 4
		elseif npcHandler.topic[cid] == 4 then
			npcHandler:say("Naprawdę, naprawdę, naprawdę, naprawdę?", cid)
			npcHandler.topic[cid] = 5
		elseif npcHandler.topic[cid] == 5 then
			player:setStorageValue(Storage.madMageQuest, 1)
			npcHandler:say("Więc weź go i bądź szczęśliwy – albo zgiń, hehe.", cid)
			local key = player:addItem(2088, 1)
			if key then
				key:setActionId(3666)
			end
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "nie") then
		npcHandler:say("Więc idź precz!", cid)
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Czekaj! Nie odchodź! Chcę ci opowiedzieć o moich surrealistycznych liczbach.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Następnym razem powinniśmy porozmawiać o moich surrealistycznych liczbach.")
npcHandler:setMessage(MESSAGE_GREET, "Co? Co? Widzę! Wow! Nie-mino. Czy ciebie też {schwytali}?")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())