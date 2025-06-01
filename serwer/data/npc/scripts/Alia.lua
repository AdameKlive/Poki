local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

-- Twist of Fate (Przeznaczenie Losu)
local blessKeyword = keywordHandler:addKeyword({'twist of fate'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		'To jest specjalne błogosławieństwo, które mogę Ci udzielić, gdy już zdobędziesz przynajmniej jedno z pozostałych błogosławieństw i które działa nieco inaczej. ...',
		'Działa tylko wtedy, gdy zostaniesz zabity przez innych poszukiwaczy przygód, co oznacza, że co najmniej połowa obrażeń prowadzących do Twojej śmierci została spowodowana przez innych, a nie przez potwory czy środowisko. ...',
		'Przeznaczenie losu nie zmniejszy kary za śmierć, jak inne błogosławieństwa, ale zamiast tego zapobiegnie utracie innych błogosławieństw, a także amuletu utraty, jeśli taki nosisz. Kosztuje tyle samo, co inne błogosławieństwa. ...',
		'Czy chciałbyś otrzymać tę ochronę za ofiarę |PVPBLESSCOST| sztuk złota, dziecko?'
	}})
	blessKeyword:addChildKeyword({'tak'}, StdModule.bless, {npcHandler = npcHandler, text = 'Przyjmij więc ochronę przeznaczenia losu, pielgrzymie.', cost = '|PVPBLESSCOST|', bless = 6})
	blessKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'W porządku. Możesz swobodnie odrzucić moją ofertę.', reset = true})

-- Adventurer Stone (Kamień Poszukiwacza Przygód)
keywordHandler:addKeyword({'adventurer stone'}, StdModule.say, {npcHandler = npcHandler, text = 'Dobrze dbaj o swój kamień poszukiwacza przygód.'}, function(player) return player:getItemById(18559, true) end)

local stoneKeyword = keywordHandler:addKeyword({'adventurer stone'}, StdModule.say, {npcHandler = npcHandler, text = 'Ach, chcesz bezpłatnie wymienić swój kamień poszukiwacza przygód?'}, function(player) return player:getStorageValue(Storage.AdventurersGuild.FreeStone.Alia) ~= 1 end)
	stoneKeyword:addChildKeyword({'tak'}, StdModule.say, {npcHandler = npcHandler, text = 'Proszę bardzo. Uważaj.', reset = true}, nil, function(player) player:addItem(18559, 1) player:setStorageValue(Storage.AdventurersGuild.FreeStone.Alia, 1) end)
	stoneKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Nie ma problemu.', reset = true})

local stoneKeyword = keywordHandler:addKeyword({'adventurer stone'}, StdModule.say, {npcHandler = npcHandler, text = 'Ach, chcesz wymienić swój kamień poszukiwacza przygód za 30 sztuk złota?'})
	stoneKeyword:addChildKeyword({'tak'}, StdModule.say, {npcHandler = npcHandler, text = 'Proszę bardzo. Uważaj.', reset = true},
		function(player) return player:getMoney() >= 30 end,
		function(player) player:removeMoney(30) player:addItem(18559, 1) end
	)
	stoneKeyword:addChildKeyword({'tak'}, StdModule.say, {npcHandler = npcHandler, text = 'Przepraszam, nie masz wystarczająco pieniędzy.', reset = true})
	stoneKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Nie ma problemu.', reset = true})

-- Healing (Leczenie)
local function addHealKeyword(text, condition, effect)
	keywordHandler:addKeyword({'heal'}, StdModule.say, {npcHandler = npcHandler, text = text},
		function(player) return player:getCondition(condition) ~= nil end,
		function(player)
			player:removeCondition(condition)
			player:getPosition():sendMagicEffect(effect)
		end
	)
end

addHealKeyword('Płoniesz. Pozwól mi ugasić te płomienie.', CONDITION_FIRE, CONST_ME_MAGIC_GREEN)
addHealKeyword('Jesteś zatruty. Pozwól mi ukoić Twój ból.', CONDITION_POISON, CONST_ME_MAGIC_RED)
addHealKeyword('Jesteś pod wpływem elektryczności, dziecko. Pozwól mi pomóc Ci przestać drżeć.', CONDITION_ENERGY, CONST_ME_MAGIC_GREEN)

keywordHandler:addKeyword({'heal'}, StdModule.say, {npcHandler = npcHandler, text = 'Jesteś ranny, dziecko. Uleczę Twoje rany.'},
	function(player) return player:getHealth() < 40 end,
	function(player)
		local health = player:getHealth()
		if health < 40 then player:addHealth(40 - health) end
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	end
)
keywordHandler:addKeyword({'heal'}, StdModule.say, {npcHandler = npcHandler, text = 'Nie wyglądasz tak źle. Przepraszam, nie mogę Ci pomóc. Ale jeśli szukasz dodatkowej ochrony, powinieneś udać się na {pielgrzymkę} popiołów lub uzyskać ochronę {przeznaczenia losu} tutaj.'})

