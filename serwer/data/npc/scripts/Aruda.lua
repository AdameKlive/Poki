local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local Price = {} -- Tabela do przechowywania ceny dla konkretnego gracza.

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local voices = { {text = 'Cześć, masz ochotę na pogawędkę?'} }
npcHandler:addModule(VoiceModule:new(voices))

local function greetCallback(cid)
	if Player(cid):getSex() == PLAYERSEX_FEMALE then
		npcHandler:setMessage(MESSAGE_GREET, "Och, witaj |PLAYERNAME|, Twoje włosy wyglądają świetnie! Kto Ci je zrobił?")
		npcHandler.topic[cid] = 1
	else
		npcHandler:setMessage(MESSAGE_GREET, "Och, witaj przystojniaku! To przyjemność Cię poznać, |PLAYERNAME|. Chętnie mam czas na {pogawędkę}.")
		npcHandler.topic[cid] = nil
	end
	Price[cid] = nil
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	local Sex = player:getSex()
	if npcHandler.topic[cid] == 1 then
		npcHandler:say("Nigdy bym się tego nie domyśliła.", cid)
		npcHandler.topic[cid] = nil
	elseif npcHandler.topic[cid] == 2 then
		if player:removeMoney(Price[cid]) then
			npcHandler:say("Ach, przepraszam, byłam rozproszona, co powiedziałeś?", cid)
		else
			npcHandler:say("Och, właśnie przypomniałam sobie, że mam coś do zrobienia, przepraszam. Pa!", cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		end
		npcHandler.topic[cid] = nil
		Price[cid] = nil
	elseif npcHandler.topic[cid] == 3 and player:removeItem(2036, 1) then
		npcHandler:say("Poświęć mi trochę czasu na rozmowę!", cid)
		npcHandler.topic[cid] = nil
	elseif npcHandler.topic[cid] == 4 and (msgcontains(msg, "spouse") or msgcontains(msg, "girlfriend")) then
		npcHandler:say("Cóż... spotkałem go na chwilę... ale to nic poważnego.", cid)
		npcHandler.topic[cid] = 5
	elseif npcHandler.topic[cid] == 5 and msgcontains(msg, "fruit") then
		npcHandler:say("Pamiętam, że winogrona były jego ulubionymi. Był od nich prawie uzależniony.", cid)
		npcHandler.topic[cid] = nil
	elseif msgcontains(msg, "jak") and msgcontains(msg, "masz") and msgcontains(msg, "się") then -- Tłumaczenie "how are you"
		npcHandler:say("Dziękuję bardzo. Jak miło, że się o mnie troszczysz. Mam się dobrze, dziękuję.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "sprzedaj") then
		npcHandler:say("Przepraszam, nie mam nic do sprzedania.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "praca") or msgcontains(msg, "pogawędka") then
		npcHandler:say("Od czasu do czasu wykonuję jakąś pracę. Nic niezwykłego. Mam więc mnóstwo czasu na pogawędki. Jeśli interesuje Cię jakiś temat, po prostu mnie zapytaj.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "imię") then
		if Sex == PLAYERSEX_FEMALE then
			npcHandler:say("Jestem Aruda.", cid)
		else
			npcHandler:say("Och, jestem trochę smutna, że najwyraźniej o mnie zapomniałeś, przystojniaku. Jestem Aruda.", cid)
		end
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "aruda") then
		if Sex == PLAYERSEX_FEMALE then
			npcHandler:say("Tak, to ja!", cid)
		else
			npcHandler:say("Och, podoba mi się, jak wymawiasz moje imię.", cid)
		end
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "czas") then
		npcHandler:say("Proszę, nie bądź tak niegrzeczny, żeby sprawdzać godzinę, gdy ze mną rozmawiasz.", cid)
		npcHandler.topic[cid] = 3
	elseif msgcontains(msg, "pomoc") then
		npcHandler:say("Bardzo mi przykro, nie mogę Ci pomóc.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "potwór") or msgcontains(msg, "loch") then
		npcHandler:say("Uch! Co za przerażający temat. Proszę, porozmawiajmy o czymś przyjemniejszym, w końcu jestem słabą i małą kobietą.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "kanał") then
		npcHandler:say("Co sprawia, że masz wrażenie, iż jestem kobietą, którą można znaleźć w kanałach?", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "bóg") then
		npcHandler:say("O to powinieneś zapytać w jednej ze świątyń.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "król") then
		npcHandler:say("Król, który mieszka w tym fascynującym zamku? Myślę, że wygląda uroczo w swoich luksusowych szatach, prawda?", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 10
	elseif msgcontains(msg, "sam") then
		if Sex == PLAYERSEX_FEMALE then
			npcHandler:say("On jest taaaaki silny! Co za mięśnie! Co za ciało! Czy umówiłaś się z nim na randkę?", cid)
		else
			npcHandler:say("On jest taaaaki silny! Co za mięśnie! Co za ciało! Z drugiej strony, w porównaniu do Ciebie wygląda dość mizernie.", cid)
		end
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "benjamin") then
		npcHandler:say("Jest trochę prostoduszny, ale zawsze miły i dobrze ubrany.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "gorn") then
		npcHandler:say("Powinien naprawdę sprzedawać jakieś stylowe suknie czy coś w tym rodzaju. My, Tibijczycy, nigdy nie dostajemy ubrań z najnowszej mody. To wstyd.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "quentin") then
		npcHandler:say("Nie rozumiem tych samotnych mnichów. Zbyt bardzo kocham towarzystwo, żeby się nim stać. Hehehe!", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "bozo") then
		npcHandler:say("Ach, czyż nie jest zabawny? Mogłabym go słuchać cały dzień.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "oswald") then
		npcHandler:say("O ile wiem, pracuje w zamku.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "plotka") or msgcontains(msg, "gossip") then
		npcHandler:say("Jestem trochę nieśmiała, więc nie słyszę wielu plotek.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "pocałunek") and Sex == PLAYERSEX_MALE then
		npcHandler:say("Och, ty mały diable, przestań tak mówić! <rumieni się>", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 20
	elseif msgcontains(msg, "broń") then
		npcHandler:say("Mało wiem o broni. Czy mógłbyś mi o nich coś opowiedzieć?", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "magia") then
		npcHandler:say("Wierzę, że miłość jest silniejsza od magii, nie zgadzasz się?", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "złodziej") then
		npcHandler:say("Och, przepraszam, muszę się pospieszyć, pa!", cid)
		npcHandler.topic[cid] = nil
		Price[cid] = nil
		npcHandler:releaseFocus(cid)
		npcHandler:resetNpc(cid)
	elseif msgcontains(msg, "tibia") then
		npcHandler:say("Chciałabym częściej odwiedzać plażę, ale chyba jest zbyt niebezpiecznie.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "zamek") then
		npcHandler:say("Kocham ten zamek! Jest taki piękny.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "muriel") then
		npcHandler:say("Potężni czarodzieje trochę mnie przerażają.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "elane") then
		npcHandler:say("Osobiście uważam, że to niewłaściwe, aby kobieta została wojowniczką, co o tym myślisz?", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "marvik") then
		npcHandler:say("Druidzi rzadko odwiedzają miasto, co wiesz o druidach?", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "gregor") then
		npcHandler:say("Lubię odważnych wojowników takich jak on.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "noodles") then
		npcHandler:say("Ach, on jest taaaaki słodki!", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "pies") then
		npcHandler:say("Lubię psy, przynajmniej te małe. Ty też lubisz psy?", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "excalibug") then
		npcHandler:say("Och, jestem tylko dziewczyną i nic nie wiem o magicznych mieczach i tym podobnych rzeczach.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 10
	elseif msgcontains(msg, "partos") then
		npcHandler:say("Ja... nie znam nikogo o takim imieniu.", cid)
		npcHandler.topic[cid] = 4
		Price[cid] = nil
	elseif msgcontains(msg, "yenny") then
		npcHandler:say("Yenny? Nie znam żadnej Yenny, ani nigdy nie używałam tego imienia! Pomyliłeś mnie z kimś innym.", cid)
		npcHandler.topic[cid] = nil
		Price[cid] = nil
		npcHandler:releaseFocus(cid)
		npcHandler:resetNpc(cid)
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Mam nadzieję, że wkrótce się zobaczymy.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Do widzenia, |PLAYERNAME|. Naprawdę mam nadzieję, że wkrótce znowu porozmawiamy.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())