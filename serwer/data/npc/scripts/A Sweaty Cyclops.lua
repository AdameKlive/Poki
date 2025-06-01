local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = 'Hum hum, huhum' },
	{ text = 'Głupiutki człowieczku' }
}

npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "melt") then
		npcHandler:say("Me topić sztabkę złota dla małego. Chcesz?", cid)
		npcHandler.topic[cid] = 10
	elseif msgcontains(msg, "yes") and npcHandler.topic[cid] == 10 then
		if player:removeItem(9971,1) then
			npcHandler:say("Łuuuusz! Gotowe!", cid)
			player:addItem(13941, 1)
		else
			npcHandler:say("Nie masz sztabki złota przy sobie.", cid)
		end
		npcHandler.topic[cid] = 0
	end

	if msgcontains(msg, "amulet") then
		if player:getStorageValue(Storage.SweetyCyclops.AmuletStatus) < 1 then
			npcHandler:say("Me potrafi zrobić cały, ale Big Ben chce 5000 złota i Big Ben potrzebuje trochę czasu, żeby to zrobić. Tak czy nie??", cid)
			npcHandler.topic[cid] = 9
		elseif player:getStorageValue(Storage.SweetyCyclops.AmuletStatus) == 1 then
			if player:getStorageValue(Storage.SweetyCyclops.AmuletTimer) + 24 * 60 * 60 < os.time() then
				npcHandler:say("Ach, mały chce amulet. Proszę! Masz! Potężny, potężny amulet mały ma. Nie wiem co, ale potężny, potężny on jest!!!", cid)
				player:addItem(8266, 1)
				player:setStorageValue(Storage.SweetyCyclops.AmuletStatus, 2)
			else
				npcHandler:say("Me potrzebuje więcej czasu!!!", cid)
			end
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("Czekaj. Me praca nie tania. Zrób mi przysługę najpierw, tak?", cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 2 then
			npcHandler:say("Me potrzebuje prezent dla kobiety. My tańczymy, więc me chcę dać jej spódnicę z kory. Ale ona duża jest. Więc potrzebuję wielu, żeby zrobić dużą. Przynieś trzy, dobrze? Me czekam.", cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.FriendsandTraders.DefaultStart, 1)
			player:setStorageValue(Storage.FriendsandTraders.TheSweatyCyclops, 1)
		elseif npcHandler.topic[cid] == 3 then
			if player:removeItem(3983, 3) then
				npcHandler:say("Dobrze, dobrze! Kobieta zadowolona będzie. Teraz me też zadowolone i pomogę ci.", cid)
				npcHandler.topic[cid] = 0
				player:setStorageValue(Storage.FriendsandTraders.TheSweatyCyclops, 2)
			end
		-- Crown Armor
		elseif npcHandler.topic[cid] == 4 then
			if player:removeItem(2487, 1) then
				npcHandler:say("Dzyń dzyń!", cid)
				npcHandler.topic[cid] = 0
				player:addItem(5887, 1)
			end
		-- Dragon Shield
		elseif npcHandler.topic[cid] == 5 then
			if player:removeItem(2516, 1) then
				npcHandler:say("Dzyń dzyń!", cid)
				npcHandler.topic[cid] = 0
				player:addItem(5889, 1)
			end
		-- Devil Helmet
		elseif npcHandler.topic[cid] == 6 then
			if player:removeItem(2462, 1) then
				npcHandler:say("Dzyń dzyń!", cid)
				npcHandler.topic[cid] = 0
				player:addItem(5888, 1)
			end
		-- Giant Sword
		elseif npcHandler.topic[cid] == 7 then
			if player:removeItem(2393, 1) then
				npcHandler:say("Dzyń dzyń!", cid)
				npcHandler.topic[cid] = 0
				player:addItem(5892, 1)
			end
		-- Soul Orb
		elseif npcHandler.topic[cid] == 8 then
			if player:getItemCount(5944) > 0 then
				local count = player:getItemCount(5944)
				for i = 1, count do
					if math.random(100) <= 1 then
						player:addItem(6529, 6)
						player:removeItem(5944, 1)
					else
						player:addItem(6529, 3)
						player:removeItem(5944, 1)
					end
				end
				npcHandler:say("Dzyń dzyń!", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 9 then
			if player:getItemCount(8262) > 0 and player:getItemCount(8263) > 0 and player:getItemCount(8264) > 0 and player:getItemCount(8265) > 0 and player:getMoney() >= 5000 then
				player:removeItem(8262, 1)
				player:removeItem(8263, 1)
				player:removeItem(8264, 1)
				player:removeItem(8265, 1)
				player:removeMoney(5000)
				player:setStorageValue(Storage.SweetyCyclops.AmuletTimer, os.time())
				player:setStorageValue(Storage.SweetyCyclops.AmuletStatus, 1)
				npcHandler:say("Cóż, cóż, zrobię to! Big Ben robi mały amulet cały wielkim młotem w wielkich rękach! Bez obaw! Wróć po tym, jak słońce uderzy w horyzont 24 razy i zapytaj mnie o amulet.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 11 then
			if player:removeItem(5880, 1) then
				player:setStorageValue(Storage.hiddenCityOfBeregar.GearWheel, player:getStorageValue(Storage.hiddenCityOfBeregar.GearWheel) + 1)
				player:addItem(9690, 1)
			else
				npcHandler:say("Mały nie ma rud żelaza.", cid)
			end
			npcHandler.topic[cid] = 0
		end

	-- Crown Armor
	elseif msgcontains(msg, "uth'kean") then
		if player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) < 1 then
			npcHandler:say("Bardzo szlachetny. Błyszczący. Mi się podoba. Ale psuje się tak szybko. Me potrafi zrobić ze zbroi. Mały chce się wymieniać?", cid)
			npcHandler.topic[cid] = 1
		elseif player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) == 1 then
			npcHandler:say("Mały przyniesie trzy spódnice z kory?", cid)
			npcHandler.topic[cid] = 3
		elseif player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) == 2 then
			npcHandler:say("Bardzo szlachetny. Błyszczący. Mi się podoba. Ale psuje się tak szybko. Me potrafi zrobić ze zbroi. Mały chce się wymieniać?", cid)
			npcHandler.topic[cid] = 4
		end
	-- Dragon Shield
	elseif msgcontains(msg, "uth'lokr") then
		if player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) < 1 then
			npcHandler:say("Ognista stal to jest. Potrzebuje oddechu zielonych, żeby stopić. Albo czerwonych jeszcze lepiej. Me potrafi zrobić z tarczy. Mały chce się wymieniać?", cid)
			npcHandler.topic[cid] = 1
		elseif player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) == 1 then
			npcHandler:say("Mały przyniesie trzy spódnice z kory?", cid)
			npcHandler.topic[cid] = 3
		elseif player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) == 2 then
			npcHandler:say("Ognista stal to jest. Potrzebuje oddechu zielonych, żeby stopić. Albo czerwonych jeszcze lepiej. Me potrafi zrobić z tarczy. Mały chce się wymieniać?", cid)
			npcHandler.topic[cid] = 5
		end
	-- Devil Helmet
	elseif msgcontains(msg, "za'ralator") then
		if player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) < 1 then
			npcHandler:say("Piekielna stal to jest. Przeklęta i zła. Niebezpieczna w pracy. Me potrafi zrobić z diabelskiego hełmu. Mały chce się wymieniać?", cid)
			npcHandler.topic[cid] = 1
		elseif player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) == 1 then
			npcHandler:say("Mały przyniesie trzy spódnice z kory?", cid)
			npcHandler.topic[cid] = 3
		elseif player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) == 2 then
			npcHandler:say("Piekielna stal to jest. Przeklęta i zła. Niebezpieczna w pracy. Me potrafi zrobić z diabelskiego hełmu. Mały chce się wymieniać?", cid)
			npcHandler.topic[cid] = 6
		end
	-- Giant Sword
	elseif msgcontains(msg, "uth'prta") then
		if player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) < 1 then
			npcHandler:say("Dobre żelazo to jest. Me przyjaciele używają tego dużo do walki. Me potrafi zrobić z broni. Mały chce się wymieniać?", cid)
			npcHandler.topic[cid] = 1
		elseif player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) == 1 then
			npcHandler:say("Mały przyniesie trzy spódnice z kory?", cid)
			npcHandler.topic[cid] = 3
		elseif player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) == 2 then
			npcHandler:say("Dobre żelazo to jest. Me przyjaciele używają tego dużo do walki. Me potrafi zrobić z broni. Mały chce się wymieniać?", cid)
			npcHandler.topic[cid] = 7
		end
	-- Soul Orb
	elseif msgcontains(msg, "soul orb") then
		if player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) < 1 then
			npcHandler:say("Uh. Me potrafi zrobić trochę paskudnych pocisków z kul dusz. Mały chce wymienić wszystkie?", cid)
			npcHandler.topic[cid] = 1
		elseif player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) == 1 then
			npcHandler:say("Mały przyniesie trzy spódnice z kory?", cid)
			npcHandler.topic[cid] = 3
		elseif player:getStorageValue(Storage.FriendsandTraders.TheSweatyCyclops) == 2 then
			npcHandler:say("Uh. Me potrafi zrobić trochę paskudnych pocisków z kul dusz. Mały chce wymienić wszystkie?", cid)
			npcHandler.topic[cid] = 8
		end
	elseif msgcontains(msg, "gear wheel") then
		if player:getStorageValue(Storage.hiddenCityOfBeregar.GoingDown) > 0 and player:getStorageValue(Storage.hiddenCityOfBeregar.GearWheel) > 3 then
			npcHandler:say("Uh. Me potrafi zrobić trochę kół zębatych z rud żelaza. Mały chce wymienić?", cid)
			npcHandler.topic[cid] = 11
		end
	end
	return true
