local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function greetCallback(cid)
	local player = Player(cid)
	-- Jeśli gracz ukończył pierwszą część questu lub postęp jest powyżej określonej wartości.
	if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 1 or player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) > 3 then
		npcHandler:setMessage(MESSAGE_GREET, "Co ty robisz w moim miejscu?")
	-- Jeśli gracz wrócił po odczekaniu i jest w odpowiednim etapie questu.
	elseif player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 2 and player:getStorageValue(Storage.OutfitQuest.BarbarianAddonWaitTimer) < os.time() then
		npcHandler:setMessage(MESSAGE_GREET, "Wróciłeś. Wiesz, masz rację. Brat ma rację. Pięść nie zawsze jest dobra. Powiedz mu to!")
		player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 3) -- Zmienia etap questu.
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	-- PREQUEST (Początkowa faza questu)
	if msgcontains(msg, "mine") then -- Jeśli gracz mówi "mine" (moje)
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 1 then
			npcHandler:say("TWOJE? CO JEST TWOJE! NIC NIE JEST TWOJE! JEST MOJE! IDŹ SOBIE, TAK?!", cid)
			npcHandler.topic[cid] = 1 -- Zmienia temat rozmowy.
		end
	elseif msgcontains(msg, "no") then -- Jeśli gracz mówi "no" (nie)
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("GŁUPI JESTEŚ! UPARTY! ZABIJĘ CIĘ! ODEJDZIESZ TERAZ?!", cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 2 then
			npcHandler:say("ARRRRRRRRRR! DOPROWADZASZ MNIE DO SZAŁU! JAK MAM CIĘ ZMusić DO ODEJŚCIA??", cid)
			npcHandler.topic[cid] = 3
		elseif npcHandler.topic[cid] == 3 then
			npcHandler:say("DAJĘ CI NIE!", cid)
			npcHandler.topic[cid] = 4
		end
	elseif msgcontains(msg, "please") then -- Jeśli gracz mówi "please" (proszę)
		if npcHandler.topic[cid] == 4 then
			npcHandler:say("Proszę? Co masz na myśli proszę? Jak ja mówię proszę, ty mówisz pa? Proszę?", cid)
			npcHandler.topic[cid] = 5
		end
	-- OUTFIT (Główna część questu na addon)
	elseif msgcontains(msg, "gelagos") then -- Jeśli gracz mówi "gelagos"
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 4 then
			npcHandler:say("Denerwujące dziecko. Brat go nienawidzi, ale rozmowy nie pomogą. Brat potrzebuje {ducha walki}!", cid)
			npcHandler.topic[cid] = 6
		end
	elseif msgcontains(msg, "fighting spirit") then -- Jeśli gracz mówi "fighting spirit" (duch walki)
		if npcHandler.topic[cid] == 6 then
			npcHandler:say("Jeśli chcesz pomóc bratu, przynieś mu ducha walki. Magicznego ducha walki. Zapytaj Dżina.", cid)
			player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 5) -- Zmienia etap questu.
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "present") then -- Jeśli gracz mówi "present" (prezent)
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 11 then
			npcHandler:say("Bron dał mi prezent. Brzydki, ale miły od niego. Ja też chcę dać prezent. Pomożesz mi?", cid)
			npcHandler.topic[cid] = 6
		end
	elseif msgcontains(msg, "ore") then -- Jeśli gracz mówi "ore" (ruda)
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 12 then
			npcHandler:say("Przyniosłeś 100 rudy żelaza?", cid)
			npcHandler.topic[cid] = 8
		end
	elseif msgcontains(msg, "iron") then -- Jeśli gracz mówi "iron" (żelazo)
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 13 then
			npcHandler:say("Przyniosłeś surowe żelazo?", cid)
			npcHandler.topic[cid] = 9
		end
	elseif msgcontains(msg, "fangs") then -- Jeśli gracz mówi "fangs" (kły)
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 14 then
			npcHandler:say("Przyniosłeś 50 kłów behemotha?", cid)
			npcHandler.topic[cid] = 10
		end
	elseif msgcontains(msg, "leather") then -- Jeśli gracz mówi "leather" (skóra)
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 15 then
			npcHandler:say("Przyniosłeś 50 jaszczurzej skóry?", cid)
			npcHandler.topic[cid] = 11
		end
	elseif msgcontains(msg, "axe") then -- Jeśli gracz mówi "axe" (topór)
		-- Sprawdza, czy topór jest już gotowy (upłynął czas oczekiwania).
		if player:getStorageValue(Storage.OutfitQuest.BarbarianAddon) == 16 and player:getStorageValue(Storage.OutfitQuest.BarbarianAddonWaitTimer) < os.time() then
			npcHandler:say("Topór gotowy! Dla ciebie. Bierz. Noś jak ja.", cid)
			player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 17) -- Zmienia etap questu na ukończony.
			player:addOutfitAddon(147, 2) -- Dodaje addon dla postaci męskiej.
			player:addOutfitAddon(143, 2) -- Dodaje addon dla postaci żeńskiej.
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE) -- Wysyła efekt magiczny.
			player:addAchievement('Brutal Politeness') -- Dodaje osiągnięcie.
		else
			npcHandler:say("Topór jeszcze nie gotowy!", cid)
		end
	-- OUTFIT (Ciąg dalszy głównej części questu, odpowiedzi na "yes")
	elseif msgcontains(msg, "yes") then -- Jeśli gracz mówi "yes" (tak)
		if npcHandler.topic[cid] == 5 then
			npcHandler:say("Och. Łatwo. Dobra. Proszę jest dobre. Teraz nic nie mów. Głowa boli. ", cid)
			local condition = Condition(CONDITION_FIRE) -- Tworzy warunek ognia.
			condition:setParameter(CONDITION_PARAM_DELAYED, 1)
			condition:addDamage(10, 2000, -10) -- Zadaje obrażenia.
			player:addCondition(condition) -- Dodaje warunek do gracza.
			player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 2) -- Zmienia etap questu.
			player:setStorageValue(Storage.OutfitQuest.BarbarianAddonWaitTimer, os.time() + 60 * 60) -- Ustawia timer na 1 godzinę.
			npcHandler:releaseFocus(cid) -- Zwalnia skupienie na graczu.
			npcHandler:resetNpc(cid) -- Resetuje NPC.
		elseif npcHandler.topic[cid] == 6 then
			npcHandler:say({
				"Dobrze! Ja robię błyszczącą broń. Jeśli mi pomożesz, zrobię jedną dla ciebie też. Jak topór, który noszę. Potrzebuję rzeczy. Słuchaj. ...",
				"Potrzebuję 100 rudy żelaza. Potem potrzebuję surowego żelaza. Potem 50 kłów behemotha. I 50 jaszczurzej skóry. Rozumiesz?",
				"Pomożesz mi, tak czy nie?"
			}, cid)
			npcHandler.topic[cid] = 7
		elseif npcHandler.topic[cid] == 7 then
			npcHandler:say("Dobrze. Najpierw zdobądź 100 rudy żelaza. Wróć później.", cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 12) -- Zmienia etap questu.
		elseif npcHandler.topic[cid] == 8 then
			if player:removeItem(5880, 100) then -- Usuwa 100 sztuk rudy żelaza.
				npcHandler:say("Dobrze! Teraz przynieś surowe żelazo.", cid)
				player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 13) -- Zmienia etap questu.
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 9 then
			if player:removeItem(5892, 1) then -- Usuwa 1 sztukę surowego żelaza.
				npcHandler:say("Dobrze! Teraz przynieś 50 kłów behemotha.", cid)
				player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 14) -- Zmienia etap questu.
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 10 then
			if player:removeItem(5893, 50) then -- Usuwa 50 kłów behemotha.
				npcHandler:say("Dobrze! Teraz przynieś 50 jaszczurzej skóry.", cid)
				player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 15) -- Zmienia etap questu.
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 11 then
			if player:removeItem(5876, 50) then -- Usuwa 50 jaszczurzej skóry.
				npcHandler:say("Ach! Wszystko jest. Zacznę teraz robić topory. Wróć później i poproś mnie o topór.", cid)
				player:setStorageValue(Storage.OutfitQuest.BarbarianAddon, 16) -- Zmienia etap questu.
				player:setStorageValue(Storage.OutfitQuest.BarbarianAddonWaitTimer, os.time() + 2 * 60 * 60) -- Ustawia timer na 2 godziny.
				npcHandler.topic[cid] = 0
			end
		end
	end
	return true
end

-- Ustawienie funkcji zwrotnych dla NPC.
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())