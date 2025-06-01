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
	-- Mapowanie ID bazowej profesji na ID przedmiotu
	local items = {[1] = 2190, [2] = 2182} -- 1 to Druid, 2 to Sorcerer (zakładając, że 2190 to rod, 2182 to wand)
	local itemId = items[player:getVocation():getBase():getId()]

	-- Sprawdza, czy gracz pyta o "pierwszą wędkę" lub "pierwszą różdżkę"
	if msgcontains(msg, 'first rod') or msgcontains(msg, 'first wand') then
		-- Sprawdza, czy gracz jest magiem (Druid lub Sorcerer)
		if player:isMage() then
			-- Sprawdza, czy gracz nie otrzymał już pierwszej broni dla maga
			if player:getStorageValue(Storage.firstMageWeapon) == -1 then
				npcHandler:say('Więc prosisz mnie o {' .. ItemType(itemId):getName() .. '} aby rozpocząć swoją przygodę?', cid)
				npcHandler.topic[cid] = 1 -- Ustawia temat NPC na 1, oczekując potwierdzenia
			else
				npcHandler:say('Co? Już dałem ci {' .. ItemType(itemId):getName() .. '}!', cid)
			end
		else
			npcHandler:say('Przepraszam, nie jesteś ani druidem, ani czarodziejem.', cid)
		end
	-- Sprawdza, czy gracz odpowiada "yes" i temat jest ustawiony na 1
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			player:addItem(itemId, 1) -- Dodaje przedmiot do ekwipunku gracza
			npcHandler:say('Oto jesteś, młody adepcie, uważaj na siebie.', cid)
			player:setStorageValue(Storage.firstMageWeapon, 1) -- Ustawia storage, aby zaznaczyć, że broń została już dana
		end
		npcHandler.topic[cid] = 0 -- Resetuje temat
	-- Sprawdza, czy gracz odpowiada "no" i temat jest ustawiony na 1
	elseif msgcontains(msg, 'no') and npcHandler.topic[cid] == 1 then
		npcHandler:say('Dobrze więc.', cid)
		npcHandler.topic[cid] = 0 -- Resetuje temat
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())