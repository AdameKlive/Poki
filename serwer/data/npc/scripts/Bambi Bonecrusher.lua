local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local condition = Condition(CONDITION_FIRE)
condition:setParameter(CONDITION_PARAM_DELAYED, 1)
condition:addDamage(10, 1000, -10) -- Zadaje 10 obrażeń co 1000 ms (1 sekundę) przez czas trwania warunku (nieokreślony, domyślnie 1 tic lub do usunięcia)

local function creatureSayCallback(cid, type, msg)
	-- Sprawdza, czy NPC jest skupiony na graczu.
	if not npcHandler:isFocused(cid) then
		return false
	end

	-- Lista obraźliwych słów.
	if isInArray({"fuck", "idiot", "asshole", "ass", "fag", "stupid", "tyrant", "shit", "lunatic"}, msg) then
		npcHandler:say("Bierz to!", cid) -- Wypowiada groźbę.
		local player = Player(cid)
		player:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONAREA) -- Wysyła efekt magiczny eksplozji.
		player:addCondition(condition) -- Nakłada warunek ognia na gracza.
		npcHandler:releaseFocus(cid) -- NPC przestaje być skupiony na graczu.
		npcHandler:resetNpc(cid) -- Resetuje stan NPC (np. pozycję, zachowanie).
	end
	return true
end

-- Wiadomości NPC na powitanie, pożegnanie i odejście gracza.
npcHandler:setMessage(MESSAGE_GREET, "NIECH ŻYJE KRÓLOWA!")
npcHandler:setMessage(MESSAGE_FAREWELL, "NIECH ŻYJE KRÓLOWA!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "NIECH ŻYJE KRÓLOWA!")

-- Ustawia funkcję zwrotną dla domyślnych wiadomości.
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Dodaje moduł skupienia (FocusModule), aby NPC mógł śledzić interakcje z graczami.
npcHandler:addModule(FocusModule:new())