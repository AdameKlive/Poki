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

	if npcHandler.topic[cid] == 0 then
		if msgcontains(msg, 'outfit') then
			npcHandler:say({
				'Jestem zmęczony tymi wszystkimi młodymi, niedoświadczonymi, aspirującymi bohaterami. Każdy Tibijczyk może pokazać swoje umiejętności lub czyny, nosząc specjalny strój. Aby udowodnić swoją wartość dla demonicznego stroju, oto jak to wygląda: ...',
				'Podstawowy strój zostanie przyznany za ukończenie zadania Annihilatora, co moim zdaniem nie jest dziś wielkim wyzwaniem. W każdym razie ...',
				'Tarcza zostanie jednak przyznana tylko tym poszukiwaczom przygód, którzy ukończyli zadanie Demon Helmet. ...',
				'Cóż, hełm jest dla tych, którzy naprawdę są wytrwali i upolowali wszystkie 6666 demonów, a także ukończyli Demon Oak. ...',
				'Jesteś zainteresowany?'
			}, cid)
			npcHandler.topic[cid] = 1
		elseif msgcontains(msg, 'cookie') then
			-- Sprawdza, czy gracz ukończył odpowiednią część questa i czy ciasteczko nie zostało jeszcze dostarczone Avar Tarowi.
			if player:getStorageValue(Storage.WhatAFoolishQuest.Questline) == 31
					and player:getStorageValue(Storage.WhatAFoolishQuest.CookieDelivery.AvarTar) ~= 1 then
				npcHandler:say('Czy naprawdę myślisz, że mógłbyś przekupić takiego bohatera jak ja mizernym ciasteczkiem?', cid)
				npcHandler.topic[cid] = 3
			end
		end
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say('Więc chcesz mieć demoniczny strój, hę! Sprawdźmy najpierw, czy naprawdę na to zasługujesz. Powiedz mi: {podstawowy}, {tarcza} czy {hełm}?', cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 3 then
			-- Próbuje usunąć ciasteczko z ekwipunku gracza.
			if not player:removeItem(8111, 1) then
				npcHandler:say('Nie masz ciasteczka, które by mi się spodobało.', cid)
				npcHandler.topic[cid] = 0
				return true
			end

			-- Ustawia wartość storage, by oznaczyć ciasteczko jako dostarczone.
			player:setStorageValue(Storage.WhatAFoolishQuest.CookieDelivery.AvarTar, 1)
			-- Sprawdza, czy gracz dostarczył 10 ciasteczek (warunek osiągnięcia).
			if player:getCookiesDelivered() == 10 then
				player:addAchievement('Allow Cookies?') -- Dodaje osiągnięcie.
			end

			Npc():getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS) -- Efekt magiczny na pozycji NPC.
			npcHandler:say('Cóż, nie uda Ci się! Chociaż wygląda smacznie ... Co to ... CO TY SOBIE MYŚLISZ? TO JEST NAJWIĘKSZA OBRAZA! ZNIKAJ!', cid)
			npcHandler:releaseFocus(cid) -- NPC traci focus na graczu.
			npcHandler:resetNpc(cid) -- Resetuje stan NPC.
		end
	elseif msgcontains(msg, 'no') then
		if npcHandler.topic[cid] == 3 then
			npcHandler:say('Rozumiem.', cid)
			npcHandler.topic[cid] = 0
		end
	elseif npcHandler.topic[cid] == 2 then
		-- Sprawdza, czy gracz pyta o podstawowy strój.
		if msgcontains(msg, 'base') then
			-- Sprawdza, czy gracz ukończył Annihilator Quest.
			if player:getStorageValue(Storage.AnnihilatorDone) == 1 then
				player:addOutfit(541) -- Dodaje męski strój.
				player:addOutfit(542) -- Dodaje żeński strój.
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.AnnihilatorDone, 2) -- Ustawia storage na "otrzymano podstawowy strój".
				npcHandler:say('Otrzymaj podstawowy strój, |PLAYERNAME|.', cid)
			end
		-- Sprawdza, czy gracz pyta o dodatek tarczy.
		elseif msgcontains(msg, 'shield') then
			-- Sprawdza, czy gracz ma podstawowy strój i ukończył Demon Helmet Quest.
			if player:getStorageValue(Storage.AnnihilatorDone) == 2 and player:getStorageValue(Storage.QuestChests.DemonHelmetQuestDemonHelmet) == 1 then
				player:addOutfitAddon(541, 1) -- Dodaje dodatek 1 do męskiego stroju.
				player:addOutfitAddon(542, 1) -- Dodaje dodatek 1 do żeńskiego stroju.
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.QuestChests.DemonHelmetQuestDemonHelmet, 2) -- Ustawia storage na "otrzymano dodatek tarczy".
				npcHandler:say('Otrzymaj tarczę, |PLAYERNAME|.', cid)
			end
		-- Sprawdza, czy gracz pyta o dodatek hełmu.
		elseif msgcontains(msg, 'helmet') then
			-- Sprawdza, czy gracz ma podstawowy strój i ukończył Demon Oak Quest.
			if player:getStorageValue(Storage.AnnihilatorDone) == 2 and player:getStorageValue(Storage.DemonOak.Done) == 3 then
				player:addOutfitAddon(541, 2) -- Dodaje dodatek 2 do męskiego stroju.
				player:addOutfitAddon(542, 2) -- Dodaje dodatek 2 do żeńskiego stroju.
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.DemonOak.Done, 4) -- Ustawia storage na "otrzymano dodatek hełmu".
				npcHandler:say('Otrzymaj hełm, |PLAYERNAME|.', cid)
			end
		end
		npcHandler.topic[cid] = 0 -- Resetuje temat rozmowy.
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Witaj, podróżniku |PLAYERNAME|!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Do zobaczenia później, |PLAYERNAME|.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Do zobaczenia później, |PLAYERNAME|.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())