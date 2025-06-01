local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)

-- Przedmioty dostępne w sklepie
shopModule:addBuyableItem({'arrow'}, 2544, 3, 'arrow') -- Strzały
shopModule:addBuyableItem({'assassin star'}, 7368, 100, 'assassin star') -- Gwiazdki zabójcy
shopModule:addBuyableItem({'bolt'}, 2543, 4, 'bolt') -- Bełty
shopModule:addBuyableItem({'bow'}, 2456, 400, 'bow') -- Łuk
shopModule:addBuyableItem({'crossbow'}, 2455, 500, 'crossbow') -- Kusza
shopModule:addBuyableItem({'spear'}, 2389, 9, 'spear') -- Włócznia

local function greetCallback(cid)
	-- Specjalne powitanie, jeśli gracz ma nałożony efekt ognia
	if Player(cid):getCondition(CONDITION_FIRE) then
		npcHandler:setMessage(MESSAGE_GREET, 'Hehe. Niezłe przedstawienie, |PLAYERNAME|, z tymi wszystkimi efektami piro. Zwróciłeś moją uwagę. Na minutę, może dwie.')
	else
		return false
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)

	-- Obsługa dialogu dotyczącego dodatków do stroju (addon)
	if msgcontains(msg, 'addon') then
		-- Sprawdza, czy gracz ma pierwszy addon stroju zabójcy i czy nie ukończył jeszcze drugiego etapu
		if player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and 156 or 152, 1) and player:getStorageValue(Storage.OutfitQuest.AssassinSecondAddon) < 1 then
			npcHandler:say('Udało ci się oszukać Erayo? Imponujące. Cóż, skoro zaszedłeś tak daleko, chyba mogę ci też dać zadanie, co?', cid)
			npcHandler.topic[cid] = 1 -- Ustawia temat dialogu na etap 1 zadania
		else
			npcHandler:say('Nie wiem, o czym mówisz.', cid)
		end
	-- Obsługa dialogu dotyczącego "nose ring" (pierścienia do nosa)
	elseif msgcontains(msg, 'nose ring') then
		-- Sprawdza, czy gracz jest w etapie zadania, gdzie potrzebuje pierścienia do nosa
		if player:getStorageValue(Storage.OutfitQuest.AssassinSecondAddon) == 1 then
			-- Sprawdza, czy gracz ma wymagane przedmioty: 5804 i 5930
			if player:getItemCount(5804) > 0 and player:getItemCount(5930) > 0 then
				player:removeItem(5804, 1) -- Usuwa przedmiot 5804
				player:removeItem(5930, 1) -- Usuwa przedmiot 5930
				player:addOutfitAddon(156, 2) -- Dodaje drugi addon do stroju żeńskiego (ID 156)
				player:addOutfitAddon(152, 2) -- Dodaje drugi addon do stroju męskiego (ID 152)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE) -- Efekt magiczny na pozycji gracza
				player:setStorageValue(Storage.OutfitQuest.AssassinSecondAddon, 2) -- Ustawia storage na ukończenie zadania
				player:addAchievement('Swift Death') -- Przyznaje osiągnięcie
				npcHandler:say('Widzę, że przyniosłeś moje rzeczy. Dobrze. Dotrzymam obietnicy: oto katana w zamian.', cid)
			else
				npcHandler:say('Nie masz wymaganych przedmiotów.', cid)
			end
		end
	-- Obsługa odpowiedzi "tak"
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say('Dobra, słuchaj. Nie mam listy głupich przedmiotów, chcę tylko dwóch rzeczy. {Szpon behemota} i {pierścień do nosa}. Zrozumiałeś?', cid)
			npcHandler.topic[cid] = 2 -- Przechodzi do kolejnego etapu dialogu
		elseif npcHandler.topic[cid] == 2 then
			-- Ustawia storage DefaultStart, jeśli nie jest ustawiony
			if player:getStorageValue(Storage.OutfitQuest.DefaultStart) ~= 1 then
				player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1)
			end
			player:setStorageValue(Storage.OutfitQuest.AssassinSecondAddon, 1) -- Ustawia storage na rozpoczęcie drugiego etapu addonu
			npcHandler:say('Dobrze. Wróć, kiedy będziesz miał OBA. Powinno być jasne, skąd wziąć szpon behemota. Jest lis rogaty, który nosi pierścień w nosie. Powodzenia.', cid)
			npcHandler.topic[cid] = 0 -- Resetuje temat dialogu
		end
	-- Obsługa odpowiedzi "nie"
	elseif msgcontains(msg, 'no') and npcHandler.topic[cid] > 0 then
		npcHandler:say('Może innym razem.', cid)
		npcHandler.topic[cid] = 0 -- Resetuje temat dialogu
	end
	return true
end

-- Ustawienie funkcji zwrotnych dla NPC
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new()) -- Dodaje moduł zarządzania fokusem na NPC