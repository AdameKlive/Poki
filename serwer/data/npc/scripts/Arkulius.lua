local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = "...paradoks arytmetyczny ma taką samą wartość w sensie metafizycznym, zatem..." },
	{ text = "Och, mój Boże! Alverus!! Czy ty naprawdę...?!?! Muszę to przeliczyć, żeby upewnić się, że nie popełniłem błędu." },
	{ text = "<mamrocze>" },
	{ text = "...minimalne odchylenie kwadratowe mogłoby spowodować przemieszczenie, w rzeczywistości..." },
	{ text = "...możliwe byłoby przetransportowanie sfery do miejsca docelowego, gdzie..." },
	{ text = "Tak, to to! Cząstki elementarne odpowiadają... odpowiadają... NIEWIARYGODNE!!!" }
}

npcHandler:addModule(VoiceModule:new(voices))

local greetMsg = {
	"...jeśli oczekiwana stała jest wyższa niż... Hmmm, kim jesteś?? Czego chcesz?",
	"...wtedy mógłbym przekształcić zaklęcie, aby zakrzywić... Jak ktokolwiek może oczekiwać, że będę pracował w takich warunkach?? Czego chcesz?",
	"...jeśli moje obliczenia są poprawne, będę w stanie ożywić... Arrggghh!! Czego chcesz?"
}

