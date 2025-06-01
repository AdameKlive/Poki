local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- Funkcje zdarzeń NPC
function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

-- Głosy (losowe teksty wypowiadane przez NPC)
local voices = {
	{ text = 'Jestem MĘŻCZYZNĄ! Wyciągnijcie mnie stąd, pijane głupki!' },
	{ text = 'WYCIĄGNIJCIE MNIE STĄD!' },
	{ text = 'Wyciągnijcie mnie! To wszystko było częścią planu, głupcy!' },
	{ text = 'Jeśli kiedykolwiek stąd wyjdę, zabiję was wszystkich! Wszystkich!' },
	{ text = 'NIE jestem księżniczką Lumelią, głupcy!' },
	{ text = 'Znajdźcie ślusarza i uwolnijcie mnie, bo tego pożałujecie, głupi piraci!' },
	{ text = 'Nie jestem księżniczką, jestem aktorem!' }
}

-- Dodanie modułu głosowego do NPC
npcHandler:addModule(VoiceModule:new(voices))

-- Definicje słów kluczowych i odpowiedzi NPC
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "Jestem wspaniałym i sławnym aktorem! Wcale nie księżniczką. Tylko UDWAŁEM, że jestem księżniczką. Ale spróbuj to wytłumaczyć tym głupim piratom."})
keywordHandler:addKeyword({'actor'}, StdModule.say, {npcHandler = npcHandler, text = "Aktorstwo sceniczne było stratą mojego ogromnego talentu. Nie tylko jestem urodzonym liderem, mój talent jest bardziej dochodowy, gdy jest używany do oszukiwania ludzi."})
keywordHandler:addKeyword({'stage'}, StdModule.say, {npcHandler = npcHandler, text = "Aktorstwo sceniczne było stratą mojego ogromnego talentu. Nie tylko jestem urodzonym liderem, mój talent jest bardziej dochodowy, gdy jest używany do oszukiwania ludzi."})
keywordHandler:addKeyword({'kid'}, StdModule.say, {npcHandler = npcHandler, text = "Zawsze był głupcem o zbyt miękkim sercu, by stać się obávanym piratem."})
keywordHandler:addKeyword({'princess'}, StdModule.say, {npcHandler = npcHandler, text = "Moja rola księżniczki była tylko częścią sprytnego planu, który mieliśmy."})
keywordHandler:addKeyword({'cell'}, StdModule.say, {npcHandler = npcHandler, text = "Jeśli znajdziesz jakiś sposób, by mnie uwolnić, mogę nawet pozwolić ci żyć w nagrodę! Więc lepiej się postaraj, bo inaczej cię zabiję!"})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "Jak śmiesz? Zostawili mnie, bym gnił w tej brudnej celi, a ty nie masz nic lepszego do roboty, tylko paplać?"})
keywordHandler:addKeyword({'rot'}, StdModule.say, {npcHandler = npcHandler, text = "TY... TY... Jesteś tak samo martwy! Dostanę cię! Słyszysz? Będę miał twoją głowę! Na tacy!"})
keywordHandler:addKeyword({'pirate'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		'W sprawiedliwym świecie byłbym kapitanem wspaniałego statku, ...',
		'Ci piraci byliby teraz moimi sługami, a my przemierzalibyśmy morza i stawalibyśmy się postrachem miast przybrzeżnych! ...',
		'Gdyby tylko nasz plan się powiódł!'
	}}
)
keywordHandler:addKeyword({'ship'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		'Kapitan Kid sprzedał swój statek, aby kupić bezsensowne rzeczy, takie jak te szalenie drogie zamki do drzwi cel. ...',
		'Powiedział, że kajaki na razie wystarczą. ...',
		'Odniosłem wrażenie, że nie był zbytnio zasmucony rozstaniem ze statkiem, ponieważ wiadomo było, że cierpiał na chorobę morską.'
	}}
)
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		'Byłbym znacznie lepszym kapitanem niż Kid. Grałem kilku kapitanów na scenie i byłem dobry! ...',
		'Tam, gdzie Kid pragnął uznania swoich ludzi, ja rządziłbym strachem i żelazną pięścią!'
	}}
)
keywordHandler:addKeyword({'plan'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		'To wszystko był pomysł kapitana Kida. Widzisz, nienawidził swojego imienia i planował stać się znanym pod imieniem kapitan Kidnap. ...',
		'Potrzebował tylko kogoś sławnego do porwania. ...',
		'Biorąc pod uwagę beznadziejny brak talentu i inteligencji jego ludzi, byłoby to nie lada wyczynem. ...',
		'Znaliśmy się z kilku oszustw, które razem robiliśmy w przeszłości, więc skontaktował się ze mną. ...',
		'Miałem udawać sławną księżniczkę Lumelię. Wiesz, tę, której wszyscy szukali. ...',
		'To pokazałoby jego ludziom i innym piratom, jakim był wspaniałym porywaczem. ...',
		'Obiecał mi, że zostanę jego zastępcą i będę prowadził wspaniałe życie pełne rabunku, kradzieży i łupienia. ...',
		'Zgodziłem się więc na udawanie księżniczki przez jakiś czas i na początku wszystko szło dobrze. ...',
		'Wrócił ze mną przebranym za księżniczkę po własnym rajdzie i natychmiast stał się bohaterem dnia dla swoich ludzi. ...',
		'Sprawy potoczyły się źle, gdy zdecydowali się urządzić imprezę zwycięstwa. ...',
		'Z tego, co mogłem wywnioskować z bełkotania piratów, Kid zgubił klucz do mojej celi podczas załatwiania potrzeby w podziemnej rzece. ...',
		'Głupiec postanowił po niego nurkować... i nigdy więcej go nie widziano. ...',
		'Kiedy dowiedziałem się o śmierci Kida, próbowałem przekonać piratów, że to mistyfikacja, ale oni po prostu mi nie wierzą!'
	}}
)
keywordHandler:addKeyword({'kidnap'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		'Ach, porwania są tak zabawne. To znaczy, jeśli nie jesteś po stronie ofiary. ...',
		'To łatwe pieniądze i masz szansę przestraszyć i torturować kogoś, kto nie może się bronić!'
	}}
)
keywordHandler:addKeyword({'scams'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		'Im głupszy jest człowiek, tym łatwiej go oszukać. ...',
		'A im są biedniejsi, tym mniej mają środków, by się zemścić. Har Har! ...',
		'Więc upewniam się, że rujnuję tych, których oszukuję. Wtedy mają inne rzeczy do zmartwienia niż zemsta na mnie.'
	}}
)
keywordHandler:addKeyword({'key'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		'Klucz zaginął w podziemnej rzece i prawdopodobnie spłynął już do siedmiu mórz! ...',
		'Gdyby ten głupi Kid nie był tak obsesyjnie pochłonięty porwaniami, nie sprzedałby swojego statku, by kupić najdroższe i najbardziej skomplikowane zamki do swoich cel!'
	}}
)
keywordHandler:addKeyword({'plundering'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		'Dopóki trzymamy się niebronionych miast przybrzeżnych, możemy łatwo dorobić się fortuny. Har Har! ...',
		'Jak tylko stąd wyjdę, w końcu sam zostanę kapitanem piratów. Nie potrzebuję kapitana Kida!'
	}}
)

-- Wiadomość powitalna NPC
npcHandler:setMessage(MESSAGE_GREET, "WYCIĄGNIJCIE MNIE STĄD! TERAZ!")

-- Dodanie modułu Focus do NPC
npcHandler:addModule(FocusModule:new())