local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local voices = {
	{ text = 'Dodać jednego świeżego martwego szczura i dobrze wymieszać...' },
	{ text = 'Ach, gdybym tylko miał patelnię!' },
	{ text = 'Chleb, ser, szynka i mięso! Wszystko świeże!' },
	{ text = 'Kupuję świeże martwe szczury!' },
	{ text = 'Kupuję też wiele rodzajów żywności i składników!' },
	{ text = 'Hmm, hmm, teraz jakich składników potrzebuję...' },
	{ text = 'Potrzebujesz jedzenia? Mam dużo na sprzedaż!' }
}
npcHandler:addModule(VoiceModule:new(voices))

-- Podstawowe słowa kluczowe
keywordHandler:addKeyword({'hint'}, StdModule.rookgaardHints, {npcHandler = npcHandler})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'Billy.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'Jestem rolnikiem i {kucharzem}. Chętnie zrobiłbym naleśniki, ale brakuje mi dobrej {patelni}.'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'Przybyłem tu dla spokoju i wypoczynku, więc zostaw mnie w spokoju z \'czasem\'.'})
keywordHandler:addKeyword({'bank'}, StdModule.say, {npcHandler = npcHandler, text = 'Raczej daj swoje {pieniądze} mi, niż zostawiaj je w banku. Hehe.'})
keywordHandler:addKeyword({'how', 'are', 'you'}, StdModule.say, {npcHandler = npcHandler, text = 'Dziękuję, mam się dobrze.'})
keywordHandler:addKeyword({'information'}, StdModule.say, {npcHandler = npcHandler, text = 'Jeśli potrzebujesz informacji, mogę ci udzielić ogólnych {wskazówek}.'})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'Jestem kucharzem, nie księdzem. Jeśli potrzebujesz informacji, mogę ci udzielić ogólnych {wskazówek}.'})
keywordHandler:addKeyword({'cook'}, StdModule.say, {npcHandler = npcHandler, text = 'Jestem najlepszym kucharzem w okolicy. Możesz mi sprzedać większość rodzajów {jedzenia}. Po prostu poproś mnie o {handel}, aby zobaczyć, co ode mnie kupisz, a także moje oferty.'})
keywordHandler:addKeyword({'citizen'}, StdModule.say, {npcHandler = npcHandler, text = 'Który obywatel?'})
keywordHandler:addKeyword({'rat'}, StdModule.say, {npcHandler = npcHandler, text = 'Jeśli przyniesiesz mi świeżego szczura do mojego słynnego gulaszu, poproś mnie o {handel}.'})
keywordHandler:addKeyword({'shop'}, StdModule.say, {npcHandler = npcHandler, text = 'Nie, to nie jest prawdziwy sklep. Mam jednak kilka ofert. Jeśli jesteś zainteresowany, po prostu poproś mnie o {handel}. Na {Rookgaardzie} są też inni {kupcy}.'})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = 'Jest tak wiele do odkrycia! Lepiej pospiesz się, żeby dostać się na kontynent! Gdy osiągniesz 8 poziom, poszukaj {wyroczni}.'})
keywordHandler:addKeyword({'equipment'}, StdModule.say, {npcHandler = npcHandler, text = 'Jako poszukiwacz przygód, powinieneś zawsze mieć przy sobie przynajmniej {plecak}, {linę}, {łopatę}, {broń}, {zbroję} i {tarczę}.'})
keywordHandler:addKeyword({'academy'}, StdModule.say, {npcHandler = npcHandler, text = 'Jest tam mnóstwo zakurzonych książek. Możesz je czytać, aby zdobyć podstawową wiedzę o świecie. Z drugiej strony, możesz też popytać po wiosce.'})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = 'Król i jego poborcy podatkowi są daleko. Wkrótce ich spotkasz.'})
keywordHandler:addKeyword({'weapon'}, StdModule.say, {npcHandler = npcHandler, text = 'Zapytaj {Obiego} lub {Lee\'Delle}. Robią tu fortunę na tych wszystkich pseudo-bohaterach.'})
keywordHandler:addKeyword({'rookgaard'}, StdModule.say, {npcHandler = npcHandler, text = 'Ta wyspa przygotuje Cię na główny kontynent {Tibii}. Naucz się walczyć i stań się silniejszy!'})
keywordHandler:addKeyword({'monster'}, StdModule.say, {npcHandler = npcHandler, text = 'Nie bój się, powinieneś być bezpieczny, dopóki zostajesz w mieście. Niebezpieczne potwory grasują w {lochach}.'})
keywordHandler:addKeyword({'dungeon'}, StdModule.say, {npcHandler = npcHandler, text = 'Znajdziesz wiele lochów, jeśli się rozejrzysz. Jednym z przykładów są {kanały} pod Rookgaardem.'})
keywordHandler:addKeyword({'sewer'}, StdModule.say, {npcHandler = npcHandler, text = 'Lokalne kanały są opanowane przez {szczury}. Świeże szczury to dobry gulasz, możesz mi je sprzedać.'})
keywordHandler:addKeyword({'sell'}, StdModule.say, {npcHandler = npcHandler, text = 'Po prostu poproś mnie o {handel}, aby zobaczyć, co ode mnie kupisz. Jedzenie prawie każdego rodzaju!'})
keywordHandler:addKeyword({'merchant'}, StdModule.say, {npcHandler = npcHandler, text = 'Aby zobaczyć oferty kupca, po prostu porozmawiaj z nim i poproś o {handel}.'})
keywordHandler:addKeyword({'god'}, StdModule.say, {npcHandler = npcHandler, text = 'Zgadza się, jestem bogiem gotowania!'})
keywordHandler:addKeyword({'recipe'}, StdModule.say, {npcHandler = npcHandler, text = 'Chętnie zrobiłbym naleśniki, ale brakuje mi porządnej {patelni}. Jeśli mi ją przyniesiesz, nagrodzę cię.'})

