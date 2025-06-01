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

	if msgcontains(msg, 'transport') then
		npcHandler:say('Możemy zabrać Cię do Thais jednym z naszych dorożek za 125 złotych monet. Jesteś zainteresowany?', cid)
		npcHandler.topic[cid] = 1
	elseif isInArray({'rent', 'horses'}, msg) then
		npcHandler:say('Chcesz wynająć konia na jeden dzień za 500 złotych monet?', cid)
		npcHandler.topic[cid] = 2
	elseif msgcontains(msg, 'yes') then
		local player = Player(cid)
		if npcHandler.topic[cid] == 1 then
			if player:isPzLocked() then
				npcHandler:say('Najpierw pozbądź się tych plam krwi!', cid)
				return true
			end

			if not player:removeMoney(125) then
				npcHandler:say('Nie masz wystarczająco pieniędzy.', cid)
				return true
			end

			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			local destination = Position(32449, 32226, 7)
			player:teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler:say('Miłej podróży!', cid)
		elseif npcHandler.topic[cid] == 2 then
			if player:getStorageValue(Storage.RentedHorseTimer) >= os.time() then
				npcHandler:say('Masz już konia.', cid)
				return true
			end

			if not player:removeMoney(500) then
				npcHandler:say('Nie masz wystarczająco pieniędzy, aby wynająć konia!', cid)
				return true
			end

			local mountId = {22, 25, 26}
			player:addMount(mountId[math.random(#mountId)])
			player:setStorageValue(Storage.RentedHorseTimer, os.time() + 86400)
			player:addAchievement('Natural Born Cowboy') -- Nazwa osiągnięcia pozostaje bez zmian
			npcHandler:say('Dam ci jednego z naszych doświadczonych. Uważaj! Sprawdzaj nisko wiszące gałęzie.', cid)
		end
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, 'no') and npcHandler.topic[cid] > 0 then
		npcHandler:say('W takim razie nie.', cid)
		npcHandler.topic[cid] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Witaj, |PLAYERNAME|! Zgaduję, że jesteś tutaj po {konie}.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())