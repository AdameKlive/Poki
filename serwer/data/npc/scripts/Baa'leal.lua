local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local condition = Condition(CONDITION_FIRE)
condition:setParameter(CONDITION_PARAM_DELAYED, 1)
condition:addDamage(150, 2000, -10) -- Zadaje 150 obrażeń co 2 sekundy przez 10 ticków

local function greetCallback(cid, message)
	local player = Player(cid)
	-- Jeśli gracz nie ma warunku OGNIA i nie mówi "djanni'hah", otrzymuje ogień.
	if not player:getCondition(CONDITION_FIRE) and not msgcontains(message, 'djanni\'hah') then
		player:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONAREA)
		player:addCondition(condition)
		npcHandler:say('Bierz to!', cid)
		return false
	end

	-- Zmienia wiadomość powitalną w zależności od postępu misji.
	if player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission01) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, 'Znasz kod, człowieku! Bardzo dobrze... Co chcesz, |PLAYERNAME|?')
	else
		npcHandler:setMessage(MESSAGE_GREET, 'Nadal żyjesz, |PLAYERNAME|? No, czego chcesz?')
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	local missionProgress = player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission01)
	if msgcontains(msg, 'mission') then
		if missionProgress < 1 then
			npcHandler:say({
				'Każda misja i operacja to kluczowy krok do naszego zwycięstwa! ...',
				'A skoro już o tym mowa ...',
				'Ponieważ nie jesteś dżinem, jest coś, w czym mógłbyś nam pomóc. Jesteś zainteresowany, człowieku?'
			}, cid)
			npcHandler.topic[cid] = 1 -- Ustawia temat na 1 (oferowanie misji)

		elseif isInArray({1, 2}, missionProgress) then
			npcHandler:say('Znalazłeś złodzieja naszych zapasów?', cid)
			npcHandler.topic[cid] = 2 -- Ustawia temat na 2 (pytanie o złodzieja)
		else
			npcHandler:say('Rozmawiałeś już z Alesarem? Ma dla ciebie inną misję!', cid)
		end

	elseif npcHandler.topic[cid] == 1 then -- Odpowiedź na pytanie o zainteresowanie misją
		if msgcontains(msg, 'yes') then
			npcHandler:say({
				'Cóż... Dobrze. Może jesteś tylko człowiekiem, ale wydajesz się mieć odpowiedniego ducha. ...',
				'Słuchaj! Ponieważ nasza baza operacyjna znajduje się w tym odizolowanym miejscu, polegamy na dostawach z zewnątrz. Te zapasy są dla nas kluczowe, aby wygrać wojnę. ...',
				'Niestety, zdarzyło się, że część naszych zapasów zniknęła w drodze do tej twierdzy. Na początku myśleliśmy, że to Marid, ale raporty wywiadowcze sugerują inne wyjaśnienie. ...',
				'Wierzymy teraz, że to człowiek stał za kradzieżą! ...',
				'Jego tożsamość jest nadal nieznana, ale powiedziano nam, że złodziej uciekł do ludzkiej osady zwanej Carlin. Chcę, żebyś go odnalazł i zdał mi raport. Nikt nie zadziera z Efreet i przeżywa, by opowiedzieć historię! ...',
				'Teraz idź! Udaj się do północnego miasta Carlin! Miej oczy otwarte i rozejrzyj się za czymś, co może dać ci wskazówkę!'
			}, cid)
			player:setStorageValue(Storage.DjinnWar.EfreetFaction.Start, 1) -- Ustawia storage startu misji
			player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission01, 1) -- Ustawia postęp misji na 1

		elseif msgcontains(msg, 'no') then
			npcHandler:say('W końcu jesteś tylko człowiekiem.', cid)
		end
		npcHandler.topic[cid] = 0 -- Resetuje temat

	elseif npcHandler.topic[cid] == 2 then -- Odpowiedź na pytanie o złodzieja
		if msgcontains(msg, 'yes') then
			npcHandler:say('W końcu! Jakie jest więc jego imię?', cid)
			npcHandler.topic[cid] = 3 -- Ustawia temat na 3 (pytanie o imię)

		elseif msgcontains(msg, 'no') then
			npcHandler:say('Więc idź do Carlin i szukaj go! Szukaj czegoś, co może dać ci wskazówkę!', cid)
			npcHandler.topic[cid] = 0 -- Resetuje temat
		end

	elseif npcHandler.topic[cid] == 3 then -- Odpowiedź na pytanie o imię złodzieja
		if msgcontains(msg, 'partos') then
			if missionProgress ~= 2 then -- Sprawdza, czy misja jest na odpowiednim etapie
				npcHandler:say('Hm... Nie sądzę. Wróć do Thais i kontynuuj poszukiwania!', cid)
			else
				npcHandler:say({
					'Znalazłeś złodzieja! Doskonała robota, żołnierzu! Dobrze ci idzie - jak na człowieka, to jest. Oto - weź to jako nagrodę. ...',
					'Ponieważ udowodniłeś, że jesteś zdolnym żołnierzem, mamy dla ciebie kolejną misję. ...',
					'Jeśli jesteś zainteresowany, idź do Alesara i zapytaj go o to.'
				}, cid)
				player:addMoney(600) -- Daje nagrodę
				player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission01, 3) -- Ustawia postęp misji na 3
			end

		else
			npcHandler:say('Hm... Nie sądzę. Wróć do Thais i kontynuuj poszukiwania!', cid)
		end
		npcHandler.topic[cid] = 0 -- Resetuje temat
	end
	return true
end

npcHandler:setMessage(MESSAGE_FAREWELL, 'Spocznij, żołnierzu!') -- Wiadomość pożegnalna

npcHandler:setCallback(CALLBACK_GREET, greetCallback) -- Ustawia funkcję dla powitania
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback) -- Ustawia funkcję dla domyślnych wiadomości

local focusModule = FocusModule:new()
focusModule:addGreetMessage('hi')
focusModule:addGreetMessage('hello')
focusModule:addGreetMessage('djanni\'hah') -- Dodaje specjalne słowo powitalne
npcHandler:addModule(focusModule)