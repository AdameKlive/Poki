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
	if player:getStorageValue(Storage.postman.Mission03) ~= 1 then
		return true
	end
	if msgcontains(msg, "rachunek") then
		if npcHandler.topic[cid] == 6 then
			npcHandler:say("Rachunek? Ojej, więc znowu dostarczasz mi rachunek, biedakowi?", cid)
			npcHandler.topic[cid] = 7
		end
	elseif msgcontains(msg, "tak") then
		if npcHandler.topic[cid] == 7 then
			npcHandler:say("Dobra, dobra, wezmę to. Chyba i tak nie mam innego wyboru. A teraz zostaw mnie w spokoju w mojej nędzy, proszę.", cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.postman.Mission03, 2)
		end
	elseif msgcontains(msg, "kapelusz") then
		if npcHandler.topic[cid] < 1 then
			npcHandler:say("Hm? Czego chcesz?!", cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 2 then
			npcHandler:say("Co? Mój kapelusz?? Nic w nim... nic specjalnego!", cid)
			npcHandler.topic[cid] = 3
		elseif npcHandler.topic[cid] == 3 then
			npcHandler:say("Przestań mnie dręczyć tym kapeluszem, słyszysz?", cid)
			npcHandler.topic[cid] = 4
		elseif npcHandler.topic[cid] == 4 then
			npcHandler:say("Hej! Nie dotykaj tego kapelusza! Zostaw go! Nie rób tego!!!!", cid)
			npcHandler.topic[cid] = 5
		elseif npcHandler.topic[cid] == 5 then
			for i = 1, 5 do
				Game.createMonster("Rabbit", Npc():getPosition())
			end
			npcHandler:say("Nieeeee! Argh, dobra, dobra, chyba nie mogę już dłużej zaprzeczać, jestem David Brassacres, wspaniały, więc czego chcesz?", cid)
			npcHandler.topic[cid] = 6
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())