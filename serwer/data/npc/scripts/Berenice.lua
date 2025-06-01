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

	if msgcontains(msg, "misja") then
		if player:getStorageValue(Storage.ExplorerSociety.QuestLine) > 34 then
			npcHandler:say("Najważniejszą misją, jaką obecnie mamy, jest ekspedycja do Calassy.", cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "calassa") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("Ach! Więc słyszałeś o naszej specjalnej misji zbadania rasy Quara w ich naturalnym środowisku! Chciałbyś dowiedzieć się więcej?", cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 4 then
			npcHandler:say("Kapitan Max zabierze cię do Calassy, kiedy tylko będziesz gotów. Proszę, spróbuj odzyskać zaginiony dziennik pokładowy, który musi znajdować się w jednym z zatopionych wraków statków.", cid)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 63)
			player:setStorageValue(Storage.ExplorerSociety.calassaDoor, 1)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 64 then
			npcHandler:say("OCH! Więc bezpiecznie wróciłeś z Calassy! Gratulacje, czy udało ci się odzyskać dziennik pokładowy?", cid)
			npcHandler.topic[cid] = 5
		end
	elseif msgcontains(msg, "tak") then
		if npcHandler.topic[cid] == 2 then
			npcHandler:say({
				"Ponieważ już udowodniłeś, że jesteś wartościowym członkiem naszego stowarzyszenia, z przyjemnością powierzę ci tę misję, ale musisz wiedzieć kilka rzeczy, więc słuchaj uważnie. ...",
				"Calassa to podwodna osada, więc jesteś w poważnym niebezpieczeństwie utonięcia, chyba że jesteś dobrze przygotowany. ...",
				"Opracowaliśmy nowe urządzenie zwane 'Hełmem Głębin' (Helmet of the Deep), które umożliwi ci oddychanie nawet w głębinach oceanu. ...",
				"Instruuję Kapitana Maxa, aby zabrał cię do Calassy i pożyczył ci jeden z tych hełmów. Te hełmy są bardzo cenne, więc wymagany jest depozyt w wysokości 5000 złotych monet. ...",
				"Będąc w Calassie, pod żadnym pozorem nie zdejmuj hełmu. Jeśli masz jakiekolwiek pytania, nie wahaj się zapytać Kapitana Maxa. ...",
				"Twoja misja tam, poza obserwowaniem Quara, polega na odzyskaniu specjalnego dziennika pokładowego z jednego z zatopionych tam wraków. ...",
				"Jedna z naszych ostatnich ekspedycji tam zakończyła się straszliwie, a statek zatonął, ale nadal nie znamy dokładnej przyczyny. ...",
				"Gdybyś mógł odzyskać dziennik pokładowy, wreszcie wiedzielibyśmy, co się stało. Czy zrozumiałeś swoje zadanie i jesteś gotów podjąć to ryzyko?"
			}, cid)
			npcHandler.topic[cid] = 3
		elseif npcHandler.topic[cid] == 3 then
			npcHandler:say("Wspaniale! Natychmiast poinformuję Kapitana Maxa, aby zabrał cię do Calassy, kiedy tylko będziesz gotów. Nie zapomnij o dokładnych przygotowaniach!", cid)
			npcHandler.topic[cid] = 4
		elseif npcHandler.topic[cid] == 5 then
			if player:removeItem(6124, 1) then
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 65)
				npcHandler:say("Tak! To dziennik pokładowy! Jednakże... wydaje się, że woda zniszczyła już wiele stron. To jednak nie twoja wina, zrobiłeś, co mogłeś. Dziękuję!", cid)
				npcHandler.topic[cid] = 0
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())