local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function greetCallback(cid)
	-- Sprawdza, czy gracz jest na etapie 27 linii zadań "Wrath of the Emperor"
	if Player(cid):getStorageValue(Storage.WrathoftheEmperor.Questline) == 27 then
		npcHandler:setMessage(MESSAGE_GREET, "ZzzzZzzZz...chrrr...") -- NPC śpi
	else
		npcHandler:setMessage(MESSAGE_GREET, "Witaj, {wędrowcze}.") -- Standardowe powitanie
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	-- Jeśli NPC nie jest skoncentrowany na graczu, ignoruj wiadomość
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)

	-- Sprawdza, czy gracz jest na etapie 27 linii zadań "Wrath of the Emperor"
	if player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 27 then
		-- Tajne słowo i sprawdzenie mikstury
		if(msg == "SOLOSARASATIQUARIUM") and player:getStorageValue(Storage.WrathoftheEmperor.InterdimensionalPotion) == 1 then
			npcHandler:say({
				"Smocze sny są złote. ...",
				"Otacza cię rozległa ciemność, jakby ciężka kurtyna zamykała się przed Twoimi oczami. Po tym, co wydaje się minutami unoszenia się w pustce, masz wrażenie, jakby przed Tobą otwierała się dziura w ciemności. ...",
				"Dziura staje się większa, nie możesz zamknąć oczu. Niewyobrażalna czerń. Głebsza i ciemniejsza niż jakakolwiek pustka, jaką możesz sobie wyobrazić, wciąga cię w nią. ...",
				"Czujesz, jakbyś nie mógł już oddychać. W tej samej sekundzie, gdy tracisz świadomość, czujesz, jakby cała ciężkość wokół ciebie uniosła się. ...",
				"Nurkujesz w ocean szmaragdowego światła. Czując się jak nowo narodzony, kolor wokół ciebie jest niemal przytłaczający. Niezliczone obiekty wszystkich kształtów i rozmiarów przelatują obok Ciebie. Ścigając się ze sobą, miliony zderzają się w oddali. ..",
				"Głośność gigantycznego spektaklu wokół Ciebie ogłusza Cię, a mimo to chłoniesz wszystkie dźwięki wokół Ciebie. ...",
				"Gdy kilka dużych przeszkód odsuwa się bezpośrednio przed Tobą, w zasięgu wzroku pojawia się intensywnie jasne centrum. Chociaż nie możesz dostrzec, jak szybko się poruszasz, Twoje tempo wydaje się zbyt wolne. ...",
				"Ciągle zwalniając, w końcu zbliżasz się do środka tego chaosu zielonych tonów. ...",
				"Gdy się do niego zbliżasz, otaczają Cię żółtawe odcienie pomarańczy, wyłaniają się łagodniejsze kształty i niemal zapominasz o poprzednim zamieszaniu. W ciepłym komforcie widzisz, co leży w sercu tego wszystkiego. ...",
				"Majestatyczny smok we śnie jest otoczony czymś, co wydaje się ciepłem i energią tysiąca słońc. Spokój tego widoku sprawia, że delikatnie się uśmiechasz. ...",
				"Czujesz idealną mieszankę radości, współczucia i nagłego spokoju. Jasne, żółte wrażenia topazu, pomarańczy i bieli witają Cię na ostatnim przystanku Twojej podróży. ...",
				"Smocze sny są złote. ...",
				"Znajdujesz się w smoczym śnie. Możesz się {rozejrzeć} lub {iść} w określonym kierunku. Możesz także {wziąć} lub {użyć} przedmiotu. Wpisz {pomoc}, aby wyświetlić te informacje w dowolnym momencie."
			}, cid)
			npcHandler.topic[cid] = 1 -- Zmienia temat rozmowy
		-- Komenda "help" w śnie
		elseif(msg:lower() == "help" and npcHandler.topic[cid] > 0 and npcHandler.topic[cid] < 34) then
			npcHandler:say("Znajdujesz się w smoczym śnie. Możesz się {rozejrzeć} lub {iść} w określonym kierunku. Możesz także {wziąć} lub {użyć} przedmiotu. Wpisz {pomoc}, aby wyświetlić te informacje w dowolnym momencie.", cid)
		-- Poniżej znajdują się reakcje na różne słowa kluczowe, które prowadzą gracza przez "smoczy sen"
		elseif(msg:lower() == "west" and npcHandler.topic[cid] == 1) then
			npcHandler:say("Idąc na zachód, dostrzegasz zwiększoną ilość onyksu na ziemi.", cid)
			npcHandler.topic[cid] = 2
		elseif(msg:lower() == "take attachment" and npcHandler.topic[cid] == 2) then
			npcHandler:say("Ostrożnie podnosisz onyksowe mocowanie z gniazda. Jest lżejsze, niż się spodziewałeś.", cid)
			npcHandler.topic[cid] = 3
		elseif(msg:lower() == "east" and npcHandler.topic[cid] == 3) then
			npcHandler:say("Wracasz na płaskowyż na wschodzie.", cid)
			npcHandler.topic[cid] = 4
		elseif(msg:lower() == "south" and npcHandler.topic[cid] == 4) then
			npcHandler:say("Wędrujesz na południe, mijając po lewej stronie duże obeliski ze szmaragdu, a po prawej rozłożyste drzewa z topazu.", cid)
			npcHandler.topic[cid] = 5
		elseif(msg:lower() == "take stand" and npcHandler.topic[cid] == 5) then
			npcHandler:say("Gdy wyrywasz solidny stojak z gniazda i zabierasz go ze sobą, duża brama otwiera się z ogłuszającym hukiem.", cid)
			npcHandler.topic[cid] = 6
		elseif(msg:lower() == "east" and npcHandler.topic[cid] == 6) then
			npcHandler:say("Wzdychasz na widok dużej otwartej bramy, przechodząc przez nią, by udać się dalej na wschód.", cid)
			npcHandler.topic[cid] = 7
		elseif(msg:lower() == "take model" and npcHandler.topic[cid] == 7) then
			npcHandler:say("Sięgasz po mały, samotny układ połączonych małych domów i wkładasz go do kieszeni.", cid)
			npcHandler.topic[cid] = 8
		elseif(msg:lower() == "take emeralds" and npcHandler.topic[cid] == 8) then
			npcHandler:say("Bierzesz szmaragd ze stosu.", cid)
			npcHandler.topic[cid] = 9
		elseif(msg:lower() == "west" and npcHandler.topic[cid] == 9) then
			npcHandler:say("Wracasz przez półprzezroczystą bramę na zachód.", cid)
			npcHandler.topic[cid] = 10
		elseif(msg:lower() == "north" and npcHandler.topic[cid] == 10) then
			npcHandler:say("Wracasz na północ na płaskowyż.", cid)
			npcHandler.topic[cid] = 11
		elseif(msg:lower() == "east" and npcHandler.topic[cid] == 11) then
			npcHandler:say("Podróżujesz na wschód przez kilka dużych szmaragdowych urwisk i krawędzi. Wszelkiego rodzaju klejnoty są rozrzucone wzdłuż Twojej ścieżki.", cid)
			npcHandler.topic[cid] = 12
		elseif(msg:lower() == "take rubies" and npcHandler.topic[cid] == 12) then
			npcHandler:say("Bierzesz dość duży rubin ze stosu przed sobą.", cid)
			npcHandler.topic[cid] = 13
		elseif(msg:lower() == "north" and npcHandler.topic[cid] == 13) then
			npcHandler:say("Idziesz na północ, mijając niezliczone kamienie w karmazynowym morzu kamieni pod Twoimi stopami.", cid)
			npcHandler.topic[cid] = 14
		elseif(msg:lower() == "use attachment" and npcHandler.topic[cid] == 14) then
			npcHandler:say({
				"Unikając jasnego światła, ostrożnie wkładasz mocowanie na dziwne gniazdo. ...",
				"Gdy Twoje oczy dostosowują się do nagłego zmniejszenia jasności, widzisz, jak gigantyczne skrzydła bramy przed Tobą odsuwają się na boki. Możesz również dostrzec coś błyszczącego na ziemi."
			}, cid)
			npcHandler.topic[cid] = 15
		elseif(msg:lower() == "take mirror" and npcHandler.topic[cid] == 15) then
			npcHandler:say("Podnosisz lustro z ziemi.", cid)
			npcHandler.topic[cid] = 16
		elseif(msg:lower() == "north" and npcHandler.topic[cid] == 16) then
			npcHandler:say({
				"Twoja droga na północ jest otwarta. Mijasz gigantyczne skrzydła bramy po lewej i prawej stronie, gdy posuwasz się naprzód. Po około godzinie podróży słyszysz lekki szelest w oddali. Zmierzasz dalej w tym kierunku. ...",
				"Szelest staje się głośniejszy, aż dochodzisz do małej wydmy. Za nią znajdujesz źródło hałasu."
			}, cid)
			npcHandler.topic[cid] = 17
		elseif(msg:lower() == "use model" and npcHandler.topic[cid] == 17) then
			npcHandler:say({
				"Wypadasz i rzucasz modelem daleko w wodę. Ponieważ nic się nie dzieje, odwracasz się plecami do oceanu. ...",
				"W tej samej chwili, gdy schodzisz z wydmy, aby wrócić na południe, promienie światła rozbłyskują nad Twoją głową w fali uderzeniowej, która sprawia, że staczasz się z reszty wzgórza. ...",
				"Słychać też głębokie, głośne szorowanie przez kilka minut gdzieś daleko na zachodzie."
			}, cid)
			npcHandler.topic[cid] = 18
		elseif(msg:lower() == "south" and npcHandler.topic[cid] == 18) then
			npcHandler:say("Wracasz całą drogę w dół wydmy i przez bramę na południe.", cid)
			npcHandler.topic[cid] = 19
		elseif(msg:lower() == "south" and npcHandler.topic[cid] == 19) then
			npcHandler:say("Wracasz do karmazynowego morza rubinów na południu.", cid)
			npcHandler.topic[cid] = 20
		elseif(msg:lower() == "west" and npcHandler.topic[cid] == 20) then
			npcHandler:say("Wracasz na płaskowyż na zachodzie.", cid)
			npcHandler.topic[cid] = 21
		elseif(msg:lower() == "west" and npcHandler.topic[cid] == 21) then
			npcHandler:say("Idąc na zachód, dostrzegasz zwiększoną ilość onyksu na ziemi.", cid)
			npcHandler.topic[cid] = 22
		elseif(msg:lower() == "north" and npcHandler.topic[cid] == 22) then
			npcHandler:say("Kontynuujesz podróż przez jałowe morze kamieni szlachetnych na północ.", cid)
			npcHandler.topic[cid] = 23
		elseif(msg:lower() == "west" and npcHandler.topic[cid] == 23) then
			npcHandler:say("Zostawiasz za sobą ogromną otwartą bramę i idziesz na zachód.", cid)
			npcHandler.topic[cid] = 24
		elseif(msg:lower() == "bastesh" and npcHandler.topic[cid] == 24) then
			npcHandler:say("Ta ogromna statua Bastesh wykonana jest z onyksu i zasiada na dużym płaskowyżu, do którego prowadzą rozłożyste schody. Trzyma w dłoniach duży {szafir}.", cid)
			npcHandler.topic[cid] = 25
		elseif(msg:lower() == "take sapphire" and npcHandler.topic[cid] == 25) then
			npcHandler:say("Ostrożnie usuwasz szafir z uścisku Bastesh.", cid)
			npcHandler.topic[cid] = 26
		elseif(msg:lower() == "east" and npcHandler.topic[cid] == 26) then
			npcHandler:say("Wracasz na wschód i na płaskowyż.", cid)
			npcHandler.topic[cid] = 27
		elseif(msg:lower() == "south" and npcHandler.topic[cid] == 27) then
			npcHandler:say("Wracasz na południe, do miejsca z onyksowym punktem widokowym.", cid)
			npcHandler.topic[cid] = 28
		elseif(msg:lower() == "east" and npcHandler.topic[cid] == 28) then
			npcHandler:say("Wracasz na płaskowyż na wschodzie.", cid)
			npcHandler.topic[cid] = 29
		elseif(msg:lower() == "use stand" and npcHandler.topic[cid] == 29) then
			npcHandler:say("Wkładasz stojak w małe zagłębienie, które znajdujesz w pobliżu środka płaskowyżu.", cid)
			npcHandler.topic[cid] = 30
		elseif(msg:lower() == "use ruby" and npcHandler.topic[cid] == 30) then
			npcHandler:say("Gdy rubin wpada w zagłębienie, intensywna czerwień kamienia wzmaga się tysiąckrotnie. Obawiasz się, że zranisz oczy i natychmiast odwracasz wzrok. Promień wydaje się być skierowany do centrum płaskowyżu z zadziwiającą precyzją.", cid)
			npcHandler.topic[cid] = 31
		elseif(msg:lower() == "use sapphire" and npcHandler.topic[cid] == 31) then
			npcHandler:say("Gdy szafir wpada w zagłębienie, głęboki błękit kamienia wzmaga się tysiąckrotnie. Obawiasz się, że zranisz oczy i natychmiast odwracasz wzrok. Promień wydaje się być skierowany do centrum płaskowyżu z zadziwiającą precyzją.", cid)
			npcHandler.topic[cid] = 32
		elseif(msg:lower() == "use emerald" and npcHandler.topic[cid] == 32) then
			npcHandler:say("Gdy szmaragd wpada w zagłębienie, żywa zieleń kamienia wzmaga się tysiąckrotnie. Obawiasz się, że zranisz oczy i natychmiast odwracasz wzrok. Promień wydaje się być skierowany do centrum płaskowyżu z zadziwiającą precyzją.", cid)
			npcHandler.topic[cid] = 33
		elseif(msg:lower() == "use mirror" and npcHandler.topic[cid] == 33) then
			npcHandler:say({
				"Z zakrytymi oczami i unikając bezpośredniego kontaktu z promieniami, wkładasz lustro do stojaka. ...",
				"Instynktownie biegniesz do większego szmaragdowego urwiska w pobliżu wzniesienia, by znaleźć schronienie. Zaledwie kilka sekund po tym, jak znalazłeś solidne schronienie, głęboki, ciemny szum zaczyna wirować w powietrzu. ...",
				"Sekundy mijają, a szum staje się głośniejszy. Hałas jest obezwładniający, zagłusza wszystkie inne dźwięki wokół ciebie. Gdy z bólu zakrywasz uszy, szum wybucha w ogłuszający ryk. ...",
				"Podnosisz głowę ponad krawędź szmaragdu, by zerknąć na to, co się dzieje. ...",
				"Ręka wydaje się zmienić w pięść. W oddali widać teraz niewyraźny zarys istoty zbyt dużej, by Twoje oczy mogły uzyskać ostrzejszy widok jej głowy. ...",
				"Łącząc promienie, lustro kieruje czyste białe światło bezpośrednio w stronę miejsca, w którym zakładasz, że znajduje się twarz istoty. ...",
				"Ryk zmienia się w krzyk, wszystko wokół ciebie wydaje się ściskać. Gdy mocno przyciskasz się do urwiska, wszystko milknie i w ułamku sekundy ciemna istota rozpływa się w wybuchach czerni. Budzisz się."
			}, cid)
			player:setStorageValue(Storage.WrathoftheEmperor.Questline, 28)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission09, 2) -- Questlog, Wrath of the Emperor "Mission 09: The Sleeping Dragon"
			npcHandler.topic[cid] = 0 -- Resetuje temat rozmowy
		end
	-- Sprawdza, czy gracz jest na etapie 28 linii zadań "Wrath of the Emperor"
	elseif player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 28 then
		if(msgcontains(msg, "wędrowcze")) then
			npcHandler:say("Nazywam cię wędrowcem. Podróżowałeś przez moje sny. W końcu uwolniłeś mój umysł. Mój umysł przyjął cię, i ja też cię przyjmę.", cid)
			npcHandler.topic[cid] = 40 -- Zmienia temat rozmowy
		elseif(msgcontains(msg, "misja") and npcHandler.topic[cid] == 40) then
			npcHandler:say({
				"Aaaah... w końcu wolny. Hmmm. ...",
				"Zakładam, że musisz przejść przez bramę, aby dotrzeć do złoczyńcy. Mogę ci pomóc, jeśli mi zaufasz, wędrowcze. Podzielę się z tobą częścią mojego umysłu, co powinno umożliwić ci przejście przez bramę. ...",
				"Ta procedura może być wyczerpująca. Czy jesteś gotów, by otrzymać mój klucz?"
			}, cid)
			npcHandler.topic[cid] = 41 -- Zmienia temat rozmowy
		elseif(msgcontains(msg, "tak") and npcHandler.topic[cid] == 41) then
			npcHandler:say({
				"SAETHELON TORILUN GARNUM. ...",
				"ŚPIJ. ...",
				"ZYSK. ...",
				"WSTAŃ. ...",
				"Transfer zakończony sukcesem. ...",
				"Jesteś teraz gotów, by wkroczyć do królestwa złoczyńcy. Jestem wdzięczny za Twoją pomoc, wędrowcze. Jeśli będziesz szukał mojej rady, użyj tego amuletu, który Ci przekazuję. Bo mój duch będzie Cię prowadził, gdziekolwiek jesteś. Obyś cieszył się bezpieczną przyszłością, zwyciężysz."
			}, cid)
			player:setStorageValue(Storage.WrathoftheEmperor.Questline, 29)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission10, 1) -- Questlog, Wrath of the Emperor "Mission 10: A Message of Freedom"
			player:addItem(11260, 1) -- Dodaje przedmiot do ekwipunku gracza
			player:addAchievement('Wayfarer') -- Dodaje osiągnięcie graczowi
			npcHandler.topic[cid] = 0 -- Resetuje temat rozmowy
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())