end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "Jestem kowalem."})
keywordHandler:addKeyword({'smith'}, StdModule.say, {npcHandler = npcHandler, text = "Praca ze stalą to me zajęcie."})
keywordHandler:addKeyword({'steel'}, StdModule.say, {npcHandler = npcHandler, text = "Wielu rodzajów. Jak {Mesh Kaha Rogh'}, {Za'Kalortith}, {Uth'Byth}, {Uth'Morc}, {Uth'Amon}, {Uth'Maer}, {Uth'Doon}, i {Zatragil}."})
keywordHandler:addKeyword({'zatragil'}, StdModule.say, {npcHandler = npcHandler, text = "Najstarsi używają sennego srebra do różnych rzeczy. Teraz starożytni przeważnie zniknęli. Większość nie wie o tym."})
keywordHandler:addKeyword({'uth\'doon'}, StdModule.say, {npcHandler = npcHandler, text = "To jest wysoka stal zwana. Tylko mali, mali wiedzą, jak ją zrobić."})
keywordHandler:addKeyword({'za\'kalortith'}, StdModule.say, {npcHandler = npcHandler, text = "To jest złe. To demoniczne żelazo. Żaden dobry cyklop nie idzie tam, gdzie można je znaleźć, i potrzebuje złego płomienia, żeby stopić."})
keywordHandler:addKeyword({'mesh kaha rogh'}, StdModule.say, {npcHandler = npcHandler, text = "Stal, która śpiewa, gdy jest kuta. Nikt nie wie, gdzie ją dziś znaleźć."})
keywordHandler:addKeyword({'uth\'byth'}, StdModule.say, {npcHandler = npcHandler, text = "Niedobre do robienia rzeczy. Zła stal to jest. Ale pożera magię, więc użyteczna jest."})
keywordHandler:addKeyword({'uth\'maer'}, StdModule.say, {npcHandler = npcHandler, text = "Jasna stal to jest. Dużo sztuki z niej zrobiono. Czarodzieje zbyt leniwi i boją się dużo zaczarować."})
keywordHandler:addKeyword({'uth\'amon'}, StdModule.say, {npcHandler = npcHandler, text = "Żelazo serca z serca wielkiej, starej góry, znalezione bardzo głęboko. Mali, mali zaciekle bronią. Nie chcą, żeby było używane do rzeczy innych niż święte."})
keywordHandler:addKeyword({'ab\'dendriel'}, StdModule.say, {npcHandler = npcHandler, text = "Me rodzice mieszkali tu, zanim miasto powstało. Mnie nie obchodzą mali."})
keywordHandler:addKeyword({'lil\' lil\''}, StdModule.say, {npcHandler = npcHandler, text = "Mali, mali są tacy zabawni. Często rozmawiamy."})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = "Pewnego dnia pójdę i zobaczę."})
keywordHandler:addKeyword({'teshial'}, StdModule.say, {npcHandler = npcHandler, text = "To jedna z elfickich rodzin czy coś takiego. Mnie nie rozumiem małych i ich interesów."})
keywordHandler:addKeyword({'cenath'}, StdModule.say, {npcHandler = npcHandler, text = "To jedna z elfickich rodzin czy coś takiego. Mnie nie rozumiem małych i ich interesów."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "Mnie ludzie nazywają Bencthyclthrtrprr. Mali mnie nazywają Big Ben."})
keywordHandler:addKeyword({'god'}, StdModule.say, {npcHandler = npcHandler, text = "Milcz. Me nie chce słuchać."})
keywordHandler:addKeyword({'fire sword'}, StdModule.say, {npcHandler = npcHandler, text = "Czy mały chce wymienić Ognisty Miecz?"})
keywordHandler:addKeyword({'dragon shield'}, StdModule.say, {npcHandler = npcHandler, text = "Czy mały chce wymienić Smoczą Tarczę?"})
keywordHandler:addKeyword({'sword of valor'}, StdModule.say, {npcHandler = npcHandler, text = "Czy mały chce wymienić Miecz Waleczności?"})
keywordHandler:addKeyword({'warlord sword'}, StdModule.say, {npcHandler = npcHandler, text = "Czy mały chce wymienić Miecz Watażki?"})
keywordHandler:addKeyword({'minotaurs'}, StdModule.say, {npcHandler = npcHandler, text = "Oni byli przyjaciółmi z me rodzicami. Dużo zanim elfy tu były, często odwiedzali. Już tu nie przychodzą."})
keywordHandler:addKeyword({'elves'}, StdModule.say, {npcHandler = npcHandler, text = "Me nie walczę z nimi, oni nie walczą z me."})
keywordHandler:addKeyword({'excalibug'}, StdModule.say, {npcHandler = npcHandler, text = "Me chciałbym umieć zrobić taką broń."})
keywordHandler:addKeyword({'cyclops'}, StdModule.say, {npcHandler = npcHandler, text = "Me ludzie nie mieszkają tu dużo. Większość jest daleko."})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Hum Humm! Witaj, mały |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Żegnaj, mały.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Żegnaj, mały.")
npcHandler:addModule(FocusModule:new())