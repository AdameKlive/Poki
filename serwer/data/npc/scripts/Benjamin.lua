local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{ text = 'Witaj w urzędzie pocztowym!' },
	{ text = 'Jeśli potrzebujesz pomocy z listami lub paczkami, po prostu mnie zapytaj. Mogę wszystko wyjaśnić.' },
	{ text = 'Hej, wyślij od czasu do czasu list do przyjaciela. Utrzymuj kontakt, wiesz.' }
}

npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	if msgcontains(msg, "measurements") then
		local player = Player(cid)
		if player:getStorageValue(Storage.postman.Mission07) >= 1 then
			npcHandler:say("Ach, one nie zmieniają się tak bardzo od dawnych czasów... <opowiada nudną i zagmatwaną historię o ciastku, paczce, sobie i dwóch wiewiórkach, na koniec podaje ci swoje wymiary> ", cid)
			player:setStorageValue(Storage.postman.Mission07, player:getStorageValue(Storage.postman.Mission07) + 1)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Witaj. W czym mogę ci pomóc, |PLAYERNAME|? Poproś mnie o {handluj}, jeśli chcesz coś kupić. Mogę również wyjaśnić system {poczty}.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Miło było ci pomóc, |PLAYERNAME|.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())