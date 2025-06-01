local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- Funkcje zdarzeń NPC
function onCreatureAppear(cid)          npcHandler:onCreatureAppear(cid)        end
function onCreatureDisappear(cid)       npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)        end
function onThink()              npcHandler:onThink()                    end

-- Głosy (losowe wypowiedzi) NPC
local voices = {
    { text = 'Chciałabym zjeść trochę łososia... najlepiej przygotowanego w stylu Liberty Bay... pycha.' },
    { text = 'Ojej, jestem zmęczona. Naprawdę powinnam się przespać... zzzz.' },
    { text = 'Jakie to było znowu słowo w języku Orków... hmm.' },
    { text = 'Hej ty! Czy ty też jesteś poszukiwaczem przygód?' },
    { text = '<śpiewa> Burzowe pogody, burzowe pogody... burzowe pogody na morzu!' }
}
npcHandler:addModule(VoiceModule:new(voices))

-- Podstawowe słowa kluczowe i dialogi
keywordHandler:addKeyword({'wskazówki'}, StdModule.rookgaardHints, {npcHandler = npcHandler})
keywordHandler:addKeyword({'jak', 'się', 'masz'}, StdModule.say, {npcHandler = npcHandler, text = 'Dochodzę do siebie po {morskiej} podróży.'})
keywordHandler:addKeyword({'praca'}, StdModule.say, {npcHandler = npcHandler, text = 'Jestem {badaczką}, która szuka {przygód}.'})
keywordHandler:addKeyword({'badać'}, StdModule.say, {npcHandler = npcHandler, text = 'Byłam prawie wszędzie w {Tibia}.'})
keywordHandler:addKeyword({'przygoda'}, StdModule.say, {npcHandler = npcHandler, text = 'Walczyłam z groźnymi {potworami}, wspinałam się na najwyższe góry, badałam najgłębsze {lochy} i przepłynęłam {morze} na {tratwie}.'})
keywordHandler:addKeyword({'morze'}, StdModule.say, {npcHandler = npcHandler, text = 'Moja podróż po morzu była wyczerpująca. Pogoda była zła, fale wysokie, a moja tratwa dość prosta. Jest w tym jednak pewna ekscytacja.'})
keywordHandler:addKeyword({'czas'}, StdModule.say, {npcHandler = npcHandler, text = 'Przepraszam, zgubiłam zegarek podczas sztormu.'})
keywordHandler:addKeyword({'pomoc'}, StdModule.say, {npcHandler = npcHandler, text = 'Cóż, mogę dać ci ogólne {wskazówki} lub opowiedzieć o moich {przygodach} i wielu innych tematach. Och, a jeśli się nudzisz, mogę mieć dla ciebie mały {quest}.'})
keywordHandler:addKeyword({'informacje'}, StdModule.say, {npcHandler = npcHandler, text = 'Cóż, mogę dać ci ogólne {wskazówki} lub opowiedzieć o moich {przygodach} i wielu innych tematach. Och, a jeśli się nudzisz, mogę mieć dla ciebie mały {quest}.'})
keywordHandler:addKeyword({'loch'}, StdModule.say, {npcHandler = npcHandler, text = 'Nie miałam jeszcze czasu na zbadanie lochów tej wyspy, ale widziałam dwie duże jaskinie na wschodzie, a na północnym zachodzie jest zrujnowana wieża. Och, i są też {kanały}.'})
keywordHandler:addKeyword({'kanały'}, StdModule.say, {npcHandler = npcHandler, text = 'Lubię kanały. Moje pierwsze doświadczenia bojowe zdobyłam w kanałach pod {Thais}. Mały system kanałów {Rookgaard} ma kilka paskudnych szczurów do walki.'})
keywordHandler:addKeyword({'potwór'}, StdModule.say, {npcHandler = npcHandler, text = 'Och, walczyłam z {orkami}, {cyklopami}, {minotaurami}, nawet {smokami} i wieloma innymi stworzeniami.'})
keywordHandler:addKeyword({'cyklop'}, StdModule.say, {npcHandler = npcHandler, text = 'Nie podoba mi się sposób, w jaki na ciebie patrzą. Ich oko wydaje się przeszywać cię na wylot. Przerażające!'})
keywordHandler:addKeyword({'minotaur'}, StdModule.say, {npcHandler = npcHandler, text = 'To paskudne potwory, zwłaszcza że w swoich klanach mają walczących na dystans i magów. Mój {plecak} jest ręcznie robiony ze skóry minotaura.'})
keywordHandler:addKeyword({'smok'}, StdModule.say, {npcHandler = npcHandler, text = 'Ich oddech jest tak gorący! Musiałam obciąć włosy po moim ostatnim spotkaniu ze smokiem, bo końcówki były spalone. Z tym musisz się zmierzyć jako poszukiwaczka przygód!'})
keywordHandler:addKeyword({'tratwa'}, StdModule.say, {npcHandler = npcHandler, text = 'Moją tratwę zostawiłam na południowo-wschodnim wybrzeżu. Zapomniałam na niej mojego prywatnego {notatnika}. Jeśli mógłbyś mi go zwrócić, byłabym bardzo wdzięczna.'})
keywordHandler:addKeyword({'quest'}, StdModule.say, {npcHandler = npcHandler, text = 'Moją tratwę zostawiłam na południowo-wschodnim wybrzeżu. Zapomniałam na niej mojego prywatnego {notatnika}. Jeśli mógłbyś mi go zwrócić, byłabym bardzo wdzięczna.'})
keywordHandler:addKeyword({'misja'}, StdModule.say, {npcHandler = npcHandler, text = 'Moją tratwę zostawiłam na południowo-wschodnim wybrzeżu. Zapomniałam na niej mojego prywatnego {notatnika}. Jeśli mógłbyś mi go zwrócić, byłabym bardzo wdzięczna.'})
keywordHandler:addKeyword({'seymour'}, StdModule.say, {npcHandler = npcHandler, text = 'Myślę, że ten biedny facet był złym wyborem na szefa {akademii}.'})
keywordHandler:addKeyword({'akademia'}, StdModule.say, {npcHandler = npcHandler, text = 'Dobra instytucja, ale zdecydowanie potrzebuje więcej funduszy od {króla}.'})
keywordHandler:addKeyword({'król'}, StdModule.say, {npcHandler = npcHandler, text = 'Król Tibianus jest władcą {Thais}. Wyspa {Rookgaard} należy do jego królestwa.'})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = 'Ładne miasto, ale {król} ma pewne problemy z egzekwowaniem prawa.'})
keywordHandler:addKeyword({'broń'}, StdModule.say, {npcHandler = npcHandler, text = 'Najlepsze bronie na tej wyspie to tylko wykałaczki w porównaniu z broniami, którymi posługują się wojownicy na {kontynencie}.'})
keywordHandler:addKeyword({'magia'}, StdModule.say, {npcHandler = npcHandler, text = 'Zaklęcia są nauczane tylko w siedzibach gildii na kontynencie.'})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = 'Staram się zbadać każdy zakątek Tibii, a pewnego dnia zobaczę wszystko.'})
keywordHandler:addKeyword({'zamek'}, StdModule.say, {npcHandler = npcHandler, text = 'Jeśli podróżujesz do Thais, naprawdę powinieneś odwiedzić tamtejszy wspaniały zamek.'})
keywordHandler:addKeyword({'kontynent'}, StdModule.say, {npcHandler = npcHandler, text = 'Będziesz zaskoczony, gdy opuścisz tę wyspę. Świat tam na zewnątrz jest gigantyczny.'})
keywordHandler:addKeyword({'narzędzia'}, StdModule.say, {npcHandler = npcHandler, text = 'Najważniejsze narzędzia, których potrzebujesz, to {lina}, {łopata} i może {pochodnia}.'})
keywordHandler:addKeyword({'lina'}, StdModule.say, {npcHandler = npcHandler, text = 'Pewnego dnia wpadłam do dziury, nie mając liny. Krzyczałam o pomoc przez całe trzy dni! W końcu przeszedł rybak i wyciągnął mnie swoją liną, miałam szczęście.'})
keywordHandler:addKeyword({'łopata'}, StdModule.say, {npcHandler = npcHandler, text = 'Czasami mam silną potrzebę użycia jej, aby kogoś znokautować.'})
keywordHandler:addKeyword({'pochodnia'}, StdModule.say, {npcHandler = npcHandler, text = 'Wiesz, na kontynencie będziesz mógł rzucać magiczne zaklęcia, które zapewnią ci światło. Nie będziesz już naprawdę potrzebował pochodni.'})
keywordHandler:addKeyword({'bank'}, StdModule.say, {npcHandler = npcHandler, text = 'I tak prawie nie mam przy sobie pieniędzy, więc nie ma potrzeby wpłacać ich do banku.'})
keywordHandler:addKeyword({'przeznaczenie'}, StdModule.say, {npcHandler = npcHandler, text = 'Znajdziesz swoje przeznaczenie. Jestem pewna, że to coś wielkiego i ważnego.'})
keywordHandler:addKeyword({'akademia'}, StdModule.say, {npcHandler = npcHandler, text = 'Dobra instytucja, ale zdecydowanie potrzebuje więcej funduszy od {króla}.'})
keywordHandler:addKeyword({'handel'}, StdModule.say, {npcHandler = npcHandler, text = 'Och, przepraszam, ale nie jestem zainteresowana kupnem ani sprzedażą czegokolwiek.'})
keywordHandler:addKeyword({'premium'}, StdModule.say, {npcHandler = npcHandler, text = 'Nie chciałabym przegapić bycia premium poszukiwaczem przygód. Wszystko jest o wiele łatwiejsze!'})

