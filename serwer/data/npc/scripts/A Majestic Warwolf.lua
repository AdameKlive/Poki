local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)          npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)       npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)        end
function onThink()              npcHandler:onThink()                    end

local function greetCallback(cid)
	-- Jeśli gracz nie ma wartości storage'a 9 dla DruidHatAddon, NPC powie "GRRRRRRRRRRRRR"
	if Player(cid):getStorageValue(Storage.OutfitQuest.DruidHatAddon) < 9 then
		npcHandler:say('GRRRRRRRRRRRRR', cid)
		return false
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	-- Jeśli NPC nie skupia się na graczu, nic nie robimy
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	-- Jeśli gracz powie "addon" lub "outfit"
	if isInArray({'addon', 'outfit'}, msg) then
		-- Jeśli gracz ma wartość storage'a 9 dla DruidHatAddon
		if player:getStorageValue(Storage.OutfitQuest.DruidHatAddon) == 9 then
			-- NPC powie, że widzi, iż gracz jest uczciwy i przyjazny, i że nauczył się języka wilków,
			-- oferując specjalny prezent. Ustawia temat rozmowy na 1.
			npcHandler:say('Widzę w twoich oczach, że jesteś osobą uczciwą i życzliwą, |PLAYERNAME|. Byłeś wystarczająco cierpliwy, aby nauczyć się naszego języka, a ja udzielę ci specjalnego prezentu. Przyjmiesz go?', cid)
			npcHandler.topic[cid] = 1
		end
	-- Jeśli gracz powie "yes" i temat rozmowy to 1
	elseif msgcontains(msg, 'yes') and npcHandler.topic[cid] == 1 then
		-- Ustawia wartość storage'a DruidHatAddon na 10
		player:setStorageValue(Storage.OutfitQuest.DruidHatAddon, 10)
		-- Dodaje dodatki do stroju
		player:addOutfitAddon(148, 2)
		player:addOutfitAddon(144, 2)
		-- Wysyła efekt magiczny (niebieski) na pozycję gracza
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		-- NPC powie inną wiadomość w zależności od płci gracza
		npcHandler:say(player:getSex() == PLAYERSEX_FEMALE and 'Od teraz będziesz znana jako |PLAYERNAME|, dziewczyna wilk. Będziesz szybka i sprytna jak Morgrar, wielki biały wilk. On poprowadzi twoją ścieżkę.' or 'Od teraz będziesz znany jako |PLAYERNAME|, wojownik niedźwiedź. Będziesz silny i dumny jak Angros, wielki ciemny niedźwiedź. On poprowadzi twoją ścieżkę.', cid)
		-- Resetuje temat rozmowy
		npcHandler.topic[cid] = 0
	end
	return true
end

-- Ustawia funkcje zwrotne dla NPC
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Ustawia wiadomości powitalne i pożegnalne
npcHandler:setMessage(MESSAGE_GREET, "Interesujące. Człowiek, który potrafi mówić językiem wilków.")
npcHandler:setMessage(MESSAGE_FAREWELL, "YOOOOUHHOOOUU!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "YOOOOUHHOOOUU!")
-- Dodaje moduł FocusModule
npcHandler:addModule(FocusModule:new())