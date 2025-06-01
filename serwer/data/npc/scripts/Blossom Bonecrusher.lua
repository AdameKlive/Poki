local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local condition = Condition(CONDITION_FIRE)
condition:setParameter(CONDITION_PARAM_DELAYED, 1)
condition:addDamage(10, 1000, -10)

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	-- Lista wulgaryzmów, które wywołują reakcję NPC
	if isInArray({"fuck", "idiot", "asshole", "ass", "fag", "stupid", "tyrant", "shit", "lunatic"}, msg) then
		npcHandler:say("Bierz to!", cid) -- Wypowiedź NPC
		local player = Player(cid)
		player:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONAREA) -- Efekt magiczny na pozycji gracza
		player:addCondition(condition) -- Nałożenie warunku (ognia) na gracza
		npcHandler:releaseFocus(cid) -- NPC przestaje skupiać się na graczu
		npcHandler:resetNpc(cid) -- Resetuje stan NPC dla gracza
	end
	return true
end

-- Wiadomości NPC przy różnych interakcjach
npcHandler:setMessage(MESSAGE_GREET, "NIECH ŻYJE KRÓLOWA!")
npcHandler:setMessage(MESSAGE_FAREWELL, "NIECH ŻYJE KRÓLOWA!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "NIECH ŻYJE KRÓLOWA!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())