-- Imiona
keywordHandler:addKeyword({'al', 'dee'}, StdModule.say, {npcHandler = npcHandler, text = 'Niewiele mam o nim do powiedzenia. Myślę, że sprzedaje {narzędzia}.'})
keywordHandler:addKeyword({'loui'}, StdModule.say, {npcHandler = npcHandler, text = 'Nigdy go nie widziałam.'})
keywordHandler:addKeyword({'zirella'}, StdModule.say, {npcHandler = npcHandler, text = 'Naprawdę zapytała mnie, czy może mieć resztki mojej {tratwy} jako drewno na opał! Wyobrażasz sobie to??'})
keywordHandler:addKeyword({'santiago'}, StdModule.say, {npcHandler = npcHandler, text = 'Obiecał naprawić moją {tratwę}.'})
keywordHandler:addKeyword({'amber'}, StdModule.say, {npcHandler = npcHandler, text = 'Czy wiesz, że moje imię to także nazwa klejnotu?'})
keywordHandler:addKeyword({'tom'}, StdModule.say, {npcHandler = npcHandler, text = 'Dla mnie wydaje się trochę niegrzeczny, ale może to tylko moje wrażenie.'})
keywordHandler:addKeyword({'lee\'delle'}, StdModule.say, {npcHandler = npcHandler, text = 'Słyszałam, że jej oferty są niezwykle dobre.'})
keywordHandler:addKeyword({'oracle'}, StdModule.say, {npcHandler = npcHandler, text = 'Mówi się, że wyrocznia pokaże ci twoje {przeznaczenie}, gdy osiągniesz poziom 8.'})
keywordHandler:addKeyword({'norma'}, StdModule.say, {npcHandler = npcHandler, text = 'Zmieniła się bardzo, odkąd ostatnio ją widziałam.'})
keywordHandler:addKeyword({'seymour'}, StdModule.say, {npcHandler = npcHandler, text = 'Myślę, że ten biedny facet był złym wyborem na szefa {akademii}.'})
keywordHandler:addKeyword({'lily'}, StdModule.say, {npcHandler = npcHandler, text = 'Hm, chyba jej jeszcze nie spotkałam.'})
keywordHandler:addKeyword({'billy'}, StdModule.say, {npcHandler = npcHandler, text = 'Przyniósł mi trochę swojej słynnej gulaszu ze szczurów. Naprawdę nie chciałam go obrazić, ale po prostu nie mogę czegoś takiego jeść. Więc powiedziałam mu, że jestem wegetarianką i jem tylko ryby. <przełyka>'})
keywordHandler:addKeyword({'willie'}, StdModule.say, {npcHandler = npcHandler, text = 'Jest zabawny na swój sposób.'})
keywordHandler:addKeyword({'paulie'}, StdModule.say, {npcHandler = npcHandler, text = 'Nie, nie poszłam jeszcze do {banku}.'})
keywordHandler:addKeyword({'cipfried'}, StdModule.say, {npcHandler = npcHandler, text = 'Uprzejma osoba. Powinieneś go odwiedzić, jeśli masz pytania lub potrzebujesz leczenia.'})
keywordHandler:addKeyword({'hyacinth'}, StdModule.say, {npcHandler = npcHandler, text = 'Hyacinth to wspaniały uzdrowiciel. Mieszka gdzieś ukryty na tej wyspie.'})
keywordHandler:addKeyword({'obi'}, StdModule.say, {npcHandler = npcHandler, text = 'To zabawny mały człowiek.'})
keywordHandler:addKeyword({'dixi'}, StdModule.say, {npcHandler = npcHandler, text = 'Tak naprawdę jej nie znam, ale wydaje się być miłą dziewczyną.'})
keywordHandler:addKeyword({'zerbrus'}, StdModule.say, {npcHandler = npcHandler, text = 'Niezwykły wojownik. Jest pierwszą i ostatnią linią obrony {Rookgaard}.'})
keywordHandler:addAliasKeyword({'dallheim'})

