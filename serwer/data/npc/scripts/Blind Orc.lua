local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function addBuyableKeyword(keywords, itemid, amount, price, text)
	local keyword
	if type(keywords) == 'table' then
		-- Dodaje słowa kluczowe dla zakupu przedmiotu.
		-- "goshak" to prawdopodobnie imię NPC lub ogólne słowo związane z handlem.
		keyword = keywordHandler:addKeyword({'goshak', keywords[1], keywords[2]}, StdModule.say, {npcHandler = npcHandler, text = text})
	else
		keyword = keywordHandler:addKeyword({'goshak', keywords}, StdModule.say, {npcHandler = npcHandler, text = text})
	end

	-- Dodatkowe słowo kluczowe "mok" do potwierdzenia zakupu.
	keyword:addChildKeyword({'mok'}, StdModule.say, {npcHandler = npcHandler, text = 'Maruk rambo zambo!', reset = true},
		function(player) return player:getMoney() >= price end, -- Warunek: gracz ma wystarczająco pieniędzy.
		function(player)
			player:removeMoney(price) -- Usuwa pieniądze.
			player:addItem(itemid, amount) -- Dodaje przedmiot.
		end
	)
	-- Alternatywna odpowiedź, gdy gracz nie ma wystarczająco pieniędzy.
	keyword:addChildKeyword({'mok'}, StdModule.say, {npcHandler = npcHandler, text = 'Maruk nixda!', reset = true})
	-- Domyślna odpowiedź, jeśli nie ma dalszych interakcji.
	keyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Buta maruk klamuk!', reset = true})
end

-- Powitanie i pożegnanie
keywordHandler:addGreetKeyword({'charach'}, {npcHandler = npcHandler, text = 'Ikem Charach maruk.'})
keywordHandler:addFarewellKeyword({'futchi'}, {npcHandler = npcHandler, text = 'Futchi!'})

-- Domyślna odpowiedź, gdy NPC nie jest już skupiony na graczu.
keywordHandler:addKeyword({''}, StdModule.say, {npcHandler = npcHandler, onlyUnfocus = true, text = 'Buta humak!'})

-- Dialogi związane z różnymi kategoriami przedmiotów lub pytaniami ogólnymi.
keywordHandler:addKeyword({'ikem', 'goshak'}, StdModule.say, {npcHandler = npcHandler, text = 'Ikem pashak porak, bata, dora. Ba goshak maruk?'})
keywordHandler:addKeyword({'goshak', 'porak'}, StdModule.say, {npcHandler = npcHandler, text = 'Ikem pashak charcha, burka, burka bata, hakhak. Ba goshak maruk?'})
keywordHandler:addKeyword({'goshak', 'bata'}, StdModule.say, {npcHandler = npcHandler, text = 'Ikem pashak aka bora, tulak bora, grofa. Ba goshak maruk?'})
keywordHandler:addKeyword({'goshak', 'dora'}, StdModule.say, {npcHandler = npcHandler, text = 'Ikem pashak donga. Ba goshak maruk?'})

-- Łuk
addBuyableKeyword('batuk', 2456, 1, 400, 'Ahhhh, maruk, goshak batuk?')
-- 10 Strzał
addBuyableKeyword('pixo', 2544, 10, 30, 'Maruk goshak tefar pixo ul batuk?')

-- Mosiężna Tarcza (Brass Shield)
addBuyableKeyword('donga', 2511, 1, 65, 'Maruk goshak ta?')

-- Skórzana Zbroja (Leather Armor)
addBuyableKeyword('bora', 2467, 1, 25, 'Maruk goshak ta?')
-- Zbroja Nabijana (Studded Armor)
addBuyableKeyword({'tulak', 'bora'}, 2484, 1, 90, 'Maruk goshak ta?')
-- Hełm Nabijany (Studded Helmet)
addBuyableKeyword('grofa', 2482, 1, 60, 'Maruk goshak ta?')

-- Szabla (Sabre)
addBuyableKeyword('charcha', 2385, 1, 25, 'Maruk goshak ta?')
-- Miecz (Sword)
addBuyableKeyword({'burka', 'bata'}, 2376, 1, 85, 'Maruk goshak ta?')
-- Krótki Miecz (Short Sword)
addBuyableKeyword('burka', 2406, 1, 30, 'Maruk goshak ta?')
-- Topór (Hatchet)
addBuyableKeyword('hakhak', 2388, 1, 85, 'Maruk goshak ta?')

-- Wiadomość, gdy NPC odchodzi.
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Futchi.')

npcHandler:addModule(FocusModule:new())