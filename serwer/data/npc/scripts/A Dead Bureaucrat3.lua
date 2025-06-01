local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = 'Gdzie ja podziałem ten formularz?' },
	{ text = 'Witaj Pumin. Tak, witaj.' }
}

npcHandler:addModule(VoiceModule:new(voices))

local function greetCallback(cid)
	npcHandler:setMessage(MESSAGE_GREET, "Witaj " .. (Player(cid):getSex() == PLAYERSEX_FEMALE and "piękna pani" or "przystojny panie") .. ", witamy w atrium Domeny Pumin. Potrzebujemy od Ciebie pewnych informacji, zanim pozwolimy Ci przejść. Dokąd chcesz iść?")
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	local vocation = Vocation(player:getVocation():getBase():getId())

	if msgcontains(msg, "Pumin") then
		if player:getStorageValue(Storage.PitsOfInferno.Pumin) == 2 then
			npcHandler:say("Powiedz mi, czy ci się podobało, gdy wrócisz. Jak masz na imię?", cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, player:getName()) then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("W porządku |PLAYERNAME|. Profesja?", cid)
			npcHandler.topic[cid] = 2
		end
	elseif msgcontains(msg, vocation:getName()) then
		if npcHandler.topic[cid] == 2 then
			npcHandler:say("Ja też byłem " .. vocation:getName() .. ", zanim umarłem! Czego ode mnie chcesz?", cid)
			npcHandler.topic[cid] = 3
		end
	elseif msgcontains(msg, "145") then
		if npcHandler.topic[cid] == 3 then
			player:setStorageValue(Storage.PitsOfInferno.Pumin, 3)
			npcHandler:say("Zgadza się, możesz ode mnie dostać Formularz 145. Jednak najpierw potrzebuję Formularza 411. Wróć, gdy go zdobędziesz.", cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.PitsOfInferno.Pumin) == 6 then
			player:setStorageValue(Storage.PitsOfInferno.Pumin, 7)
			npcHandler:say("Świetnie! Masz formularz 411! Oto Formularz 145. Baw się dobrze.", cid)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Do widzenia i nie zapomnij o mnie!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Do widzenia i nie zapomnij o mnie!")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())