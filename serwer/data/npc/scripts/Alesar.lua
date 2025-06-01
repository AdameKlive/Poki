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
	local missionProgress = player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission02)
	
	-- Obsługa słowa kluczowego 'mission'
	if msgcontains(msg, 'mission') then
		if player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission01) == 3 then
			if missionProgress < 1 then
				npcHandler:say({
					'Więc Baa\'leal myśli, że nadajesz się do misji dla nas? ...',
					'Chyba starzeje się, powierzając tak ważną misję ludzkiej szumowinie, jaką jesteś. ...',
					'Osobiście nie rozumiem, dlaczego nie zostałeś zarżnięty już przy bramach. ...',
					'Mniejsza z tym. Czy jesteś gotów wyruszyć na niebezpieczną misję dla nas?'
				}, cid)
				npcHandler.topic[cid] = 1

			elseif isInArray({1, 2}, missionProgress) then
				npcHandler:say('Znalazłeś łzę Daramana?', cid)
				npcHandler.topic[cid] = 2
			else
				npcHandler:say('Nie zapomnij porozmawiać z Malorem w sprawie następnej misji.', cid)
			end
		end

	-- Obsługa odpowiedzi gracza, gdy topic[cid] jest ustawiony na 1
	elseif npcHandler.topic[cid] == 1 then
		if msgcontains(msg, 'yes') then
			npcHandler:say({
				'W porządku więc, człowieku. Czy kiedykolwiek słyszałeś o \'Łzach Daramana\'? ...',
				'To cenne klejnoty wykonane z jakiegoś nieznanego niebieskiego minerału, posiadające ogromną magiczną moc. ...',
				'Jeśli chcesz dowiedzieć się więcej o tych klejnotach, nie zapomnij odwiedzić naszej biblioteki. ...',
				'W każdym razie, jeden z nich wystarczy, aby stworzyć tysiące naszych potężnych dżinowych ostrzy. ...',
				'Niestety, mój ostatni klejnot pękł i dlatego nie mogę już tworzyć nowych ostrzy. ...',
				'Z tego co wiem, jest tylko jedno miejsce, gdzie można znaleźć te klejnoty - wiem na pewno, że Maridowie mają przynajmniej jeden z nich. ...',
				'Cóż... krótko mówiąc, twoja misja polega na zakradnięciu się do Ashta\'daramai i kradzieży go. ...',
				'Nie trzeba dodawać, że Maridowie nie będą zbyt chętni, by się z nim rozstać. Postaraj się nie zginąć, dopóki nie dostarczysz mi kamienia.'
			}, cid)
			player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission02, 1)

		elseif msgcontains(msg, 'no') then
			npcHandler:say('Więc nie.', cid)
		end
		npcHandler.topic[cid] = 0

	-- Obsługa odpowiedzi gracza, gdy topic[cid] jest ustawiony na 2
	elseif npcHandler.topic[cid] == 2 then
		if msgcontains(msg, 'yes') then
			if player:getItemCount(2346) == 0 or missionProgress ~= 2 then
				npcHandler:say('Jak się spodziewałem. Nie masz kamienia. Czy mam ci ponownie wyjaśnić twoją misję?', cid)
				npcHandler.topic[cid] = 1
			else
				npcHandler:say({
					'Więc ci się udało? Naprawdę udało ci się ukraść Łzę Daramana? ...',
					'Niesamowite, jak wy, ludzie, jesteście po prostu niemożliwi do pozbycia się. Nawiasem mówiąc, tę cechę charakteru macie wspólną z wieloma owadami i innymi szkodnikami. ...',
					'Nieważne. Nie znoszę tego mówić, ale oddałeś nam przysługę, człowieku. Ten klejnot dobrze nam posłuży. ...',
					'Baa\'leal chce, żebyś porozmawiał z Malorem w sprawie jakiejś nowej misji. ...',
					'Wygląda na to, że udało ci się przedłużyć swoją długość życia - tylko na trochę dłużej.'
				}, cid)
				player:removeItem(2346, 1)
				player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission02, 3)
				npcHandler.topic[cid] = 0
			end

		elseif msgcontains(msg, 'no') then
			npcHandler:say('Jak się spodziewałem. Nie masz kamienia. Czy mam ci ponownie wyjaśnić twoją misję?', cid)
			npcHandler.topic[cid] = 1
		end
	end
	return true
end

-- Funkcja wywoływana przy próbie handlu
local function onTradeRequest(cid)
	-- Sprawdza, czy gracz osiągnął odpowiedni etap misji, aby móc handlować.
	if Player(cid):getStorageValue(Storage.DjinnWar.EfreetFaction.Mission03) ~= 3 then
		npcHandler:say('Bez szans, człowieku. Malor nie chce, żebym handlował z nieznajomymi.', cid)
		return false
	end

	return true
end

-- Ustawianie domyślnych wiadomości NPC
npcHandler:setMessage(MESSAGE_GREET, 'Czego ode mnie chcesz, |PLAYERNAME|?')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Nareszcie.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Nareszcie.')
npcHandler:setMessage(MESSAGE_SENDTRADE, 'Do usług, po prostu przejrzyj mój towar.')

-- Ustawianie funkcji zwrotnych (callbacków)
npcHandler:setCallback(CALLBACK_ONTRADEREQUEST, onTradeRequest)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

-- Moduł zarządzania fokusem i wiadomościami powitalnymi
local focusModule = FocusModule:new()
focusModule:addGreetMessage('hi')
focusModule:addGreetMessage('hello')
focusModule:addGreetMessage('djanni\'hah')
npcHandler:addModule(focusModule)