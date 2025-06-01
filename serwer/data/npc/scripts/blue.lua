local storage = quests.indigoLeague.prizes[1].uid
local exitPosition = Position(264, 1074, 7) -- Pozycja wyjścia dla graczy
local pokemons = -- Lista Pokemonów, których używa NPC w walce
{
	[1] = 
		{
			name = "Shiny Pidgeot",
			level = 200
		},
	[2] = 
		{
			name = "Shiny Alakazam",
			level = 200
		},

	[3] = 
		{
			name = "Shiny Rhydon",
			level = 200
		},

	[4] = 
		{
			name = "Shiny Gyarados",
			level = 200
		},

	[5] = 
		{
			name = "Shiny Exeggutor",
			level = 200
		},

	[6] = 
		{
			name = "Shiny Arcanine",
			level = 200
		}
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local function creatureGreetCallback(cid, message)
	if message == nil then
		return true
	end
	if npcHandler:hasFocus() then
		selfSay("Czekaj na swoją kolej, " .. Player(cid):getName() .. "!")
		return false
	end
	return true
end

local function sendToExit(cid)
	local player = Player(cid)
	selfSay("Więcej szczęścia następnym razem, " .. player:getName() .. "!", cid)
	npcHandler:releaseFocus(cid) -- NPC przestaje skupiać się na graczu
	player:setOutLeague() -- Ustawia status gracza jako "poza ligą"
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT) -- Efekt teleportacji w obecnej pozycji
	player:teleportTo(exitPosition) -- Teleportuje gracza do pozycji wyjścia
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT) -- Efekt teleportacji w nowej pozycji
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end	
	if msgcontains(msg, 'bye') or msgcontains(msg, 'no') or msgcontains(msg, 'nie') then
		selfSay('Czekam... Pamiętaj, że zawsze możesz {zrezygnować}', cid)
		npcHandler:releaseFocus(cid) -- NPC przestaje skupiać się na graczu
	elseif msgcontains(msg, 'wyjdz') or msgcontains(msg, 'zrezygnowac') or msgcontains(msg, 'leave') then
		local player = Player(cid)
		if player then
			selfSay('Wróć, gdy będziesz przygotowany!', cid)
			player:teleportTo(exitPosition) -- Teleportuje gracza do pozycji wyjścia
		end
		npcHandler:releaseFocus(cid) -- NPC przestaje skupiać się na graczu
	elseif msgcontains(msg, 'tak') or msgcontains(msg, 'yes') then
		local player = Player(cid)
		if player then
			if player:getStorageValue(storage) > 0 then
				selfSay('Co tu robisz? Już odebrałeś swoją nagrodę!', cid)
				sendToExit(cid) -- Wysyła gracza na wyjście
			else
				selfSay('Oboje znamy wynik... Ale skoro naprawdę chcesz spróbować....', cid)
				npcHandler.topic[cid] = 1 -- Ustawia temat NPC na 1 (rozpoczyna walkę)
				npcHandler:setMaxIdleTime(600) -- Ustawia maksymalny czas bezczynności
				player:setDuelWithNpc() -- Ustawia gracza w tryb pojedynku z NPC
			end
		end
	end
	return true
end

local function creatureOnReleaseFocusCallback(cid)
	local npc = Npc()
	if hasSummons(npc) then
		local monster = npc:getSummons()[1]
		monster:getPosition():sendMagicEffect(balls.pokeball.effectRelease) -- Efekt wypuszczenia pokeballa
		monster:remove() -- Usuwa potwora NPC
	end
	local player = Player(cid)
	if player then
		player:unsetDuelWithNpc() -- Usuwa gracza z trybu pojedynku z NPC
	end
	return true
end

local function creatureOnDisapearCallback(cid)
	local player = Player(cid)
	if not player then
		npcHandler:updateFocus()
		return true
	end
	if npcHandler:isFocused(cid) then
		-- Jeśli gracz jest w zasięgu, nie robi nic (NPC nadal skupia się na nim)
		if getDistanceTo(cid) >= 0 and getDistanceTo(cid) <= 8 then -- Zakładając, że getDistanceTo działa globalnie lub jest zdefiniowane
			return false
		end
		sendToExit(cid) -- Wysyła gracza na wyjście, jeśli się oddalił
	end
	return true