-- Język Orków
keywordHandler:addKeyword({'ork'}, StdModule.say, {npcHandler = npcHandler, text = 'Nie są to najmilsi faceci, jakich możesz spotkać. Miałam z nimi kilka starć i w końcu zostałam ich {więźniem} na kilka miesięcy.'})
local prisonerKeyword = keywordHandler:addKeyword({'więzień'}, StdModule.say, {npcHandler = npcHandler, text = 'Mówię kilka słów w języku Orków, niewiele, tylko kilka podstawowych, takich jak \'{tak}\' i \'{nie}\'.'})
    prisonerKeyword:addChildKeyword({'tak'}, StdModule.say, {npcHandler = npcHandler, text = 'To \'mok\' w języku Orków. Powiem ci więcej, jeśli przyniesiesz mi trochę {jedzenia}.', reset = true})
    prisonerKeyword:addChildKeyword({'nie'}, StdModule.say, {npcHandler = npcHandler, text = 'W języku Orków to \'burp\'. Powiem ci więcej, jeśli przyniesiesz mi trochę {jedzenia}.', reset = true})
keywordHandler:addAliasKeyword({'język'})

-- Jedzenie (Łosoś)
keywordHandler:addKeyword({'jedzenie'}, StdModule.say, {npcHandler = npcHandler, text = 'Moje ulubione danie to {łosoś}. Och, proszę, przynieś mi trochę.'})
local salmonKeyword = keywordHandler:addKeyword({'łosoś'}, StdModule.say, {npcHandler = npcHandler, text = 'Tak! Jeśli dasz mi trochę łososia, powiem ci inne słowo w języku Orków. Zgoda?'})
    salmonKeyword:addChildKeyword({'tak'}, StdModule.say, {npcHandler = npcHandler, text = 'Dziękuję. Orki nazywają strzały \'pixo\'.', reset = true},
        function(player) return player:getItemCount(2668) > 0 end,
        function(player) player:removeItem(2668, 1) end
    )
    salmonKeyword:addChildKeyword({'tak'}, StdModule.say, {npcHandler = npcHandler, text = 'Nie masz żadnego łososia!', reset = true})
    salmonKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Ok, w takim razie nie powiem ci innego słowa w języku Orków.', reset = true})