-- Basic (Podstawowe)
keywordHandler:addKeyword({'pilgrimage'}, StdModule.say, {npcHandler = npcHandler, text = 'Za każdym razem, gdy otrzymasz śmiertelną ranę, Twoja siła życiowa zostaje uszkodzona i istnieje szansa, że stracisz część swojego wyposażenia. Z każdym z pięciu {błogosławieństw}, które posiadasz, to uszkodzenie i szansa na stratę zostaną zmniejszone.'})
keywordHandler:addKeyword({'blessings'}, StdModule.say, {npcHandler = npcHandler, text = 'Dostępnych jest pięć błogosławieństw w pięciu świętych miejscach: {duchowa} tarcza, iskra {feniksa}, {objęcie} Tibii, ogień {słońc} i mądrość {samotności}. Dodatkowo, możesz otrzymać {przeznaczenie losu} tutaj.'})
keywordHandler:addKeyword({'spiritual'}, StdModule.say, {npcHandler = npcHandler, text = 'Widzę, że otrzymałeś duchową tarczę w świątyni białego kwiatu na południe od Thais.'}, function(player) return player:hasBlessing(1) end)
keywordHandler:addAliasKeyword({'tarcza'})
keywordHandler:addKeyword({'embrace'}, StdModule.say, {npcHandler = npcHandler, text = 'Czuję, że druidzi na północ od Carlin zapewnili Ci Objecie Tibii.'}, function(player) return player:hasBlessing(2) end)
keywordHandler:addKeyword({'suns'}, StdModule.say, {npcHandler = npcHandler, text = 'Widzę, że otrzymałeś błogosławieństwo dwóch słońc w wieży słońca w pobliżu Ab\'Dendriel.'}, function(player) return player:hasBlessing(3) end)
keywordHandler:addAliasKeyword({'ogień'})
keywordHandler:addKeyword({'phoenix'}, StdModule.say, {npcHandler = npcHandler, text = 'Czuję, że iskra feniksa została Ci już dana przez krasnoludzkich kapłanów ziemi i ognia w Kazordoon.'}, function(player) return player:hasBlessing(4) end)
keywordHandler:addAliasKeyword({'iskra'})
keywordHandler:addKeyword({'solitude'}, StdModule.say, {npcHandler = npcHandler, text = 'Czuję, że rozmawiałeś już z pustelnikiem Eremo na wyspie Cormaya i otrzymałeś to błogosławieństwo.'}, function(player) return player:hasBlessing(5) end)
keywordHandler:addAliasKeyword({'mądrość'})
keywordHandler:addKeyword({'spiritual'}, StdModule.say, {npcHandler = npcHandler, text = 'Możesz poprosić o błogosławieństwo duchowej tarczy w świątyni białego kwiatu na południe od Thais.'})
keywordHandler:addAliasKeyword({'tarcza'})
keywordHandler:addKeyword({'embrace'}, StdModule.say, {npcHandler = npcHandler, text = 'Druidzi na północ od Carlin zapewnią Ci objęcie Tibii.'})
keywordHandler:addKeyword({'suns'}, StdModule.say, {npcHandler = npcHandler, text = 'Możesz poprosić o błogosławieństwo dwóch słońc w wieży słońca w pobliżu Ab\'Dendriel.'})
keywordHandler:addAliasKeyword({'ogień'})
keywordHandler:addKeyword({'phoenix'}, StdModule.say, {npcHandler = npcHandler, text = 'Iskra feniksa jest dawana przez krasnoludzkich kapłanów ziemi i ognia w Kazordoon.'})
keywordHandler:addAliasKeyword({'iskra'})
keywordHandler:addKeyword({'solitude'}, StdModule.say, {npcHandler = npcHandler, text = 'Porozmawiaj z pustelnikiem Eremo na wyspie Cormaya na temat tego błogosławieństwa.'})
keywordHandler:addAliasKeyword({'mądrość'})

npcHandler:setMessage(MESSAGE_GREET, 'Witaj, młody |PLAYERNAME|! Jeśli jesteś ciężko ranny lub zatruty, mogę Cię {uleczyć} za darmo.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Pamiętaj: Jeśli jesteś ciężko ranny lub zatruty, mogę Cię uleczyć za darmo.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Niech bogowie Cię błogosławią, |PLAYERNAME|!')

npcHandler:addModule(FocusModule:new())