local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

-- Funkcja wywoływana, gdy gracz wita się z NPC.
local function greetCallback(cid)
	local player = Player(cid)
	-- Sprawdza, czy gracz ma odpowiedni poziom w linii questowej "The Ice Islands".
	if player:getStorageValue(Storage.TheIceIslands.Questline) < 37 then
		npcHandler:say("Uhhhh...", cid) -- NPC odpowiada niejasno, jeśli gracz nie spełnia warunków.
		return false
	end
	return true
end

-- Funkcja wywoływana, gdy gracz wypowiada coś do NPC.
local function creatureSayCallback(cid, type, msg)
	-- Sprawdza, czy NPC jest skupiony na danym graczu.
	if not npcHandler:isFocused(cid) then
		return false
	end

	-- Jeśli wiadomość gracza zawiera słowo "story" (historia/opowieść).
	if msgcontains(msg, "story") then
		local player = Player(cid)
		-- Sprawdza, czy gracz jest na konkretnym etapie questu.
		if player:getStorageValue(Storage.TheIceIslands.Questline) == 37 then
			npcHandler:say({
				"Zostałem schwytany i torturowany na śmierć przez tutejszych kultystów. Czczą oni istotę, którą nazywają Ghazbaran...",
				"W jego imię zajęli kopalnie i zaczęli topić lód, aby uwolnić armię nikczemnych demonów, które były zamrożone tutaj od wieków...",
				"Ich plan to stworzenie nowej armii demonów dla ich pana, aby podbić świat. Hjaern i inni szamani muszą się o tym dowiedzieć! Pospieszcie się, zanim będzie za późno."
			}, cid)
			-- Aktualizuje wartości storage'ów gracza, postępując w queście.
			player:setStorageValue(Storage.TheIceIslands.Questline, 38)
			player:setStorageValue(Storage.TheIceIslands.Mission10, 2) -- Dziennik zadań The Ice Islands Quest, Kopalnie Formorgar 2: Szeptacz Duchów
			player:setStorageValue(Storage.TheIceIslands.Mission11, 1) -- Dziennik zadań The Ice Islands Quest, Kopalnie Formorgar 3: Sekret
		end
	end
	return true
end

-- Ustawienie funkcji zwrotnych dla NPC.
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Dodanie modułu FocusModule, który zarządza skupieniem NPC na graczu.
npcHandler:addModule(FocusModule:new())