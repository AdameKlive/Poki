local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

-- Wiadomości głosowe NPC
local voices = { {text = 'Sprzedaję wszelkiego rodzaju magiczny ekwipunek. Przyjdź i zobacz.'} }
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	-- Mapowanie ID przedmiotów do ID profesji (różdżka dla druida, laska dla sorcerera)
	local items = {[1] = 2190, [2] = 2182} -- 1 to Druid, 2 to Sorcerer
	local itemId = items[player:getVocation():getBase():getId()]
	
	-- Sprawdza, czy gracz pyta o "first rod" lub "first wand"
	if msgcontains(msg, 'first rod') or msgcontains(msg, 'first wand') then
		if player:isMage() then
			-- Sprawdza, czy gracz już otrzymał pierwszą broń magiczną
			if player:getStorageValue(Storage.firstMageWeapon) == -1 then
				npcHandler:say('Więc prosisz mnie o {' .. ItemType(itemId):getName() .. '} aby rozpocząć swoją przygodę?', cid)
				npcHandler.topic[cid] = 1 -- Ustawia temat rozmowy na 1 (oczekiwanie na "tak"/"nie")
			else
				npcHandler:say('Co? Już dałem ci jedną {' .. ItemType(itemId):getName() .. '}!', cid)
			end
		else
			npcHandler:say('Przepraszam, nie jesteś ani druidem, ani czarodziejem.', cid)
		end
	-- Sprawdza, czy gracz odpowiada "tak"
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			player:addItem(itemId, 1) -- Dodaje przedmiot do ekwipunku gracza
			npcHandler:say('Proszę młody adepcie, uważaj na siebie.', cid)
			player:setStorageValue(Storage.firstMageWeapon, 1) -- Ustawia storage, że gracz otrzymał broń
		end
		npcHandler.topic[cid] = 0 -- Resetuje temat rozmowy
	-- Sprawdza, czy gracz odpowiada "nie" i temat rozmowy to 1
	elseif msgcontains(msg, 'no') and npcHandler.topic[cid] == 1 then
		npcHandler:say('No dobrze.', cid)
		npcHandler.topic[cid] = 0 -- Resetuje temat rozmowy
	end
	return true
end

-- Dodaje słowo kluczowe 'magic', które wywołuje odpowiedź NPC
keywordHandler:addKeyword({'magic'}, StdModule.say, {npcHandler = npcHandler, text = "Sprzedaję runy, pierścienie życia, różdżki, laski i kryształowe kule. Kupuję również potężne księgi zaklęć. Jeśli chcesz zobaczyć moje oferty, zapytaj mnie o {handel}."})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Witaj |PLAYERNAME|, i witaj w sklepie z {magią}.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Do zobaczenia, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Do zobaczenia, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Oczywiście, po prostu przejrzyj moje towary. Czy chcesz zobaczyć tylko {runy} czy {różdżki}?")
npcHandler:addModule(FocusModule:new())