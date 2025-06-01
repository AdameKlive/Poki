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
	if msgcontains(msg, 'documents') then
		if player:getStorageValue(Storage.thievesGuild.Mission04) == 2 then
			player:setStorageValue(Storage.thievesGuild.Mission04, 3)
			npcHandler:say({
				'Potrzebujesz sfałszowanych dokumentów? Ale ja fałszuję tylko dla przyjaciela. ...',
				'Nomadzi przy północnej oazie zabili kogoś mi drogiego. Idź i zabij przynajmniej jednego z nich, wtedy porozmawiamy o Twoim dokumencie.'
			}, cid)
		elseif player:getStorageValue(Storage.thievesGuild.Mission04) == 4 then
			npcHandler:say('Zabójca moich wrogów jest moim przyjacielem! Za jedyne 1000 sztuk złota stworzę potrzebne Ci dokumenty. Jesteś zainteresowany?', cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			if player:removeMoney(1000) then
				player:addItem(8694, 1)
				player:setStorageValue(Storage.thievesGuild.Mission04, 5)
				npcHandler:say('Oto one! Teraz zapomnij, skąd je masz.', cid)
			else
				npcHandler:say('Nie masz wystarczająco pieniędzy.', cid)
			end
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())