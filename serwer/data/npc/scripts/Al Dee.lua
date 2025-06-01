local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

-- Głosy NPC (losowe wypowiedzi)
local voices = {
	{ text = 'Szukasz najlepszych ofert? Zapraszam do mojego sklepu!' },
	{ text = 'Czujesz się zagubiony? Zawsze możesz zapytać mnie o ogólne wskazówki!' },
	{ text = 'Narzędzia i ogólny sprzęt u Al Dee\'go!' },
	{ text = 'Nie wyruszaj na przygodę bez liny i pochodni! Kup swoje zapasy tutaj!' }
}
npcHandler:addModule(VoiceModule:new(voices))

-- Podstawowe słowa kluczowe i ich odpowiedzi
keywordHandler:addKeyword({'hint'}, StdModule.rookgaardHints, {npcHandler = npcHandler})
keywordHandler:addKeyword({'sell'}, StdModule.say, {npcHandler = npcHandler, text = 'Po prostu poproś mnie o {trade}, a zobaczysz, co od ciebie kupuję.'})
keywordHandler:addKeyword({'stuff'}, StdModule.say, {npcHandler = npcHandler, text = 'Po prostu poproś mnie o {trade}, a zobaczysz moje oferty.'})
keywordHandler:addAliasKeyword({'wares'})
keywordHandler:addAliasKeyword({'offer'})
keywordHandler:addAliasKeyword({'buy'})

keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'Jeśli potrzebujesz ogólnego {equipment}, po prostu poproś mnie o {trade}. Mogę również udzielić ci ogólnych {hints} dotyczących gry.'})
keywordHandler:addAliasKeyword({'information'})

keywordHandler:addKeyword({'equip'}, StdModule.say, {npcHandler = npcHandler, text = 'Jako poszukiwacz przygód, zawsze powinieneś mieć co najmniej {backpack}, {rope}, {shovel}, {weapon}, {armor} i {shield}.'})
keywordHandler:addAliasKeyword({'tools'})

