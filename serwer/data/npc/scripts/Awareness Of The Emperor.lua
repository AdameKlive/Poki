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

	if msgcontains(msg, "mission") then
		local player = Player(cid)
		-- Sprawdza, czy gracz jest na odpowiednim etapie questu i statusie bossa.
		if player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 30 and player:getStorageValue(Storage.WrathoftheEmperor.BossStatus) == 5 then
			npcHandler:say({
				"Wzmocniona siła wężowego boga rozrywa ziemię na strzępy. Używa moich kryształów w odwrotny sposób, aby wysysać siłę życiową z ziemi i jej mieszkańców, by zasilić swoją moc. ...",
				"Będę opierał się jego wpływowi najlepiej, jak potrafię i spowalniał ten proces. Będziesz musiał jednak walczyć z jego cielesną inkarnacją. ...",
				"Jest jeszcze słaby i zdezorientowany. Możesz mieć szansę - to nasza jedyna szansa. Wyślę cię do punktu, do którego kierowana jest siła życiowa. Nie mam jednak pojęcia, gdzie to może być. ...",
				"Prawdopodobnie będziesz musiał walczyć z pewnym rodzajem naczynia, którego używa wężowy bóg. Nawet jeśli go pokonasz, prawdopodobnie tylko osłabi to węża. ...",
				"Być może będziesz musiał stoczyć kilka walk z inkarnacjami, aż wężowy bóg zostanie wystarczająco wyczerpany. Wtedy użyj przeciwko niemu mocy własnego berła węża. Użyj go na jego zwłokach, aby ogłosić swoje zwycięstwo. ...",
				"Przygotuj się na walkę swojego życia! Jesteś gotowy?"
			}, cid)
			npcHandler.topic[cid] = 1 -- Ustawia topic na 1, oczekując odpowiedzi "yes"
		-- Sprawdza, czy gracz ukończył quest.
		elseif player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 32 then
			npcHandler:say({
				"A więc opanowałeś kryzys, który wywołałeś swoją głupotą. Powinienem cię zgnieść za twoje zaangażowanie tu i teraz. ...",
				"Ale taki czyn sprowadziłby mnie do twojego barbarzyńskiego poziomu i tylko wzmocniłby korupcję, która niszczy ziemię, którą posiadam. Dlatego nie tylko oszczędzę twoje nędzne życie, ale pokażę ci hojność smoczego cesarza. ...",
				"Nagrodzę cię ponad twoje najśmielsze marzenia! ...",
				"Przyznaję ci trzy skrzynie - wypełnione po brzegi platynowymi monetami, dom w mieście, w którym możesz zamieszkać, zestaw najlepszej zbroi, jaką Zao ma do zaoferowania, i szkatułkę z niekończącą się maną. ...",
				"Porozmawiaj z magistratem Izsh w ministerstwie o swojej nagrodzie. A teraz odejdź, zanim zmienię zdanie!"
			}, cid)
			player:setStorageValue(Storage.WrathoftheEmperor.Questline, 33) -- Ustawia questline na ukończony
			player:setStorageValue(Storage.WrathoftheEmperor.Mission12, 0) -- Ustawia status misji "Just Rewards" na 0 w questlogu
		end
	-- Obsługa odpowiedzi "yes"
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			local player = Player(cid)
			player:setStorageValue(Storage.WrathoftheEmperor.Questline, 31) -- Ustawia questline na kolejny etap
			player:setStorageValue(Storage.WrathoftheEmperor.Mission11, 1) -- Ustawia status misji "Payback Time" na 1 w questlogu
			npcHandler:say("Niech tak będzie!", cid)
			npcHandler.topic[cid] = 0 -- Resetuje topic
		end
	end
	return true
end

-- Ustawia callback dla domyślnych wiadomości.
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Dodaje moduł FocusModule, który zarządza skupieniem NPC na graczu.
npcHandler:addModule(FocusModule:new())