local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

keywordHandler:addKeyword({'hi'}, StdModule.say, {npcHandler = npcHandler, onlyUnfocus = true, text = "PAMIĘTAJ O MANIERACH, PROSTAKU! Aby zwrócić się do królowej, przywitaj się jej tytułem!"})
keywordHandler:addKeyword({'hello'}, StdModule.say, {npcHandler = npcHandler, onlyUnfocus = true, text = "PAMIĘTAJ O MANIERACH, PROSTAKU! Aby zwrócić się do królowej, przywitaj się jej tytułem!"})

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	-- Sprawdza, czy wiadomość zawiera wulgarne lub obraźliwe słowa
	if isInArray({'fuck', 'idiot', 'asshole', 'ass', 'fag', 'stupid', 'tyrant', 'shit', 'lunatic'}, msg) then
		local player = Player(cid)
		local conditions = { CONDITION_POISON, CONDITION_FIRE, CONDITION_ENERGY, CONDITION_BLEEDING, CONDITION_PARALYZE, CONDITION_DROWN, CONDITION_FREEZING, CONDITION_DAZZLED, CONDITION_CURSED }
		
		-- Usuwa negatywne efekty z gracza
		for i = 1, #conditions do
			if player:getCondition(conditions[i]) then
				player:removeCondition(conditions[i])
			end
		end
		
		player:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONAREA) -- Wysyła efekt magiczny na pozycji gracza
		player:addHealth(1 - player:getHealth()) -- Przywraca zdrowie gracza do 1
		npcHandler:say('Weź to!', cid) -- NPC wypowiada wiadomość
		Npc():getPosition():sendMagicEffect(CONST_ME_YELLOW_RINGS) -- Wysyła efekt magiczny na pozycji NPC
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'CHWAŁA KRÓLOWEJ!')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'NIECH ŻYJE KRÓLOWA!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'NIECH ŻYJE KRÓLOWA! Możesz już odejść!')
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

local focusModule = FocusModule:new()
focusModule:addGreetMessage('chwała królowej')
focusModule:addGreetMessage('ukłony królowej')
npcHandler:addModule(focusModule)