keywordHandler:addKeyword({'armor'}, StdModule.say, {npcHandler = npcHandler, text = 'Zbroje i tarcze można kupić u {Dixi} lub u {Lee\'Delle}. Dixi prowadzi ten sklep niedaleko {Obiego}.'})
keywordHandler:addAliasKeyword({'shield'})

keywordHandler:addKeyword({'backpack'}, StdModule.say, {npcHandler = npcHandler, text = 'Dostaniesz to od {Al Dee} lub {Lee\'Delle}.'})
keywordHandler:addAliasKeyword({'shovel'})
keywordHandler:addAliasKeyword({'rope'})
keywordHandler:addAliasKeyword({'fishing'})

keywordHandler:addKeyword({'money'}, StdModule.say, {npcHandler = npcHandler, text = 'Cóż, bez złota nie ma interesu. Zarabiaj złoto, walcząc z {potworami} i zbierając rzeczy, które ze sobą noszą. Sprzedaj je {kupcom}, aby zarobić!'})
keywordHandler:addAliasKeyword({'gold'})

keywordHandler:addKeyword({'magic'}, StdModule.say, {npcHandler = npcHandler, text = 'Potrafię pisać zaklęcia, ale nie znam żadnych zaklęć.'})
keywordHandler:addAliasKeyword({'spell'})

keywordHandler:addKeyword({'food'}, StdModule.say, {npcHandler = npcHandler, text = 'Po prostu poproś mnie o {handel}, aby zobaczyć moje oferty.'})
keywordHandler:addAliasKeyword({'buy'})
keywordHandler:addAliasKeyword({'stuff'})
keywordHandler:addAliasKeyword({'offer'})