end

local function creatureOnThinkCallback()
	if npcHandler:hasFocus() then
		local npc = Npc()
		local npcPosition = npc:getPosition()
		local spectators = Game.getSpectators(npcPosition, false, true) -- Pobiera graczy w zasięgu widzenia NPC
		for i = 1, #spectators do
			local player = spectators[i]
			local cid = player:getId()
			if npcHandler:isFocused(cid) and npcHandler.topic[cid] == 1 then -- Jeśli NPC skupia się na graczu i temat to walka
				local duelStatus = player:getDuelWithNpcStatus() -- Pobiera status pojedynku gracza
				local monster = npc:getSummons()[1] -- Pobiera aktualnego potwora NPC
				if not monster then -- Jeśli NPC nie ma potwora (pokonał poprzedniego)
					if pokemons[duelStatus] then -- Sprawdza, czy są kolejne Pokemony do walki
						selfSay(pokemons[duelStatus].name .. ", ja wybieram ciebie!")
						npcPosition:getNextPosition(npc:getDirection()) -- Pozycja obok NPC
						monster = Game.createMonster(pokemons[duelStatus].name, npcPosition, false, true, pokemons[duelStatus].level, 0) -- Tworzy nowego potwora
						npcPosition:sendMagicEffect(balls.pokeball.effectRelease) -- Efekt wypuszczenia pokeballa
						monster:setMaster(npc) -- Ustawia NPC jako mistrza potwora
						local health = monster:getTotalHealth() * 10 -- Ustawia dużą ilość zdrowia dla potwora
						monster:setMaxHealth(health)
						monster:setHealth(health)
						monster:changeSpeed(-monster:getSpeed() + monster:getTotalSpeed()) -- Resetuje prędkość
						player:increaseDuelWithNpcStatus() -- Zwiększa status pojedynku gracza (następny Pokemon)
					else
						selfSay('NIE! NIEMOŻLIWE! Pokonałeś mój najlepszy zespół. ' .. player:getName() .. ", choć niechętnie to przyznam, jesteś nowym mistrzem Ligi. Moje gratulacje!", cid)
						player:getPosition():sendMagicEffect(CONST_ME_TELEPORT) -- Efekt teleportacji
						player:teleportTo(exitPosition) -- Teleportuje gracza do wyjścia
						player:getPosition():sendMagicEffect(CONST_ME_TELEPORT) -- Efekt teleportacji
						player:giveQuestPrize(storage) -- Daje graczowi nagrodę za questa
						npcHandler:releaseFocus(cid) -- NPC przestaje skupiać się na graczu
					end
				end
				if hasSummons(player) and hasSummons(npc) then -- Jeśli zarówno gracz, jak i NPC mają Pokemony
					monster:selectTarget(player:getSummons()[1]) -- Pokemon NPC atakuje Pokemona gracza
				end
				local pokeballs = player:getPokeballs() -- Pobiera pokeballe gracza
				local pokemonsAlive = 0
				for i=1, #pokeballs do
					local ball = pokeballs[i]					
					if ball:getSpecialAttribute("pokeHealth") > 0 then -- Sprawdza, czy Pokemon w pokeballu ma HP
						pokemonsAlive = pokemonsAlive + 1
					end
				end
				if pokemonsAlive == 0 then -- Jeśli wszystkie Pokemony gracza są martwe
					sendToExit(cid) -- Wysyła gracza na wyjście
				end
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_ONTHINK, creatureOnThinkCallback)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, creatureOnReleaseFocusCallback)
npcHandler:setCallback(CALLBACK_CREATURE_DISAPPEAR, creatureOnDisapearCallback)
npcHandler:setCallback(CALLBACK_GREET, creatureGreetCallback)
npcHandler:addModule(FocusModule:new())