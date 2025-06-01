local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function creatureSayCallback(cid, type, msg)
	-- Sprawdzamy, czy NPC skupia się na graczu.
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	-- Jeśli gracz powie "soft" lub "boots".
	if isInArray({"soft", "boots"}, msg) then
		-- NPC pyta o chęć naprawy Soft Boots i ustawia temat rozmowy.
		npcHandler:say("Czy chcesz naprawić swoje zniszczone Soft Boots za 10000 złotych monet?", cid)
		npcHandler.topic[cid] = 1
	-- Jeśli gracz odpowie "tak" i temat rozmowy dotyczy naprawy.
	elseif msgcontains(msg, 'yes') and npcHandler.topic[cid] == 1 then
		npcHandler.topic[cid] = 0 -- Resetujemy temat rozmowy.
		-- Sprawdzamy, czy gracz posiada zniszczone Soft Boots (ID 10021).
		if player:getItemCount(10021) == 0 then
			npcHandler:say("Przepraszam, nie masz tego przedmiotu.", cid)
			return true
		end

		-- Sprawdzamy, czy gracz ma wystarczająco pieniędzy.
		if not player:removeMoney(10000) then
			npcHandler:say("Przepraszam, nie masz wystarczająco złota.", cid)
			return true
		end

		-- Usuwamy zniszczone Soft Boots i dodajemy nowe (naprawione, ID 6132).
		player:removeItem(10021, 1)
		player:addItem(6132, 1)
		npcHandler:say("Proszę bardzo.", cid)
	-- Jeśli gracz odpowie "nie" i temat rozmowy dotyczy naprawy.
	elseif msgcontains(msg, 'no') and npcHandler.topic[cid] == 1 then
		npcHandler.topic[cid] = 0 -- Resetujemy temat rozmowy.
		npcHandler:say("Dobrze więc.", cid)
	end
	return true
end

-- Ustawiamy funkcję zwrotną dla domyślnych wiadomości.
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Dodajemy moduł Focus, który zarządza skupieniem NPC na graczu.
npcHandler:addModule(FocusModule:new())