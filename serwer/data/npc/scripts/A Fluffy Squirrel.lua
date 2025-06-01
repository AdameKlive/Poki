local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)          npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)       npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)        end
function onThink()      npcHandler:onThink()        end

local voices = { {text = 'Chchch'} }
npcHandler:addModule(VoiceModule:new(voices))

-- Dodaje słowo kluczowe 'acorn' (żołądź)
keywordHandler:addKeyword({'acorn'}, StdModule.say, {npcHandler = npcHandler, text = "Chh? Chhh?? <chociaż nie rozumiesz wiewiórczego, ta wydaje się naprawdę podekscytowana>"})

-- Ustawia różne wiadomości NPC
npcHandler:setMessage(MESSAGE_GREET, "Chhchh?") -- Wiadomość powitalna
npcHandler:setMessage(MESSAGE_FAREWELL, "Chh...") -- Wiadomość pożegnalna
npcHandler:setMessage(MESSAGE_WALKAWAY, "Chh...") -- Wiadomość, gdy NPC odchodzi
npcHandler:setMessage(MESSAGE_SENDTRADE, "Chchch. Chh! <nie jesteś pewien, ale wydaje się, że wiewiórka chce wymienić twoje cenne żołędzie na bezużyteczne kamienie, które znalazła i uznała za niejadalne>") -- Wiadomość handlowa

-- Dodaje moduł obsługi skupienia
npcHandler:addModule(FocusModule:new())