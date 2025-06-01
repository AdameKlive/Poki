local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local voices = { {text = 'Napij się w jedynej tawernie Meriany!'} }
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)

	if msgcontains(msg, 'cookie') then
		if player:getStorageValue(Storage.WhatAFoolishQuest.Questline) == 31
				and player:getStorageValue(Storage.WhatAFoolishQuest.CookieDelivery.Ariella) ~= 1 then
			npcHandler:say('Czyli przyniosłeś ciasteczko piratowi?', cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, 'addon') then
		npcHandler:say('Aby zdobyć kapelusz pirata, musisz mi dać kapelusz Brutusa Bloodbearda, koszulę Lethal Lissy, szablę Rona Rozpruwacza i opaskę na oko Deadeye Deviousa. Masz je przy sobie?', cid)
		npcHandler.topic[cid] = 2
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			if not player:removeItem(8111, 1) then
				npcHandler:say('Nie masz ciasteczka, które by mi się spodobało.', cid)
				npcHandler.topic[cid] = 0
				return true
			end

			player:setStorageValue(Storage.WhatAFoolishQuest.CookieDelivery.Ariella, 1)
			if player:getCookiesDelivered() == 10 then
				player:addAchievement('Allow Cookies?')
			end

			Npc():getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			npcHandler:say('Jak słodko z twojej strony... Uhh... O NIE... Bozo znowu to zrobił. Powiedz temu dowcipnisiowi, że się z nim rozliczę.', cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		elseif npcHandler.topic[cid] == 2 then
			if player:getStorageValue(Storage.OutfitQuest.PirateHatAddon) == -1 then
				if player:getItemCount(6101) > 0 and player:getItemCount(6102) > 0 and player:getItemCount(6100) > 0 and player:getItemCount(6099) > 0 then
					if player:removeItem(6101, 1) and player:removeItem(6102, 1) and player:removeItem(6100, 1) and player:removeItem(6099, 1) then
						npcHandler:say("Ach, tak! Kapelusz pirata! Proszę bardzo.", cid)
						player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
						player:setStorageValue(Storage.OutfitQuest.PirateHatAddon, 1)
						player:addOutfitAddon(155, 2)
						player:addOutfitAddon(151, 2)
					end
				else
					npcHandler:say("Nie masz wszystkich wymaganych przedmiotów.", cid)
				end
			else
				npcHandler:say("Wygląda na to, że już masz ten dodatek, nie próbuj mnie oszukać, synu!", cid)
			end
		end
	elseif msgcontains(msg, 'no') then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say('Rozumiem.', cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 2 then
			npcHandler:say('W porządku. Wróć, kiedy będziesz miał wszystkie niezbędne przedmioty.', cid)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())