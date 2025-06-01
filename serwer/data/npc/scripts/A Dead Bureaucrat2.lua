local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = 'No gdzie ja podziałem ten formularz?' },
	{ text = 'Witaj, Pumin. Tak, witaj.' }
}

npcHandler:addModule(VoiceModule:new(voices))

local function greetCallback(cid)
	npcHandler:setMessage(MESSAGE_GREET, "Witaj " .. (Player(cid):getSex() == PLAYERSEX_FEMALE and "piękna pani" or "przystojny panie") .. ", witaj w atrium Domeny Pumin. Potrzebujemy od ciebie kilku informacji, zanim pozwolimy ci przejść. Dokąd chcesz się udać?")
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "287") then
		local player = Player(cid)
		if player:getStorageValue(Storage.PitsOfInferno.Pumin) == 4 then
			player:setStorageValue(Storage.PitsOfInferno.Pumin, 5)
			npcHandler:say("Jasne, możesz to dostać ode mnie. Proszę bardzo. Do widzenia.", cid)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Do widzenia i nie zapomnij o mnie!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Do widzenia i nie zapomnij o mnie!")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())