-- Quest Notatnika
local bookKeyword = keywordHandler:addKeyword({'książka'}, StdModule.say, {npcHandler = npcHandler, text = 'Czy przyniesiesz mi mój notatnik?'})
    bookKeyword:addChildKeyword({'tak'}, StdModule.say, {npcHandler = npcHandler, text = 'Doskonale. Proszę, weź ten krótki miecz jako nagrodę.', reset = true},
            function(player) return player:getItemCount(1955) > 0 end,
            function(player) player:addItem(2406, 1) player:removeItem(1955, 1) end
    )
    bookKeyword:addChildKeyword({'tak'}, StdModule.say, {npcHandler = npcHandler, text = 'Mhm, cokolwiek tam masz, to nie jest mój notatnik.', reset = true})
    bookKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Szkoda.', reset = true})
keywordHandler:addAliasKeyword({'notatnik'})

-- Komunikaty ogólne NPC
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Tak, do zobaczenia później.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Do zobaczenia później, |PLAYERNAME|.')
npcHandler:setMessage(MESSAGE_GREET, 'Och, witaj, miło cię widzieć, |PLAYERNAME|. Jesteś tu, aby posłuchać opowieści o moich {przygodach} czy potrzebujesz {pomocy}?')

npcHandler:addModule(FocusModule:new())