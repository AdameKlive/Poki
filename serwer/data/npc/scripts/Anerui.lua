local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "Jestem panią łowów. W tym miejscu możesz kupić żywność z naszych polowań."})
keywordHandler:addKeyword({'hunt'}, StdModule.say, {npcHandler = npcHandler, text = "Polowanie to sztuka, zbyt często praktykowana przez dyletantów. Każdy głupiec z łukiem lub włócznią uważa się za łowcę."})
keywordHandler:addKeyword({'bow'}, StdModule.say, {npcHandler = npcHandler, text = "Łuk, strzała i włócznia to najlepsi przyjaciele łowców. Na północnym wschodzie miasta jeden z nas może sprzedawać takie narzędzia."})
keywordHandler:addKeyword({'hunter'}, StdModule.say, {npcHandler = npcHandler, text = "Łowcy wiodą życie wolności i bliskości z naturą, w przeciwieństwie do prostego rolnika czy pasterza."})
keywordHandler:addKeyword({'nature'}, StdModule.say, {npcHandler = npcHandler, text = "Natura nie jest przyjacielem, lecz bezlitosnym nauczycielem, a lekcje, które musimy przyswoić, są nieskończone."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = "Obserwuj niebo, ono ci powie."})
keywordHandler:addKeyword({'crunor'}, StdModule.say, {npcHandler = npcHandler, text = "Przypuszczam, że to ludzki bóg dla ludzkiego pojmowania natury. Nie mam zbyt wiele wiedzy o tej istocie."})
keywordHandler:addKeyword({'teshial'}, StdModule.say, {npcHandler = npcHandler, text = "Jeśli kiedykolwiek istnieli, to teraz ich nie ma."})
keywordHandler:addKeyword({'kuridai'}, StdModule.say, {npcHandler = npcHandler, text = "Kuridai są zbyt agresywni nie tylko wobec ludzi, ale także wobec środowiska. Brakuje im zrozumienia równowagi, którą znamy jako naturę."})
keywordHandler:addKeyword({'balance'}, StdModule.say, {npcHandler = npcHandler, text = "Równowaga natury, oczywiście. Jest wszędzie, więc nie pytaj, tylko obserwuj i ucz się."})
keywordHandler:addKeyword({'deraisim'}, StdModule.say, {npcHandler = npcHandler, text = "Staramy się żyć w harmonii z siłami natury, niezależnie od tego, czy są żywe, czy nieożywione."})
keywordHandler:addKeyword({'human'}, StdModule.say, {npcHandler = npcHandler, text = "Ludzie to głośna i brzydka rasa. Brakuje im wdzięku i są bardziej spokrewnieni z orkami niż z nami."})
keywordHandler:addKeyword({'death'}, StdModule.say, {npcHandler = npcHandler, text = "Życie i śmierć są ważnymi częściami równowagi."})
keywordHandler:addKeyword({'life'}, StdModule.say, {npcHandler = npcHandler, text = "Życie i śmierć są ważnymi częściami równowagi."})
keywordHandler:addKeyword({'troll'}, StdModule.say, {npcHandler = npcHandler, text = "Gardzę ich obecnością w naszym mieście, ale może to być konieczne zło."})
keywordHandler:addKeyword({'elf'}, StdModule.say, {npcHandler = npcHandler, text = "To rasa, do której należę."})
keywordHandler:addKeyword({'cenath'}, StdModule.say, {npcHandler = npcHandler, text = "Magia, którą władają, to wszystko, co dla nich ma znaczenie."})

npcHandler:setMessage(MESSAGE_GREET, "Ashari |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Asha Thrazi.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Asha Thrazi.")

local focusModule = FocusModule:new()
focusModule:addGreetMessage({'hi', 'hello', 'witam'})
focusModule:addFarewellMessage({'bye', 'farewell', 'zegnaj'})
npcHandler:addModule(focusModule)