local function greetCallback(cid)
	npcHandler:setMessage(MESSAGE_GREET, greetMsg[math.random(#greetMsg)])
	npcHandler.topic[cid] = 0
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "alverus") then
		npcHandler:say({
			"To stało się, gdy przeprowadzał eksperyment dotyczący tworzenia elementarnych {sanktuariów}. Do tej pory mam gęsią skórkę na samą myśl o tym. ...",
			"Musisz wiedzieć o procesie tworzenia elementarnego sanktuarium, aby to w pełni zrozumieć, ale nie chcę teraz wchodzić w szczegóły. ...",
			"W każdym razie, jego zaklęcie miało inny rezultat, niż planował. Przypadkowo stworzył Ice Overlorda, czysty, żywy elementarny lód, który zamroził go w mgnieniu oka."
		}, cid)
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, "shrine") then
		npcHandler:say({
			"Tworzenie elementarnych sanktuariów to naprawdę złożona sprawa. Właściwie są to węzły, miejsca, gdzie odpowiadająca im sfera żywiołów jest bardzo blisko. ...",
			"Samo sanktuarium jest jak portal między naszym światem a sferą {żywiołów} i umożliwia nam korzystanie z energii żywiołów, która z niej wypływa."
		}, cid)
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, "sphere") and player:getLevel() >= 80 then
		npcHandler:say({
			"Znamy cztery sfery: lodu, ognia, ziemi i energii. ...<mamrocze> Hmmm, powinienem zapytać czy nie?....A niech to! Skoro już wiesz o sferach ...",
			"Znalazłem sposób, aby je odwiedzić. To BARDZO niebezpieczne i jest spora szansa, że nie wrócisz, ALE jeśli Ci się uda, zapiszesz się w historii!!! Zapytaj mnie o tę {misję}, jeśli jesteś zainteresowany."
		}, cid)
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, "mission") or msgcontains(msg, "quest") then
		local value = player:getStorageValue(Storage.ElementalSphere.QuestLine)
		if value < 1 then
			if player:getLevel() >= 80 then
				if player:isSorcerer() then
					npcHandler:say({
						"Dobrze, słuchaj uważnie: Przede wszystkim, musisz zebrać 20 zaklętych rubinów, aby udać się do sfery ognia. Głęboko pod akademią, piętro niżej niż sanktuaria żywiołów, znajduje się maszyna. Umieść tam klejnoty i aktywuj ją. ...",
						"Kiedy już tam dotrzesz, znajdź sposób na zebranie elementarnego ognia w jakiejkolwiek formie. Na pewno napotkasz żywiołaki ognia, ale nie wiem, jak ten ogień jest przechowywany. ...",
						"W każdym razie, powinien istnieć sposób, aby użyć tego elementarnego ognia i wzmocnić jednego z żywiołaków. Jeśli moje obliczenia są poprawne, stworzysz Fire Overlorda, który, mam nadzieję, będzie składał się z jakiejś 'skoncentrowanej' formy ognia lub czegoś podobnego. ...",
						"TEGO właśnie potrzebujemy!! Zgadzasz się na to?"
					}, cid)
				elseif player:isDruid() then
					npcHandler:say({
						"Dobrze, słuchaj uważnie: Przede wszystkim, musisz zebrać 20 zaklętych szmaragdów, aby udać się do sfery ziemi. Głęboko pod akademią, piętro niżej niż sanktuaria żywiołów, znajduje się maszyna. Umieść tam klejnoty i aktywuj ją. ...",
						"Kiedy już tam dotrzesz, znajdź sposób na zebranie elementarnej ziemi w jakiejkolwiek formie. Na pewno napotkasz żywiołaki ziemi, ale nie wiem, jak ta ziemia jest przechowywana. ...",
						"W każdym razie, powinien istnieć sposób, aby użyć tej elementarnej ziemi i wzmocnić jednego z żywiołaków. Jeśli moje obliczenia są poprawne, stworzysz Earth Overlorda, który, mam nadzieję, będzie składał się z jakiejś 'skoncentrowanej' formy ziemi lub czegoś podobnego. ...",
						"TEGO właśnie potrzebujemy!! Zgadzasz się na to?"
					}, cid)
				elseif player:isPaladin() then
					npcHandler:say({
						"Dobrze, słuchaj uważnie: Przede wszystkim, musisz zebrać 20 zaklętych szafirów, aby udać się do sfery lodu. Głęboko pod akademią, piętro niżej niż sanktuaria żywiołów, znajduje się maszyna. Umieść tam klejnoty i aktywuj ją. ...",
						"Kiedy już tam dotrzesz, znajdź sposób na zebranie elementarnego lodu w jakiejkolwiek formie. Na pewno napotkasz żywiołaki lodu, ale nie wiem, jak ten lód jest przechowywany. ...",
						"W każdym razie, powinien istnieć sposób, aby użyć tego elementarnego lodu i wzmocnić jednego z żywiołaków. Jeśli moje obliczenia są poprawne, stworzysz Ice Overlorda, który, mam nadzieję, będzie składał się z jakiejś 'skoncentrowanej' formy lodu lub czegoś podobnego. ...",
						"TEGO właśnie potrzebujemy!! Zgadzasz się na to?"
					}, cid)
				elseif player:isKnight() then
					npcHandler:say({
						"Dobrze, słuchaj uważnie: Przede wszystkim, musisz zebrać 20 zaklętych ametystów, aby udać się do sfery energii. Głęboko pod akademią, piętro niżej niż sanktuaria żywiołów, znajduje się maszyna. Umieść tam klejnoty i aktywuj ją. ...",
						"Kiedy już tam dotrzesz, znajdź sposób na zebranie elementarnej energii w jakiejkolwiek formie. Na pewno napotkasz żywiołaki energii, ale nie wiem, jak ta energia jest przechowywana. ...",
						"W każdym razie, powinien istnieć sposób, aby użyć tej energii i wzmocnić jednego z żywiołaków. Jeśli moje obliczenia są poprawne, stworzysz Energy Overlorda, który, mam nadzieję, będzie składał się z jakiejś 'skoncentrowanej' formy energii. ...",
						"TEGO właśnie potrzebujemy!! Zgadzasz się na to?"
					}, cid)
				end
			else
				npcHandler:say("Przepraszam, to zadanie jest bardzo niebezpieczne i potrzebuję do niego doświadczonych ludzi.", cid)
				npcHandler.topic[cid] = 0
				return false
			end
			npcHandler.topic[cid] = 1
		elseif value == 1 then
			if player:getItemCount(player:isSorcerer() and 8304 or player:isDruid() and 8305 or player:isPaladin() and 8300 or player:isKnight() and 8306) > 0 then
				player:setStorageValue(Storage.ElementalSphere.QuestLine, 2)
				npcHandler:say({
					"Imponujące!! Pozwól mi spojrzeć.......Ach, " .. (player:isSorcerer() and "WIECZNY PŁOMIEŃ! Teraz musisz znaleźć rycerza, druida i paladyna, którzy również ukończyli to pierwsze zadanie. ..." or player:isDruid() and "GLEBA MATKA! Teraz musisz znaleźć rycerza, paladyna i maga, którzy również ukończyli to pierwsze zadanie. ..." or player:isPaladin() and "DOSKONAŁY KRYSZTAŁ LODU! Teraz musisz znaleźć rycerza, druida i maga, którzy również ukończyli to pierwsze zadanie. ..." or player:isKnight() and "CZYSTA ENERGIA! Teraz musisz znaleźć druida, paladyna i maga, którzy również ukończyli to pierwsze zadanie. ..."),
					"Zejdź znowu do piwnicy. Przygotowałem pokój pod akademią, gdzie powinno być bezpiecznie. Twoim zadaniem jest naładowanie maszyn substancjami żywiołów i przywołanie PANA ŻYWIOŁÓW. ...",
					"Kiedy użyjesz obsydianowego noża na jego zwłokach, mam nadzieję, że zdobędziesz trochę cennej neutralnej materii. To jedyny sposób, aby ożywić mojego drogiego przyjaciela Alverusa!!"
				}, cid)
			else
				npcHandler:say("Potrzebujesz jakiegoś czystego elementarnego materiału od " .. (player:isSorcerer() and "Fire" or player:isDruid() and "Earth" or player:isPaladin() and "Ice" or player:isKnight() and "Energy") .. " Overlorda. Wróć, gdy to zdobędziesz.", cid)
			end
			npcHandler.topic[cid] = 0
		elseif value == 2 then
			if player:removeItem(8310, 1) then
				npcHandler:say("WSPANIALE!! Natychmiast rozpocznę badania. Jeśli wyjdzie tak, jak się spodziewam, Alverus wkrótce zostanie wskrzeszony!! Oto, weź to jako nagrodę i spróbuj zebrać więcej tej substancji. Obiecuję, złożę ci dobrą ofertę.", cid)
				player:addItem(player:isSorcerer() and 8867 or player:isDruid() and 8869 or player:isPaladin() and 8853 or player:isKnight() and 8883, 1)
				player:setStorageValue(Storage.ElementalSphere.QuestLine, 3)
			end
		end
	elseif npcHandler.topic[cid] == 1 and msgcontains(msg, "tak") then
		player:setStorageValue(Storage.ElementalSphere.QuestLine, 1)
		npcHandler:say("Dobrze, nie trać czasu! Wróć tu, gdy będziesz miał przedmiot żywiołów!", cid)
		npcHandler.topic[cid] = 0
	end
	return true
end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "Jak śmiesz mnie o to pytać?!? Jestem Arkulius - Mistrz Żywiołów, DYREKTOR tej akademii!!"})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "Jestem Arkulius - Mistrz Żywiołów, dyrektor tej akademii."})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = "Mam lepsze rzeczy do roboty niż pomaganie tobie. Widzisz tamten lodowy posąg? Mój drogi przyjaciel Alverus musi zostać wskrzeszony!"})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = "Czas jest iluzją i jest dla mnie całkowicie nieistotny."})
keywordHandler:addKeyword({'weapon'}, StdModule.say, {npcHandler = npcHandler, text = "Bronie są dla tych, którzy nie potrafią używać swoich głów, a raczej tego, co jest W ICH głowach. Bez obrazy <kaszle>."}) -- < Knight; FIXME !!!
keywordHandler:addKeyword({'pits of inferno'}, StdModule.say, {npcHandler = npcHandler, text = "Yeye, wierzę, że czujesz się prawie jak w domu wśród tych wszystkich bezmózgich stworzeń!"})

npcHandler:setMessage(MESSAGE_WALKAWAY, "Do widzenia i proszę, trzymaj się z daleka, dobrze?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Nareszcie! Dobre rzeczy przychodzą do tych, którzy czekają.")
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())