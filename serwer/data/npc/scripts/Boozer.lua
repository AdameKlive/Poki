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
		-- Sprawdza, czy gracz jest na etapie 2 questa i czy ma wymagany przedmiot.
		if player:getStorageValue(Storage.TibiaTales.ultimateBoozeQuest) == 2 and player:removeItem(7495, 1) then
			-- Ustawia etap questa na 3.
			player:setStorageValue(Storage.TibiaTales.ultimateBoozeQuest, 3)
			npcHandler.topic[cid] = 0 -- Resetuje temat NPC.
			
			-- Nagradza gracza.
			player:addItem(5710, 1)
			player:addItem(2152, 10)
			player:addExperience(100, true)
			
			npcHandler:say("Tak! Teraz muszę tylko zbudować własny mały browar, odkryć sekretny przepis, skopiować krasnoludzki trunek i BACH! Znów będę w biznesie! Proszę, weź to jako nagrodę.", cid)
		elseif player:getStorageValue(Storage.TibiaTales.ultimateBoozeQuest) < 1 then
			npcHandler.topic[cid] = 1 -- Ustawia temat NPC na 1 (rozpoczyna quest).
			npcHandler:say("Ciszej! Nie chcę, żeby wszyscy wiedzieli, co kombinuję. Słuchaj, sprawy nie idą zbyt dobrze, potrzebuję nowej atrakcji. Chcesz mi pomóc?", cid)
		end
	elseif msgcontains(msg, "tak") then
		if npcHandler.topic[cid] == 1 then
			-- Rozpoczyna quest dla gracza.
			player:setStorageValue(Storage.TibiaTales.DefaultStart, 1)
			player:setStorageValue(Storage.TibiaTales.ultimateBoozeQuest, 1)
			player:addItem(7496, 1) -- Daje graczowi przedmiot potrzebny do questa.
			
			npcHandler:say("Dobrze! Słuchaj uważnie. Weź tę butelkę i idź do Kazordoon. Potrzebuję próbki ich bardzo specjalnego brązowego piwa. Możesz znaleźć beczkę w ich browarze. Wróć, jak tylko ją zdobędziesz.", cid)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())