-- Nazwy
keywordHandler:addKeyword({'obi'}, StdModule.say, {npcHandler = npcHandler, text = 'Lubię go, zazwyczaj raz w tygodniu pijemy jedno lub dwa piwa i dzielimy się historiami o {Williem}.'})
keywordHandler:addKeyword({'norma'}, StdModule.say, {npcHandler = npcHandler, text = 'Ta dziewczyna teraz tylko imprezuje. Chyba miała dość sprzedawania {sprzętu}.'})
keywordHandler:addKeyword({'loui'}, StdModule.say, {npcHandler = npcHandler, text = 'To szalony gość. Zazwyczaj słyszę, jak krzyczy o jakiejś dziurze.'})
keywordHandler:addKeyword({'santiago'}, StdModule.say, {npcHandler = npcHandler, text = 'Jest rybakiem i z jakiegoś powodu w jego chacie zawsze roi się od karaluchów.'})
keywordHandler:addKeyword({'zirella'}, StdModule.say, {npcHandler = npcHandler, text = 'Ta stara wiedźma zawsze znajdzie kogoś, kto wykona jej pracę. Nie mam pojęcia, jak ona to robi.'})
keywordHandler:addKeyword({'al', 'dee'}, StdModule.say, {npcHandler = npcHandler, text = 'Przyzwoity facet. Sprzedaje ogólny sprzęt, taki jak {liny}, {łopaty} i tak dalej.'})
keywordHandler:addKeyword({'amber'}, StdModule.say, {npcHandler = npcHandler, text = 'Rzeczywiście jest ładna! Ciekawe, czy lubi brodatych mężczyzn.'})
keywordHandler:addKeyword({'billy'}, StdModule.say, {npcHandler = npcHandler, text = 'Trzeba kochać to imię.'})
keywordHandler:addKeyword({'willie'}, StdModule.say, {npcHandler = npcHandler, text = 'Nie słuchaj tego starego pseudo-kucharza, ja jestem najlepszym kucharzem w okolicy.'})
keywordHandler:addKeyword({'cipfried'}, StdModule.say, {npcHandler = npcHandler, text = 'Nigdy nie opuszcza świątyni. Spędza czas opiekując się nowoprzybyłymi. Możesz go poprosić o uzdrowienie, jeśli jesteś poważnie ranny lub zatruty.'})
keywordHandler:addKeyword({'dixi'}, StdModule.say, {npcHandler = npcHandler, text = 'To wnuczka {Obiego}. Pomaga mu, sprzedając {zbroje} i {tarcze}. Myślę, że będzie pięknością, gdy dorośnie.'})
keywordHandler:addKeyword({'hyacinth'}, StdModule.say, {npcHandler = npcHandler, text = 'Nigdy nie widuję tego faceta.'})
keywordHandler:addKeyword({'lee\'delle'}, StdModule.say, {npcHandler = npcHandler, text = 'Jej sklep jest super-ekskluzywny. Jeśli jesteś premium poszukiwaczem przygód, sprawdź go w zachodniej części miasta. Jest tam mnóstwo fajnych ofert.'})
keywordHandler:addKeyword({'lily'}, StdModule.say, {npcHandler = npcHandler, text = 'Mieszka na samym południu tego miasta, sprzedając swoje eliksiry. Słodka – cóż, słodko-lubiąca dziewczyna.'})
keywordHandler:addKeyword({'oracle'}, StdModule.say, {npcHandler = npcHandler, text = 'Wyrocznię znajdziesz na najwyższym piętrze {akademii}, tuż nad {Seymourem}. Idź tam, gdy osiągniesz 8 poziom.'})
keywordHandler:addKeyword({'paulie'}, StdModule.say, {npcHandler = npcHandler, text = 'Musi mieć najbardziej nudną pracę na świecie.'})
keywordHandler:addKeyword({'seymour'}, StdModule.say, {npcHandler = npcHandler, text = 'Nie podoba mi się jego zachowanie dyrektora. Z drugiej strony, JEST dyrektorem {akademii}.'})
keywordHandler:addKeyword({'tom'}, StdModule.say, {npcHandler = npcHandler, text = 'Tom garbarz kupuje to, co jest zbyt obrzydliwe lub zbyt stare do jedzenia, jeśli chodzi o zwierzęta. Martwe wilki i tym podobne.'})
keywordHandler:addKeyword({'dallheim'}, StdModule.say, {npcHandler = npcHandler, text = 'Jest jednym z najlepszych ludzi króla i jest tutaj, aby nas chronić.'})
keywordHandler:addAliasKeyword({'zerbrus'})

-- Quest Mikstury Zdrowia
local panKeyword = keywordHandler:addKeyword({'pan'}, StdModule.say, {npcHandler = npcHandler, text = 'Znalazłeś dla mnie patelnię?'})
	panKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Patelnia! Nareszcie! Weź to na wypadek, gdybyś zjadł coś, co ugotował mój kuzyn.', reset = true},
			function(player) return player:getItemCount(2563) > 0 end,
			function(player)
				player:removeItem(2563, 1)
				player:addItem(8704, 1)
			end
	)
	panKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Hej! Nie masz żadnej!', reset = true})
	panKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Więc idź i poszukaj!', reset = true})

npcHandler:setMessage(MESSAGE_WALKAWAY, 'JAK CHAMSKO!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Żegnaj.')
npcHandler:setMessage(MESSAGE_SENDTRADE, 'Jasne.')
npcHandler:setMessage(MESSAGE_GREET, 'Witaj |PLAYERNAME|. Jestem rolnikiem i kucharzem, może zainteresuje cię {handel} jedzeniem? Możesz też zapytać mnie o ogólne {wskazówki} dotyczące gry.')

npcHandler:addModule(FocusModule:new())