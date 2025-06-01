local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(creature, type, msg)
	-- Jeśli wiadomość nie zawiera "hi" ani "hello", NPC wykrzykuje ostrzeżenie.
	if not (msgcontains(msg, 'hi') or msgcontains(msg, 'hello')) then
		npcHandler:say('NATYCHMIAST OPUŚĆ SMOCZE CMENTARZYSKO!', creature.uid)
	end
	npcHandler:onCreatureSay(creature, type, msg)
end
function onThink()				npcHandler:onThink()					end

-- Moduł głosowy NPC, który co jakiś czas wykrzykuje wiadomość.
local voices = { {text = 'AHHHH BÓL WIEKÓW! BÓL!'} }
npcHandler:addModule(VoiceModule:new(voices))

local function greetCallback(cid)
	local player = Player(cid)
	-- Jeśli gracz ma już storage 'Dragonfetish' o wartości 1, NPC go odsyła.
	if player:getStorageValue(Storage.Dragonfetish) == 1 then
		npcHandler:say('NATYCHMIAST OPUŚĆ SMOCZE CMENTARZYSKO!', cid)
		return false
	end

	-- Sprawdza, czy gracz ma przedmiot 2787 (prawdopodobnie grzyby) i usuwa go.
	if not player:removeItem(2787, 1) then
		npcHandler:say('AHHHH BÓL WIEKÓW! POTRZEBUJĘ GRZYBÓW, ABY ULŻYĆ SWOJEMU BÓLOWI! PRZYNIESSŹ MI GRZYBY!', cid)
		return false
	end

	-- Ustawia storage 'Dragonfetish' na 1, dodaje przedmiot 2319 i NPC dziękuje.
	player:setStorageValue(Storage.Dragonfetish, 1)
	player:addItem(2319, 1)
	npcHandler:say('AHHH GRZYBY! TERAZ MÓJ BÓL USTĄPI NA CHWILĘ! WEŹ TO I NATYCHMIAST OPUŚĆ SMOCZE CMENTARZYSKO!', cid)
	return false
end

-- Ustawia funkcję greetCallback jako callback dla powitania.
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
-- Dodaje moduł Focus, który zarządza skupieniem NPC na graczu.
npcHandler:addModule(FocusModule:new())