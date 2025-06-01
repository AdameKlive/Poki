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
	-- DOŁĄCZANIE
	if msgcontains(msg, "join") then
		if player:getStorageValue(Storage.ExplorerSociety.QuestLine) < 1 then
			npcHandler:say("Chcesz dołączyć do Towarzystwa Eksploratorów?", cid)
			npcHandler.topic[cid] = 1
		end
	-- Nowa Granica (The New Frontier)
	elseif msgcontains(msg, "farmine") then
		if player:getStorageValue(Storage.TheNewFrontier.Questline) == 15 then
			npcHandler:say("Och tak, interesujący temat. Mieliśmy o tym odkryciu ożywione dyskusje. Ale czego właściwie chcesz?", cid)
			npcHandler.topic[cid] = 30
		end
	elseif msgcontains(msg, "bluff") then
		if npcHandler.topic[cid] == 30 then
			if player:getStorageValue(Storage.TheNewFrontier.BribeExplorerSociety) < 1 then
				npcHandler:say({
					"Te historie są po prostu niesamowite! Mężczyźni z twarzami na brzuchu zamiast głów, mówisz? I kury znoszące złote jaja? A najbardziej niesamowite jest to źródło młodości, o którym wspomniałeś! ...",
					"Natychmiast wyślę kilku naszych najbardziej oddanych odkrywców, aby to sprawdzili!"
				}, cid)
				player:setStorageValue(Storage.TheNewFrontier.BribeExplorerSociety, 1)
				--Questlog, The New Frontier Quest "Misja 05: Rozkręcanie Interesu"
				player:setStorageValue(Storage.TheNewFrontier.Mission05, player:getStorageValue(Storage.TheNewFrontier.Mission05) + 1)
			end
		end

	-- KAMIENIE SPEKTRALNE (SPECTRAL STONE)
	elseif msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 51 then
			npcHandler:say("Ach, tak! Powiedz naszemu koledze eksploratorowi, że dokumenty są już w drodze.", cid)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 52)
			npcHandler.topic[cid] = 0
		end
	-- KAMIENIE SPEKTRALNE

	-- SPRAWDZANIE MISJI
	elseif msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.ExplorerSociety.QuestLine) > 3 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) < 27 then
			npcHandler:say("Misje dostępne dla Twojej rangi to: polowanie na motyle, zbieranie roślin i dostawa lodu.", cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) > 26 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) <  35 then
			npcHandler:say("Misje dostępne dla Twojej rangi to: urna jaszczurów, sekrety bonelordów i orkowy proch.", cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) > 34 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) <  44 then
			npcHandler:say("Misje dostępne dla Twojej rangi to: elficka poezja, kamień pamięci i runiczne zapiski.", cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 44 then
			npcHandler:say("Towarzystwo Eksploratorów potrzebuje dużej pomocy w badaniach nad podróżami astralnymi. Czy jesteś gotów pomóc?", cid)
			npcHandler.topic[cid] = 26
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 46 then
			npcHandler:say("Czy masz ze sobą zebrany ektoplazmę?", cid)
			npcHandler.topic[cid] = 28
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 47 then
			npcHandler:say({
				"Badania nad ektoplazmą robią postępy. Teraz potrzebujemy jakiegoś spektralnego artykułu. Nasi naukowcy uważają, że spektralna suknia byłaby idealnym obiektem do ich badań ...",
				"Zła wiadomość jest taka, że jedynym źródłem takiej sukni jest królowa banshee. Czy odważysz się jej szukać?"
			}, cid)
			npcHandler.topic[cid] = 29
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 49 then
			npcHandler:say("Czy przyniosłeś suknię?", cid)
			npcHandler.topic[cid] = 30
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 50 then
			npcHandler:say({
				"Dzięki obiektom, które dostarczyłeś, nasi badacze poczynią stałe postępy. Nadal brakuje nam niektórych wyników testów od innych odkrywców ...",
				"Proszę, udaj się do naszej bazy w Northport i poproś ich o przesłanie nam najnowszych raportów badawczych. Następnie wróć tutaj i zapytaj o nowe misje."
			}, cid)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 51)
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 52 then
			npcHandler:say("Raporty z Northport już do nas dotarły, a nasze postępy są zdumiewające. Myślimy, że możliwe jest stworzenie astralnego mostu między naszymi bazami. Czy jesteś zainteresowany pomocą w tym?", cid)
			npcHandler.topic[cid] = 31
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 53 then
			npcHandler:say({
				"Obie rzeźby są teraz naładowane i zharmonizowane. Teoretycznie powinieneś być w stanie podróżować w zerowym czasie z jednej bazy do drugiej ...",
				"Jednak będziesz musiał mieć przy sobie perłę orichalcum, aby użyć jej jako źródła zasilania. Zostanie ona zniszczona podczas procesu. Dam ci 6 takich pereł, a nowe możesz kupić w naszych bazach ...",
				"Ponadto, musisz być premium eksploratorem, aby korzystać z podróży astralnych. ...",
				"I pamiętaj: to mały teleport dla Ciebie, ale duży teleport dla wszystkich Tibijczyków! Oto mały prezent za Twoje wysiłki!"
			}, cid)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 54)
			player:addItem(7242, 1)
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 56 then
			npcHandler:say("Ach, przyszedłeś w samą porę. Doświadczony odkrywca jest tym, czego potrzebujemy tutaj! Chciałbyś wyruszyć dla nas na misję?", cid)
			npcHandler.topic[cid] = 32
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 57 then
			if player:removeItem(7314, 1) then
				npcHandler:say({
					"Zamrożony Władca Smoków? To jest właśnie informacja, której potrzebowaliśmy! I nawet przyniosłeś jego łuskę! Weź te 5000 złotych monet jako nagrodę. ...",
					"Ponieważ wykonałeś tak wspaniałą robotę, być może będę miał dla Ciebie kolejną misję później."
				}, cid)
				player:addItem(2152, 50)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 58)
			else
				npcHandler:say("Jeszcze nie skończyłeś...", cid)
			end
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 59 then
			npcHandler:say({
				"Ach, tak, misja. Pozwól, że opowiem Ci o czymś, co nazywa się lodową muzyką. ...",
				"Na Hrodmirze, na północ od najbardziej wysuniętego na południe obozu barbarzyńców Krimhorn, znajduje się jaskinia. ...",
				"W tej jaskini jest wodospad i wiele stalagmitów. ...",
				"Kiedy wiatr wpada do tej jaskini i uderza w stalagmity, podobno tworzy dźwięk podobny do delikatnej pieśni. ...",
				"Proszę, weź ten kryształ rezonansowy i użyj go na stalagmitach w jaskini, aby nagrać dźwięk wiatru."
			}, cid)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 60)
			player:addItem(7281, 1)
		end
	-- SPRAWDZANIE MISJI

	-- MISJA Z KILOFEM
	elseif msgcontains(msg, "pickaxe") then
		if player:getStorageValue(Storage.ExplorerSociety.QuestLine) < 4 or player:getStorageValue(Storage.ExplorerSociety.QuestLine) > 1 then
			npcHandler:say("Czy zdobyłeś żądany kilof od Uzgoda w Kazordoon?", cid)
			npcHandler.topic[cid] = 3
		end
	-- MISJA Z KILOFEM

	-- POLOWANIE NA MOTYLE
	elseif msgcontains(msg, "butterfly hunt") then
		if player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 7 then
			npcHandler:say("Misja polega na zebraniu kilku gatunków motyli, czy jesteś zainteresowany?", cid)
			npcHandler.topic[cid] = 7
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 9 then
			npcHandler:say("Czy zdobyłeś fioletowego motyla, którego szukamy?", cid)
			npcHandler.topic[cid] = 8
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 10 then
			npcHandler:say({
				"Ten zestaw do preparowania pozwoli Ci zebrać niebieskiego motyla, którego zabiłeś ...",
				"Po prostu użyj go na świeżym trupie niebieskiego motyla, zwróć mi przygotowanego motyla i daj mi raport z Twojego polowania na motyle."
			}, cid)
			npcHandler.topic[cid] = 0
			player:addItem(4865, 1)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 11)
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 12 then
			npcHandler:say("Czy zdobyłeś niebieskiego motyla, którego szukamy?", cid)
			npcHandler.topic[cid] = 9
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 13 then
			npcHandler:say({
				"Ten zestaw do preparowania pozwoli Ci zebrać czerwonego motyla, którego zabiłeś ...",
				"Po prostu użyj go na świeżym trupie czerwonego motyla, zwróć mi przygotowanego motyla i daj mi raport z Twojego polowania na motyle."
			}, cid)
			npcHandler.topic[cid] = 0
			player:addItem(4865, 1)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 14)
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 14 then
			npcHandler:say("Czy zdobyłeś czerwonego motyla, którego szukamy?", cid)
			npcHandler.topic[cid] = 10
		end
	-- POLOWANIE NA MOTYLE

	-- DOSTAWA LODU
	elseif msgcontains(msg, "ice delivery") then
		if player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 4 then
			npcHandler:say({
				"Nasze najlepsze umysły wymyśliły teorię, że głęboko pod lodową wyspą Folda można znaleźć pradawny lód. Aby udowodnić tę teorię, potrzebowalibyśmy próbki wspomnianego lodu ...",
				"Oczywiście lód szybko się topi, więc musiałbyś się pospieszyć, aby go tu przynieść ...",
				"Czy chciałbyś przyjąć tę misję?"
			}, cid)
			npcHandler.topic[cid] = 4
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 6 then
			npcHandler:say("Czy zdobyłeś lód, którego szukamy?", cid)
			npcHandler.topic[cid] = 5
		end
	-- DOSTAWA LODU

	-- ZBIERANIE ROŚLIN
	elseif msgcontains(msg, "plant collection") then
		if player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 15 then
			npcHandler:say("W tej misji wymagamy od Ciebie, abyś zdobył dla nas próbki roślin z Tiquanda. Czy chciałbyś wykonać tę misję?", cid)
			npcHandler.topic[cid] = 11
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 17 then
			npcHandler:say("Czy zdobyłeś próbkę rośliny jungle bells, której szukamy?", cid)
			npcHandler.topic[cid] = 12
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 18 then
			npcHandler:say("Użyj tego pojemnika botanika na kociołku czarownic, aby zebrać dla nas próbkę. Przynieś ją tutaj i zdaj raport ze swojej kolekcji roślin.", cid)
			npcHandler.topic[cid] = 0
			player:addItem(4869, 1)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 19)
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 20 then
			npcHandler:say("Czy zdobyłeś próbkę z kociołka czarownic, której szukamy?", cid)
			npcHandler.topic[cid] = 13
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 22 then
			npcHandler:say("Użyj tego pojemnika botanika na kociołku czarownic, aby zebrać dla nas próbkę. Przynieś ją tutaj i zdaj raport ze swojej kolekcji roślin.", cid)
			npcHandler.topic[cid] = 0
			player:addItem(4869, 1)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 23)
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 25 then
			npcHandler:say("Czy zdobyłeś próbkę gigantycznej róży dżunglowej, której szukamy?", cid)
			npcHandler.topic[cid] = 14
		end
	-- ZBIERANIE ROŚLIN

	-- URNA JASZCZURÓW
	elseif msgcontains(msg, "lizard urn") then
		if player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 26 then
			npcHandler:say("Towarzystwo Eksploratorów chciałoby zdobyć starożytną urnę, która jest swego rodzaju reliktem dla jaszczuroludzi z Tiquandy. Czy chciałbyś przyjąć tę misję?", cid)
			npcHandler.topic[cid] = 15
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 28 then
			npcHandler:say("Czy udało Ci się zdobyć starożytną urnę?", cid)
			npcHandler.topic[cid] = 16
		end
	-- URNA JASZCZURÓW

	-- SEKRETY BONELORDÓW
	elseif msgcontains(msg, "bonelord secrets") then
		if player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 29 then
			npcHandler:say({
				"Chcemy dowiedzieć się więcej o starożytnej rasie bonelordów. Wierzymy, że czarna piramida na północny wschód od Darashii została pierwotnie przez nich zbudowana ...",
				"Prosimy Cię o zbadanie ruin czarnej piramidy i poszukanie wszelkich znaków, które potwierdzą naszą teorię. Prawdopodobnie znajdziesz jakiś dokument z numerycznym językiem bonelordów ...",
				"To byłby wystarczający dowód. Czy chciałbyś przyjąć tę misję?"
			}, cid)
			npcHandler.topic[cid] = 17
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 31 then
			npcHandler:say("Czy znalazłeś jakiś dowód na to, że piramida została zbudowana przez bonelordów?", cid)
			npcHandler.topic[cid] = 18
		end
	-- SEKRETY BONELORDÓW

	-- ORKOWY PROCH
	elseif msgcontains(msg, "orc powder") then
		if player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 32 then
			npcHandler:say({
				"Powszechnie wiadomo, że orkowie z Uldereks Rock używają jakiegoś rodzaju prochu, aby zwiększyć zaciekłość swoich wilków wojennych i berserkerów ...",
				"Czego nie wiemy, to składniki tego prochu i jego wpływ na ludzi ...",
				"Chcielibyśmy więc, abyś zdobył próbkę wspomnianego prochu. Czy chcesz przyjąć tę misję?"
			}, cid)
			npcHandler.topic[cid] = 19
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 34 then
			npcHandler:say("Czy zdobyłeś trochę orkowego prochu?", cid)
			npcHandler.topic[cid] = 20
		end
	-- ORKOWY PROCH

	-- ELFIKA POEZJA
	elseif msgcontains(msg, "elven poetry") then
		if player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 35 then
			npcHandler:say({
				"Niektórzy wysoko postawieni członkowie chcieliby studiować elficką poezję. Chcą rzadkiej książki 'Pieśni Lasu' ...",
				"Z pewnością ktoś w Ab'Dendriel będzie posiadał kopię. Musiałbyś tylko popytać tam. Czy jesteś gotów przyjąć tę misję?"
			}, cid)
			npcHandler.topic[cid] = 21
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 37 then
			npcHandler:say("Czy zdobyłeś dla nas kopię 'Pieśni Lasu'?", cid)
			npcHandler.topic[cid] = 22
		end
	-- ELFIKA POEZJA

	-- KAMIEN PAMIĘCI
	elseif msgcontains(msg, "memory stone") then
		if player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 38 then
			npcHandler:say({
				"Zdobyliśmy pewną wiedzę o specjalnych kamieniach magicznych. Niektóre zaginione cywilizacje używały ich do przechowywania wiedzy i legend, tak jak my używamy książek ...",
				"Mądrość w takich kamieniach musi być ogromna, ale takie są też niebezpieczeństwa, z którymi mierzy się każda osoba, która próbuje zdobyć jeden z nich...",
				"O ile nam wiadomo, ruiny znalezione na północnym zachodzie Edron były kiedyś zamieszkane przez istoty, które używały takich kamieni. Czy masz odwagę tam pójść i zdobyć dla nas taki kamień?"
			}, cid)
			npcHandler.topic[cid] = 23
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 40 then
			npcHandler:say("Czy udało Ci się zdobyć kamień pamięci dla naszego towarzystwa?", cid)
			npcHandler.topic[cid] = 24
		end
	-- KAMIEN PAMIĘCI

	-- RUNICZNE ZAPISKI
	elseif msgcontains(msg, "rune writings") then
		if player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 41 then
			npcHandler:say({
				"Chcielibyśmy zbadać starożytne runy, które były używane przez rasę jaszczurów. Podejrzewamy pewien związek jaszczurów z założycielami Ankrahmun ...",
				"Gdzieś pod opanowanym przez małpy miastem Banuta można znaleźć lochy, które kiedyś były zamieszkane przez jaszczury...",
				"Poszukaj tam nietypowej struktury, która bardziej pasowałaby do Ankrahmun i jej grobowców. Skopiuj runy, które znajdziesz na tej strukturze...",
				"Czy sprostasz temu wyzwaniu?"
			}, cid)
			npcHandler.topic[cid] = 25
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 43 then
			npcHandler:say("Czy wykonałeś kopię starożytnych run, zgodnie z prośbą?", cid)
			npcHandler.topic[cid] = 26
		end
	-- RUNICZNE ZAPISKI

	-- EKTOPOPLAZM
	elseif msgcontains(msg, "ectoplasm") then
		if npcHandler.topic[cid] == 26 then
			npcHandler:say({
				"Świetnie. Towarzystwo szuka nowych sposobów podróżowania. Niektóre z naszych najbłyskotliwszych umysłów mają teorie na temat podróży astralnych, które chcą dalej badać ...",
				"Dlatego potrzebujemy, abyś zebrał trochę ektoplazmy z ciała ducha. Dostarczymy Ci kolektor, którego możesz użyć na ciele zabitego ducha ...",
				"Czy myślisz, że jesteś gotowy na tę misję?"
			}, cid)
			npcHandler.topic[cid] = 27
		elseif npcHandler.topic[cid] == 27 then
			npcHandler:say("Dobrze! Weź ten pojemnik i użyj go na świeżo zabitym duchu. Wróć z zebraną ektoplazmą i oddaj mi ten pojemnik ...", cid)
			npcHandler:say("Nie zgub pojemnika. Są drogie!", cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 45)
			player:addItem(4863, 1)
		elseif npcHandler.topic[cid] == 28 then
			if player:removeItem(4864, 1) then
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 47)
				npcHandler:say("Uff, nie miałem pojęcia, że ektoplazma będzie tak śmierdzieć ... och, to Ty, no, przepraszam. Dziękuję za ektoplazmę.", cid)
				npcHandler.topic[cid] = 0
			end
		end
	-- EKTOPOPLAZM

	-- SPEKTRALNA SUKNIA
	elseif msgcontains(msg, "spectral dress") then
		if npcHandler.topic[cid] == 29 then
			npcHandler:say({
				"To dość odważne. Wiemy, że prosimy o wiele. Królowa banshee mieszka w tak zwanych Ghostlands, na południowy zachód od Carlin. Plotki mówią, że jej legowisko znajduje się w najgłębszych lochach pod tym przeklętym miejscem ...",
				"Każda przemoc prawdopodobnie okaże się daremna, będziesz musiał z nią negocjować. Spróbuj zdobyć od niej spektralną suknię. Powodzenia."
			}, cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 48)
		elseif npcHandler.topic[cid] == 30 then
			if player:removeItem(4847, 1) then
				npcHandler:say("Dobrze! Poproś mnie o kolejną misję.", cid)
				npcHandler.topic[cid] = 0
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 50) -- Ustawienie na 50 po dostarczeniu sukni
			end
		end
	-- SPEKTRALNA SUKNIA

	-- KAMIENIE SPEKTRALNE (ciąg dalszy)
	elseif msgcontains(msg, "spectral portals") then
		if npcHandler.topic[cid] == 31 then
			npcHandler:say({
				"Dobrze, weź tę spektralną esencję i użyj jej na dziwnym rzeźbieniu w tym budynku, a także na odpowiednim kafelku w naszej bazie w Northport ...",
				"Gdy tylko naładujesz kafelki portali w ten sposób, zgłoś się w sprawie portali spektralnych."
			}, cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 53)
		end
	-- KAMIENIE SPEKTRALNE

	-- WYSPA SMOKÓW (ISLAND OF DRAGONS)
	elseif msgcontains(msg, "island of dragons") then
		if npcHandler.topic[cid] == 32 then
			npcHandler:say({
				"Teraz mówimy! Być może słyszałeś już o wyspie Okolnir na południe od Hrodmir. ...",
				"Okolnir jest domem nowej i zaciekłej rasy smoków, tak zwanych mrocznych smoków. Jednak nie mamy pojęcia, skąd pochodzą. ...",
				"Plotki mówią, że władcy smoków, którzy wędrowali po tej wyspie, zostali w jakiś sposób zamienieni w mroczne smoki, gdy wielki mróz pokrył Okolnir. ...",
				"Udaj się na Okolnir i spróbuj znaleźć dowód na istnienie tam władców smoków w dawnych czasach. Myślę, że stary Buddel może cię tam zabrać."
			}, cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 57)
		end
	end
	-- ODPOWIEDŹ TAK
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then -- "Do you want to join the explorer society?"
			npcHandler:say({
				"Dobrze, choć dołączenie do naszych szeregów wymaga czegoś więcej niż tylko czczej gadaniny. Aby udowodnić swoje poświęcenie dla sprawy, będziesz musiał zdobyć dla nas pewien przedmiot ...",
				"Misja powinna być prosta do wykonania. Do naszych wykopalisk zamówiliśmy solidny kilof w Kazordoon. Będziesz musiał odnaleźć handlarza Uzgoda i zdobyć dla nas kilof ...",
				"Wystarczająco proste? Czy jesteś zainteresowany tym zadaniem?"
			}, cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 2 then -- "Are you interested in this task?" (pickaxe)
			npcHandler:say("Zobaczymy, czy poradzisz sobie z tym prostym zadaniem. Zdobądź kilof od Uzgoda w Kazordoon i przynieś go do jednej z naszych baz. Zgłoś się tam w sprawie kilofa.", cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 1)
		elseif npcHandler.topic[cid] == 3 then -- "Did you get the requested pickaxe from Uzgod in Kazordoon?"
			if player:removeItem(4848, 1) then
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 4)
				npcHandler:say({
					"Doskonale, przyniosłeś dokładnie to narzędzie, którego potrzebujemy! Oczywiście było to tylko proste zadanie. Jednakże ...",
					"Oficjalnie witam Cię w Towarzystwie Eksploratorów. Od teraz możesz prosić o misje, aby poprawić swoją rangę."
				}, cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("Nie masz kilofa.", cid)
			end
		elseif npcHandler.topic[cid] == 4 then -- "Would you like to accept this mission?" (ice delivery)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 5)
			npcHandler:say({
				"Więc słuchaj uważnie: Weź ten kilof lodowy i użyj go na bloku lodu w jaskiniach pod Foldą. Zdobądź trochę lodu i przynieś go tutaj tak szybko, jak to możliwe ...",
				"Jeśli lód się roztopi, i tak zgłoś się z misją dostawy lodu. Wtedy powiem Ci, czy nadszedł czas na rozpoczęcie kolejnej misji."
			}, cid)
			npcHandler.topic[cid] = 0
			player:addItem(4856, 1)
		elseif npcHandler.topic[cid] == 5 then -- "Did you get the ice we are looking for?"
			if player:removeItem(11421, 1) then
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 7)
				npcHandler:say("W samą porę. Niestety niewiele lodu zostało, ale wystarczy. Dziękuję Ci jeszcze raz.", cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("Nie masz lodu, którego szukamy.", cid)
			end
		elseif npcHandler.topic[cid] == 6 then -- "Did it melt away?" (ice delivery failure)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 5)
			npcHandler:say("*Westchnienie* Myślę, że nadszedł czas, aby dać Ci kolejną szansę na zdobycie tego lodu. Pospiesz się tym razem.", cid)
			npcHandler.topic[cid] = 0

		-- POLOWANIE NA MOTYLE (kontynuacja)
		elseif npcHandler.topic[cid] == 7 then -- "The mission asks you to collect some species of butterflies, are you interested?"
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 8)
			npcHandler:say({
				"Ten zestaw do preparowania pozwoli Ci zebrać fioletowego motyla, którego zabiłeś ...",
				"Po prostu użyj go na świeżym trupie fioletowego motyla, zwróć mi przygotowanego motyla i daj mi raport z Twojego polowania na motyle."
			}, cid)
			npcHandler.topic[cid] = 0
			player:addItem(4865, 1)
		elseif npcHandler.topic[cid] == 8 then -- "Did you acquire the purple butterfly we are looking for?"
			if player:removeItem(4868, 1) then
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 10)
				npcHandler:say("Trochę poobijany, ale wystarczy. Dziękuję! Jeśli uważasz, że jesteś gotów, poproś o kolejne polowanie na motyle.", cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("Nie masz fioletowego motyla.", cid)
			end
		elseif npcHandler.topic[cid] == 9 then -- "Did you acquire the blue butterfly we are looking for?"
			if player:removeItem(4866, 1) then
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 13)
				npcHandler:say("Trochę poobijany, ale wystarczy. Dziękuję! Jeśli uważasz, że jesteś gotów, poproś o kolejne polowanie na motyle.", cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("Nie masz niebieskiego motyla.", cid)
			end
		elseif npcHandler.topic[cid] == 10 then -- "Did you acquire the red butterfly we are looking for?"
			if player:removeItem(4867, 1) then
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 15)
				npcHandler:say("To niezwykły gatunek, który przyniosłeś. Dziękuję! To był ostatni motyl, którego potrzebowaliśmy.", cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("Nie masz czerwonego motyla.", cid)
			end
		-- POLOWANIE NA MOTYLE

		-- ZBIERANIE ROŚLIN (kontynuacja)
		elseif npcHandler.topic[cid] == 11 then -- "In this mission we require you to get us some plant samples from Tiquandan plants. Would you like to fulfil this mission?"
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 16)
			npcHandler:say("Świetnie! Weź ten pojemnik botanika. Użyj go na roślinie jungle bells, aby zebrać dla nas próbkę. Zgłoś się w sprawie swojej kolekcji roślin, gdy odniesiesz sukces.", cid)
			npcHandler.topic[cid] = 0
			player:addItem(4869, 1)
		elseif npcHandler.topic[cid] == 12 then -- "Did you acquire the sample of the jungle bells plant we are looking for?"
			if player:removeItem(4870, 1) then
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 18)
				npcHandler:say("Rozumiem. Wydaje się, że zdobyłeś całkiem użyteczną próbkę przez czyste szczęście. Dziękuję! Po prostu powiedz mi, kiedy będziesz gotów kontynuować zbieranie roślin.", cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("Nie masz próbki rośliny jungle bells.", cid)
			end
		elseif npcHandler.topic[cid] == 13 then -- "Did you acquire the sample of the witches cauldron we are looking for?"
			if player:removeItem(4871, 1) then
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 21)
				npcHandler:say("Ach, wreszcie. Zaczęłem się zastanawiać, co tak długo trwało. Ale dziękuję! Kolejna świetna próbka, rzeczywiście. Po prostu powiedz mi, kiedy będziesz gotów kontynuować zbieranie roślin.", cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("Nie masz próbki z kociołka czarownic.", cid)
			end
		elseif npcHandler.topic[cid] == 14 then -- "Did you acquire the sample of the giant jungle rose we are looking for?"
			if player:removeItem(4872, 1) then
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 26)
				npcHandler:say("Cóż za urocza próbka! Dzięki temu zakończyłeś swoje misje zbierania roślin.", cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("Nie masz próbki gigantycznej róży dżunglowej.", cid)
			end
		-- ZBIERANIE ROŚLIN

		-- URNA JASZCZURÓW (kontynuacja)
		elseif npcHandler.topic[cid] == 15 then -- "Would you like to accept this mission?" (lizard urn)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 27)
			player:setStorageValue(Storage.ExplorerSociety.urnDoor, 1)
			npcHandler:say({
				"Masz w sobie ducha prawdziwego poszukiwacza przygód! Na południowym wschodzie Tiquandy znajduje się mała osada jaszczuroludzi ...",
				"Pod nowo wybudowaną tam świątynią jaszczury ukrywają wspomnianą urnę. Nasze próby zdobycia tego przedmiotu zakończyły się niepowodzeniem ...",
				"Być może Ty odniesiesz większy sukces."
			}, cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 16 then -- "Did you manage to get the ancient urn?"
			if player:removeItem(4858, 1) then
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 29)
				npcHandler:say("Tak, to jest cenna relikwia, której tak długo szukaliśmy. Wykonałeś wspaniałą robotę, dziękuję.", cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("Nie masz starożytnej urny.", cid)
			end
		-- URNA JASZCZURÓW

		-- SEKRETY BONELORDÓW (kontynuacja)
		elseif npcHandler.topic[cid] == 17 then -- "Would you like to accept this mission?" (bonelord secrets)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 30)
			player:setStorageValue(Storage.ExplorerSociety.bonelordsDoor, 1)
			npcHandler:say({
				"Doskonale! Udaj się więc do miasta Darashia, a następnie na północny wschód w kierunku piramidy ...",
				"Jeśli zostały jakieś dokumenty, prawdopodobnie znajdziesz je w katakumbach poniżej. Powodzenia!"
			}, cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 18 then -- "Have you found any proof that the pyramid was built by bonelords?"
			if player:removeItem(4857, 1) then
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 32)
				npcHandler:say("Udało Ci się! Doskonale! Świat naukowy będzie wstrząśnięty tym odkryciem!", cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("Nie masz dowodu, że piramida została zbudowana przez bonelordów.", cid)
			end
		-- SEKRETY BONELORDÓW

		-- ORKOWY PROCH (kontynuacja)
		elseif npcHandler.topic[cid] == 19 then -- "Do you want to accept this mission?" (orc powder)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 33)
			player:setStorageValue(Storage.ExplorerSociety.orcDoor, 1)
			npcHandler:say({
				"Jesteś odważną duszą. O ile nam wiadomo, orkowie utrzymują coś w rodzaju ośrodka szkoleniowego na wzgórzu na północny wschód od ich miasta ...",
				"Tam powinieneś znaleźć wiele ich wilków wojennych i, miejmy nadzieję, także trochę orkowego prochu. Powodzenia!"
			}, cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 20 then -- "Did you acquire some of the orcish powder?"
			if player:removeItem(15389, 1) then
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 35)
				npcHandler:say("Naprawdę to zdobyłeś? Niesamowite! Dziękuję za Twoje wysiłki.", cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("Nie masz orkowego prochu.", cid)
			end
		-- ORKOWY PROCH

		-- ELFIKA POEZJA (kontynuacja)
		elseif npcHandler.topic[cid] == 21 then -- "Are you willing to accept this mission?" (elven poetry)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 36)
			npcHandler:say("Doskonale. Ta misja jest łatwa, ale niemniej jednak kluczowa. Udaj się do Ab'Dendriel i zdobądź książkę.", cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 22 then -- "Did you acquire a copy of 'Songs of the Forest' for us?"
			if player:removeItem(4855, 1) then
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 38)
				npcHandler:say("Pozwól, że spojrzę! Tak, to jest to, czego chcieliśmy. Kopia 'Pieśni Lasu'. Nie będę zadawał pytań o te plamy krwi.", cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("Nie masz kopii 'Pieśni Lasu'.", cid)
			end
		-- ELFIKA POEZJA

		-- KAMIEN PAMIĘCI (kontynuacja)
		elseif npcHandler.topic[cid] == 23 then -- "Do you have the heart to go there and to get us such a stone?"
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 39)
			player:setStorageValue(Storage.ExplorerSociety.edronDoor, 1)
			npcHandler:say("W ruinach na północno-zachodnim Edron powinieneś być w stanie znaleźć kamień pamięci. Powodzenia.", cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 24 then -- "Were you able to acquire a memory stone for our society?"
			if player:removeItem(4852, 1) then
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 41)
				npcHandler:say("Bezbłędny kamień pamięci! Niewiarygodne! Rozszyfrowanie jego działania zajmie lata, ale co za okazja dla nauki, dziękuję!", cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("Nie masz kamienia pamięci.", cid)
			end
		-- KAMIEN PAMIĘCI

		-- RUNICZNE ZAPISKI (kontynuacja)
		elseif npcHandler.topic[cid] == 25 then -- "Are you up to that challenge?"
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 42)
			npcHandler:say("Doskonale! Weź ten papier kalkowy i użyj go na obiekcie, który tam znajdziesz, aby stworzyć kopię starożytnych run.", cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 26 then -- "Did you create a copy of the ancient runes as requested?"
			if player:removeItem(4853, 1) then
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 44)
				npcHandler:say("Trochę pomarszczony, ale wystarczy. Dzięki ponownie.", cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("Nie masz kopii starożytnych run.", cid)
			end
		-- RUNICZNE ZAPISKI

		-- EKTOPOPLAZM (kontynuacja)
		elseif npcHandler.topic[cid] == 26 then -- "Are you willing to help?" (astral travel research)
			npcHandler:say({
				"Świetnie. Towarzystwo szuka nowych sposobów podróżowania. Niektóre z naszych najbłyskotliwszych umysłów mają teorie na temat podróży astralnych, które chcą dalej badać ...",
				"Dlatego potrzebujemy, abyś zebrał trochę ektoplazmy z ciała ducha. Dostarczymy Ci kolektor, którego możesz użyć na ciele zabitego ducha ...",
				"Czy myślisz, że jesteś gotowy na tę misję?"
			}, cid)
			npcHandler.topic[cid] = 27
		elseif npcHandler.topic[cid] == 27 then -- "Do you think you are ready for that mission?"
			npcHandler:say("Dobrze! Weź ten pojemnik i użyj go na świeżo zabitym duchu. Wróć z zebraną ektoplazmą i oddaj mi ten pojemnik ...", cid)
			npcHandler:say("Nie zgub pojemnika. Są drogie!", cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 45)
			player:addItem(4863, 1)
		elseif npcHandler.topic[cid] == 28 then -- "Do you have some collected ectoplasm with you?"
			if player:removeItem(4864, 1) then
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 47)
				npcHandler:say("Uff, nie miałem pojęcia, że ektoplazma będzie tak śmierdzieć ... och, to Ty, no, przepraszam. Dziękuję za ektoplazmę.", cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("Nie masz zebranej ektoplazmy.", cid)
			end
		-- EKTOPOPLAZM

		-- SPEKTRALNA SUKNIA (kontynuacja)
		elseif npcHandler.topic[cid] == 29 then -- "Do you dare to seek her out?" (banshee queen)
			npcHandler:say({
				"To dość odważne. Wiemy, że prosimy o wiele. Królowa banshee mieszka w tak zwanych Ghostlands, na południowy zachód od Carlin. Plotki mówią, że jej legowisko znajduje się w najgłębszych lochach pod tym przeklętym miejscem ...",
				"Każda przemoc prawdopodobnie okaże się daremna, będziesz musiał z nią negocjować. Spróbuj zdobyć od niej spektralną suknię. Powodzenia."
			}, cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 48)
		elseif npcHandler.topic[cid] == 30 then -- "Did you bring the dress?"
			if player:removeItem(4847, 1) then
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 50)
				npcHandler:say("Dobrze! Poproś mnie o kolejną misję.", cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("Nie masz sukni.", cid)
			end
		-- SPEKTRALNA SUKNIA

		-- PORTALE SPEKTRALNE (kontynuacja)
		elseif npcHandler.topic[cid] == 31 then -- "Are you interested to assist us with this?" (astral bridge)
			npcHandler:say({
				"Dobrze, weź tę spektralną esencję i użyj jej na dziwnym rzeźbieniu w tym budynku, a także na odpowiednim kafelku w naszej bazie w Northport ...",
				"Gdy tylko naładujesz kafelki portali w ten sposób, zgłoś się w sprawie portali spektralnych."
			}, cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 53)
		end
	-- ODPOWIEDŹ TAK

	-- ODPOWIEDŹ NIE
	elseif msgcontains(msg, "no") then
		if npcHandler.topic[cid] == 5 then -- "Did you get the ice we are looking for?" (response to !ice delivery)
			npcHandler:say("Czy się roztopił?", cid)
			npcHandler.topic[cid] = 6
		end
	-- ODPOWIEDŹ NIE
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())