keywordHandler:addKeyword({'how', 'are', 'you'}, StdModule.say, {npcHandler = npcHandler, text = 'U mnie w porządku. Bardzo się cieszę, że jesteś moim klientem.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'Jestem kupcem. Po prostu poproś mnie o {trade}, a zobaczysz moje oferty.'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'Nazywam się Al Dee, ale możesz mi mówić Al. Czy mogę cię zainteresować {trade}?'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'Jest około |TIME|. Przykro mi, nie mam zegarków na sprzedaż. Chcesz kupić coś innego?'})
keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = 'Jeśli chcesz stawić czoła potworom w {dungeons}, potrzebujesz {weapons} i {armor} od lokalnych {merchants}.'})
keywordHandler:addKeyword({'dungeon'}, StdModule.say, {npcHandler = npcHandler, text = 'Jeśli chcesz odkrywać lochy, takie jak {sewers}, musisz {equip} się niezbędnym sprzętem, który sprzedaję. To {vital} w najgłębszym sensie tego słowa.'})
keywordHandler:addKeyword({'sewer'}, StdModule.say, {npcHandler = npcHandler, text = 'Och, nasz system kanalizacyjny jest bardzo prymitywny - jest tak prymitywny, że roi się w nim od {rats}. Ale rzeczy, które sprzedaję, są od nich bezpieczne. Po prostu poproś mnie o {trade}, żeby je zobaczyć!'})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = 'Król zachęcał handlowców do podróży tutaj, ale tylko ja odważyłem się podjąć ryzyko, a było to ryzyko!'})
keywordHandler:addKeyword({'bug'}, StdModule.say, {npcHandler = npcHandler, text = 'Błędy dręczą tę wyspę, ale moje towary są wolne od błędów, całkowicie wolne od błędów.'})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = 'Pewnego dnia wrócę na kontynent jako bogaty, bardzo bogaty człowiek!'})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = 'Thais to zatłoczone miasto.'})
keywordHandler:addKeyword({'mainland'}, StdModule.say, {npcHandler = npcHandler, text = 'Czy zastanawiałeś się kiedyś, co to za \'główny ląd\', o którym ludzie mówią? Cóż, gdy osiągniesz poziom 8, powinieneś porozmawiać z {oracle}. Następnie możesz wybrać {profession} i odkrywać o wiele więcej Tibii.'})
keywordHandler:addKeyword({'weapon'}, StdModule.say, {npcHandler = npcHandler, text = 'Och, przepraszam, ale nie handluję bronią. To sprawa {Obi\'s} lub {Lee\'Delle\'s}. Mogę zaoferować ci {pick} w zamian za {small axe}, jeśli akurat taką posiadasz.'})
keywordHandler:addKeyword({'armor'}, StdModule.say, {npcHandler = npcHandler, text = 'Zbroje i tarcze można kupić u {Dixi\'s} lub u {Lee\'Delle\'s}. Dixi prowadzi ten sklep w pobliżu {Obi\'s}.'})
keywordHandler:addKeyword({'shield'}, StdModule.say, {npcHandler = npcHandler, text = 'Zbroje i tarcze można kupić u {Dixi\'s} lub u {Lee\'Delle\'s}. Dixi prowadzi ten sklep w pobliżu {Obi\'s}.'})
keywordHandler:addKeyword({'cooki'}, StdModule.say, {npcHandler = npcHandler, text = 'Jeśli chcesz znaleźć kogoś, kto może chcieć kupić twoje ciasteczka, powinieneś spotkać Lily.'})
keywordHandler:addKeyword({'blueberr'}, StdModule.say, {npcHandler = npcHandler, text = 'Jagody rosną na krzewach. Są dość powszechne w Tibii. Po prostu zbieraj je z krzaka, jeśli potrzebujesz przekąski!'})
keywordHandler:addKeyword({'potion'}, StdModule.say, {npcHandler = npcHandler, text = 'Przepraszam, nie sprzedaję mikstur. Powinieneś odwiedzić {Lily} w tej sprawie.'})
keywordHandler:addKeyword({'food'}, StdModule.say, {npcHandler = npcHandler, text = 'Hmm, najlepszym adresem do szukania jedzenia może być {Willie} lub {Billy}. {Norma} również ma na sprzedaż przekąski.'})
keywordHandler:addKeyword({'bank'}, StdModule.say, {npcHandler = npcHandler, text = 'Bank jest dość przydatny. Możesz tam bezpiecznie zdeponować swoje pieniądze. W ten sposób nie musisz ich ciągle ze sobą nosić. Możesz też zainwestować swoje pieniądze w moje {wares}!'})
keywordHandler:addKeyword({'academy'}, StdModule.say, {npcHandler = npcHandler, text = 'Duży budynek w centrum Rookgaardu. Mają tam bibliotekę, centrum treningowe, {bank} i pokój {oracle}. {Seymour} jest tam nauczycielem.'})
keywordHandler:addKeyword({'temple'}, StdModule.say, {npcHandler = npcHandler, text = 'Mnich {Cipfried} dba o naszą świątynię. Może cię uzdrowić, jeśli jesteś poważnie ranny lub zatruty.'})
keywordHandler:addKeyword({'premium'}, StdModule.say, {npcHandler = npcHandler, text = 'Jako premium poszukiwacz przygód masz wiele zalet. Naprawdę powinieneś je sprawdzić!'})
keywordHandler:addKeyword({'citizen'}, StdModule.say, {npcHandler = npcHandler, text = 'Jeśli podasz mi imię obywatela, powiem ci, co o nim lub o niej wiem.'})
keywordHandler:addKeyword({'merchant'}, StdModule.say, {npcHandler = npcHandler, text = 'Aby zobaczyć oferty kupca, po prostu porozmawiaj z nim lub nią i poproś o {trade}. Chętnie pokażą ci swoje oferty, a także rzeczy, które od ciebie kupują.'})
keywordHandler:addKeyword({'profession'}, StdModule.say, {npcHandler = npcHandler, text = 'Wszystkiego, co musisz wiedzieć o profesjach, dowiesz się, gdy dotrzesz na {Island of Destiny}.'})
keywordHandler:addKeyword({'destiny'}, StdModule.say, {npcHandler = npcHandler, text = 'Na {Island of Destiny} można dotrzeć przez {oracle} po osiągnięciu poziomu 8. Ta podróż pomoże ci wybrać {profession}!'})

keywordHandler:addKeyword({'torch'}, StdModule.say, {npcHandler = npcHandler, text = 'Nie, dziękuję. Mogę już zalać rynek pochodniami.'})
keywordHandler:addKeyword({'fishing'}, StdModule.say, {npcHandler = npcHandler, text = 'Sprzedaję wędki i robaki, jeśli chcesz łowić ryby. Po prostu poproś mnie o {trade}.'})
keywordHandler:addKeyword({'shovel'}, StdModule.say, {npcHandler = npcHandler, text = 'Tak, to sprzedaję. Po prostu poproś mnie o {trade}, aby zobaczyć wszystkie moje oferty.'})
keywordHandler:addAliasKeyword({'rope'})
keywordHandler:addAliasKeyword({'backpack'})

