local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = '485611800364197.' },
	{ text = '78572611857643646724.' }
}

npcHandler:addModule(VoiceModule:new(voices))

keywordHandler:addKeyword({'death'}, StdModule.say, {npcHandler = npcHandler, text = "Tak, tak, wkrótce cię zabiję, teraz pozwól mi kontynuować moje śledztwo w twojej sprawie."})
keywordHandler:addKeyword({'god'}, StdModule.say, {npcHandler = npcHandler, text = "Będą opłakiwać dzień, w którym nas opuścili."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "Jestem wielkim bibliotekarzem."})
keywordHandler:addKeyword({'library'}, StdModule.say, {npcHandler = npcHandler, text = "To dobra biblioteka, prawda?"})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "Jestem 486486 i NIE 'Blinky', jak niektórzy mnie nazywali... zanim umarli."})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = "To jest 1, a nie 'Tibia', głuptasie."})
keywordHandler:addKeyword({'cyclops'}, StdModule.say, {npcHandler = npcHandler, text = "Wcielenie brzydoty. Jedno oko! Wyobraź to sobie! Okropność!"})
keywordHandler:addKeyword({'elves'}, StdModule.say, {npcHandler = npcHandler, text = "Ci głupcy i ich przesądny kult życia nie rozumieją niczego ważnego."})
keywordHandler:addKeyword({'excalibug'}, StdModule.say, {npcHandler = npcHandler, text = "Tylko gorsze gatunki potrzebują broni."})
keywordHandler:addKeyword({'ab\'dendriel'}, StdModule.say, {npcHandler = npcHandler, text = "Słyszałem, że elfy wprowadziły się na górę."})
keywordHandler:addKeyword({'numbers'}, StdModule.say, {npcHandler = npcHandler, text = "Liczby są kluczowe. Są sekretem kryjącym się za kulisami. Jeśli jesteś mistrzem matematyki, jesteś panem życia i śmierci."})
keywordHandler:addKeyword({'books'}, StdModule.say, {npcHandler = npcHandler, text = "Nasze książki są napisane w 469, oczywiście nie możesz ich zrozumieć."})
keywordHandler:addKeyword({'0'}, StdModule.say, {npcHandler = npcHandler, text = "Idź i umyj oczy za użycie tej obscenicznej liczby!"})
keywordHandler:addKeyword({'469'}, StdModule.say, {npcHandler = npcHandler, text = "Język mojego rodzaju. Lepszy od każdego innego języka i tylko do mówienia przez istoty z wystarczającą liczbą oczu, aby nim mrugnąć."})
keywordHandler:addKeyword({'orcs'}, StdModule.say, {npcHandler = npcHandler, text = "Hałaśliwe szkodniki."})
keywordHandler:addKeyword({'minotaurs'}, StdModule.say, {npcHandler = npcHandler, text = "Ich magowie są tak blisko prawdy. Bliżej niż wiedzą i bliżej niż jest to dla nich dobre."})
keywordHandler:addKeyword({'humans'}, StdModule.say, {npcHandler = npcHandler, text = "Dobre narzędzia do pracy... Po ich śmierci, to jest."})
keywordHandler:addKeyword({'eyes'}, StdModule.say, {npcHandler = npcHandler, text = "Wy, żałosne dwuoczne stworzenia. W naszych oczach wyglądacie dziwnie. To żałosne, jak bardzo zależycie od rąk i nóg. Ponieważ my, bonelordzi, mamy więcej oczu niż jakiekolwiek stworzenie na świecie, jest oczywiste, że wartość gatunku można określić na podstawie liczby jego oczu."})
keywordHandler:addKeyword({'bonelord'}, StdModule.say, {npcHandler = npcHandler, text = "Nasza rasa jest bardzo stara. Przez lata inne rasy nadawały nam wiele różnych imion. Termin bonelord przylgnął do nas już od dłuższego czasu. W naszym języku nazwa naszej rasy nie jest stała, lecz jest złożoną formułą i jako taka zawsze zmienia się dla subiektywnego obserwatora."})
keywordHandler:addKeyword({'language'}, StdModule.say, {npcHandler = npcHandler, text = "Nasz język jest poza zasięgiem zrozumienia przez wasze niższe istoty. W dużej mierze opiera się na matemagii. Wasz mózg nie jest przystosowany do przetwarzania matemagicznego niezbędnego do zrozumienia naszego języka. Aby rozszyfrować nawet nasze najbardziej podstawowe teksty, potrzebny byłby geniusz, który potrafi w ciągu sekund obliczać liczby w swoim mózgu."})

npcHandler:setMessage(MESSAGE_GREET, "Co to jest? Istota z problemami optycznymi zwana |PLAYERNAME|. Jak fascynujące!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Czekaj tu. Zjem cię po zapisaniu tego, co odkryłem.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Czekaj tu. Zjem cię po zapisaniu tego, co odkryłem.")
npcHandler:addModule(FocusModule:new())