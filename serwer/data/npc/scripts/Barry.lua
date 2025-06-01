local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	-- Obsługa słowa kluczowego "report"
	if msgcontains(msg, 'report') then
		local player = Player(cid)
		-- Sprawdza wartość storageValue gracza, aby określić etap questa
		if isInArray({9, 11}, player:getStorageValue(Storage.InServiceofYalahar.Questline)) then
			npcHandler:say('Och, od czego by tu zacząć... <opowiada o kłopotach, które on i jego ludzie napotkali ostatnio>.', cid)
			-- Aktualizuje storageValue gracza, aby przejść do następnego etapu questa
			player:setStorageValue(Storage.InServiceofYalahar.Questline, player:getStorageValue(Storage.InServiceofYalahar.Questline) + 1)
			player:setStorageValue(Storage.InServiceofYalahar.Mission02, player:getStorageValue(Storage.InServiceofYalahar.Mission02) + 1) -- StorageValue dla Questlog 'Mission 02: Watching the Watchmen'
		end
	-- Obsługa słowa kluczowego "pass"
	elseif msgcontains(msg, 'pass') then
		npcHandler:say('Możesz {przejść} albo do {Dzielnicy Magów}, albo do {Zatopionej Dzielnicy}. Którą wybierasz?', cid)
		npcHandler.topic[cid] = 1 -- Ustawia temat dialogu na 1, aby oczekiwać na wybór dzielnicy
	-- Obsługa wyboru dzielnicy po zapytaniu o "pass"
	elseif npcHandler.topic[cid] == 1 then
		if msgcontains(msg, 'magician') then
			local destination = Position(32885, 31157, 7)
			Player(cid):teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler.topic[cid] = 0 -- Resetuje temat dialogu
		elseif msgcontains(msg, 'sunken') then
			local destination = Position(32884, 31162, 7)
			Player(cid):teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler.topic[cid] = 0 -- Resetuje temat dialogu
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())