-- Imiona
keywordHandler:addKeyword({'cipfried'}, StdModule.say, {npcHandler = npcHandler, text = 'To tylko stary mnich. Może cię jednak wyleczyć, jeśli jesteś poważnie ranny lub zatruty.'})
keywordHandler:addKeyword({'zirella'}, StdModule.say, {npcHandler = npcHandler, text = 'Biedna staruszka, jej syn {Tom} nigdy jej nie odwiedza.'})
keywordHandler:addKeyword({'santiago'}, StdModule.say, {npcHandler = npcHandler, text = 'Poświęcił swoje życie na witanie nowoprzybyłych na tę wyspę.'})
keywordHandler:addKeyword({'loui'}, StdModule.say, {npcHandler = npcHandler, text = 'Nie mam pojęcia, kto to jest.'})
keywordHandler:addKeyword({'al', 'dee'}, StdModule.say, {npcHandler = npcHandler, text = 'Tak, to ja. Sprytnie, że to zauważyłeś!'})
keywordHandler:addKeyword({'paulie'}, StdModule.say, {npcHandler = npcHandler, text = 'To lokalny urzędnik {bank}u.'})
keywordHandler:addKeyword({'hyacinth'}, StdModule.say, {npcHandler = npcHandler, text = 'On przeważnie trzyma się na uboczu. Jest pustelnikiem poza miastem - powodzenia w jego znalezieniu.'})
keywordHandler:addKeyword({'dixi'}, StdModule.say, {npcHandler = npcHandler, text = 'Jest wnuczką {Obi\'ego} i handluje {armors} i {shields}. Jej sklep znajduje się na południowy zachód od miasta, blisko {temple}.'})
keywordHandler:addKeyword({'obi'}, StdModule.say, {npcHandler = npcHandler, text = 'Sprzedaje {weapons}. Jego sklep znajduje się na południowy zachód od miasta, blisko {temple}.'})
keywordHandler:addKeyword({'lee\'delle'}, StdModule.say, {npcHandler = npcHandler, text = 'Jeśli jesteś {premium} poszukiwaczem przygód, powinieneś sprawdzić sklep {Lee\'Delle\'s}. Mieszka w zachodniej części miasta, tuż za mostem.'})
keywordHandler:addKeyword({'tom'}, StdModule.say, {npcHandler = npcHandler, text = 'Jest lokalnym garbarzem. Możesz spróbować sprzedać mu świeże zwłoki lub skórę.'})
keywordHandler:addKeyword({'amber'}, StdModule.say, {npcHandler = npcHandler, text = 'Obecnie dochodzi do siebie po podróżach w {academy}. Zawsze miło z nią porozmawiać!'})
keywordHandler:addKeyword({'oracle'}, StdModule.say, {npcHandler = npcHandler, text = 'Wyrocznię znajdziesz na najwyższym piętrze {academy}, tuż nad {Seymour}. Idź tam, gdy osiągniesz poziom 8.'})
keywordHandler:addKeyword({'seymour'}, StdModule.say, {npcHandler = npcHandler, text = 'Seymour jest nauczycielem prowadzącym {academy}. Ma wiele ważnych {information} na temat Tibii.'})
keywordHandler:addKeyword({'lily'}, StdModule.say, {npcHandler = npcHandler, text = 'Sprzedaje {potions} zdrowia i antidotum. Kupuje również {blueberries} i {cookies}, jeśli jakieś znajdziesz.'})
keywordHandler:addKeyword({'willie'}, StdModule.say, {npcHandler = npcHandler, text = 'To lokalny rolnik. Jeśli potrzebujesz świeżego {food}, aby odzyskać zdrowie, to dobre miejsce. Jednak wiele potworów również nosi jedzenie, takie jak mięso lub ser. Albo możesz po prostu zbierać {blueberries}.'})
keywordHandler:addKeyword({'billy'}, StdModule.say, {npcHandler = npcHandler, text = 'To lokalny rolnik. Jeśli potrzebujesz świeżego {food}, aby odzyskać zdrowie, to dobre miejsce. Handluje jednak tylko z {premium} poszukiwaczami przygód.'})
keywordHandler:addKeyword({'norma'}, StdModule.say, {npcHandler = npcHandler, text = 'Kiedyś sprzedawała sprzęt, ale myślę, że teraz otworzyła mały bar. Mówi o zmianie imienia na \'Mary\' i takie tam, dziwna dziewczyna.'})
keywordHandler:addKeyword({'zerbrus'}, StdModule.say, {npcHandler = npcHandler, text = 'Niektórzy nazywają go bohaterem. Chroni miasto przed {monsters}.'})
keywordHandler:addAliasKeyword({'dallheim'})

-- Quest z kilofem
local pickKeyword = keywordHandler:addKeyword({'pick'}, StdModule.say, {npcHandler = npcHandler, text = 'Kilofy są trudne do zdobycia. Handluję nimi tylko w zamian za wysokiej jakości małe toporki. Chciałbyś zawrzeć tę umowę?'})
	pickKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Wspaniale! Proszę, weź swój kilof.', reset = true},
		function(player) return player:getItemCount(2559) > 0 end,
		function(player)
			player:removeItem(2559, 1)
			player:addItem(2553, 1)
		end
	)
	pickKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Przepraszam, szukam MAŁEGO toporka.', reset = true})
	pickKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Cóż, w takim razie nie.', reset = true})
keywordHandler:addAliasKeyword({'small', 'axe'})

-- Wiadomości NPC dla różnych zdarzeń
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Żegnaj.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Żegnaj |PLAYERNAME|.')
npcHandler:setMessage(MESSAGE_SENDTRADE, 'Spójrz do okna handlu po lewej stronie.')
npcHandler:setMessage(MESSAGE_GREET, {
	'Witaj, witaj, |PLAYERNAME|! Proszę wejdź, obejrzyj i kup! Jestem specjalistą od wszelkiego rodzaju {tools}. Po prostu poproś mnie o {trade}, aby zobaczyć moje oferty! Możesz również zapytać mnie o ogólne {hints} dotyczące gry. ...',
	'Możesz również zapytać mnie o każdego {citizen} na wyspie.'
})

npcHandler:addModule(FocusModule:new())