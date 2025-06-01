-- Zaawansowany System NPC od Jiddo

if Modules == nil then
	-- Domyślne słowa do powitania i pożegnania NPC. Powinny być tabelą zawierającą wszystkie takie słowa.
	FOCUS_GREETWORDS = {"czesc", "witaj", "hi"}
	FOCUS_FAREWELLWORDS = {"zegnaj", "do widzenia", "bye"}

	-- Słowa do żądania okna handlu.
	SHOP_TRADEREQUEST = {"handel", "trade"}

	-- Słowo do akceptowania/odrzucania oferty. MOŻE ZAWIERAĆ TYLKO JEDNO POLE! Powinno być tabelą z jedną wartością ciągu.
	SHOP_YESWORD = {"tak", 'y'}
	SHOP_NOWORD = {"nie", 'n'}

	-- Wzorzec używany do uzyskania ilości przedmiotu, którą gracz chce kupić/sprzedać.
	PATTERN_COUNT = "%d+"

	-- Stałe używane do rozróżniania kupna od sprzedaży.
	SHOPMODULE_SELL_ITEM = 1
	SHOPMODULE_BUY_ITEM = 2
	SHOPMODULE_BUY_ITEM_CONTAINER = 3

	-- Stałe używane dla trybu sklepu. Uwaga: addBuyableItemContainer działa we wszystkich trybach
	SHOPMODULE_MODE_TALK = 1 -- Stary system używany przed wersją klienta 8.2: sprzedaj/kup nazwę przedmiotu
	SHOPMODULE_MODE_TRADE = 2 -- System okna handlu wprowadzony w wersji klienta 8.2
	SHOPMODULE_MODE_BOTH = 3 -- Oba działające jednocześnie

	-- Używany tryb sklepu
	SHOPMODULE_MODE = SHOPMODULE_MODE_BOTH

	Modules = {
		parseableModules = {}
	}

	StdModule = {}

	-- Te funkcje callback muszą być wywołane z parameters.npcHandler = npcHandler w tabeli parameters, inaczej nie będą działać poprawnie.
	-- Uwaga: Członkowie StdModule nie zostali jeszcze przetestowani. Jeśli znajdziesz jakieś błędy, zgłoś je do mnie.
	-- Użycie:
		-- keywordHandler:addKeyword({"oferta"}, StdModule.say, {npcHandler = npcHandler, text = "Sprzedaję wiele potężnych broni białych."})
	function StdModule.say(cid, message, keywords, parameters, node)
		local npcHandler = parameters.npcHandler
		if npcHandler == nil then
			error("StdModule.say wywołane bez instancji npcHandler.")
		end

		if parameters.onlyFocus == true and parameters.onlyUnfocus == true then
			error("StdModule.say sprzeczne parametry 'onlyFocus' i 'onlyUnfocus' oba true")
		end

		local onlyFocus = (parameters.onlyFocus == nil and parameters.onlyUnfocus == nil or parameters.onlyFocus == true)
		if not npcHandler:isFocused(cid) and onlyFocus then
			return false
		end

		if npcHandler:isFocused(cid) and parameters.onlyUnfocus == true then
			return false
		end

		local player = Player(cid)
		local cost, costMessage = parameters.cost, '%d złotych monet'
		if cost and cost > 0 then
			if parameters.discount then
				cost = cost - StdModule.travelDiscount(player, parameters.discount)
			end

			costMessage = cost > 0 and string.format(costMessage, cost) or 'za darmo'
		else
			costMessage = 'za darmo'
		end

		local parseInfo = {[TAG_PLAYERNAME] = player:getName(), [TAG_TIME] = getTibianTime(), [TAG_BLESSCOST] = getBlessingsCost(player:getLevel()), [TAG_PVPBLESSCOST] = getPvpBlessingCost(player:getLevel()), [TAG_TRAVELCOST] = costMessage}
		if parameters.text then
			npcHandler:say(npcHandler:parseMessage(parameters.text, parseInfo), cid, parameters.publicize and true)
		end

		if parameters.ungreet then
			npcHandler:resetNpc(cid)
			npcHandler:releaseFocus(cid)
		elseif parameters.reset then
			npcHandler:resetNpc(cid)
		elseif parameters.moveup ~= nil then
			npcHandler.keywordHandler:moveUp(cid, parameters.moveup)
		end

		return true
	end

	--Użycie:
		-- local node1 = keywordHandler:addKeyword({"promuj"}, StdModule.say, {npcHandler = npcHandler, text = "Mogę cię promować za 20000 złotych monet. Chcesz, żebym cię promował?"})
		-- 		node1:addChildKeyword({"tak"}, StdModule.promotePlayer, {npcHandler = npcHandler, cost = 20000, level = 20}, text = "Gratulacje! Zostałeś promowany.")
		-- 		node1:addChildKeyword({"nie"}, StdModule.say, {npcHandler = npcHandler, text = "W porządku. Wróć, gdy będziesz gotowy."}, reset = true)
	function StdModule.promotePlayer(cid, message, keywords, parameters, node)
		local npcHandler = parameters.npcHandler
		if npcHandler == nil then
			error("StdModule.promotePlayer wywołane bez instancji npcHandler.")
		end
		if not npcHandler:isFocused(cid) then
			return false
		end

		local player = Player(cid)
		if player:isPremium() then
			if player:getStorageValue(Storage.Promotion) == 1 then
				npcHandler:say("Jesteś już promowany!", cid)
			elseif player:getLevel() < parameters.level then
				npcHandler:say("Przepraszam, ale mogę cię promować dopiero po osiągnięciu poziomu " .. parameters.level .. ".", cid)
			elseif not player:removeMoney(parameters.cost) then
				npcHandler:say("Nie masz wystarczająco pieniędzy!", cid)
			else
				player:setStorageValue(Storage.Promotion, 1)
				player:setVocation(player:getVocation():getPromotion())
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				npcHandler:say(parameters.text or "Gratulacje! Zostałeś promowany. Odwiedź PokeTibijka.pl by zobaczyć wszystkie zmiany! Deweloper: AdameK.", cid)
			end
		else
			npcHandler:say("Potrzebujesz konta premium, aby zostać promowanym.", cid)
		end
		npcHandler:resetNpc(cid)
		return true
	end

	function StdModule.learnSpell(cid, message, keywords, parameters, node)
		local npcHandler = parameters.npcHandler
		if npcHandler == nil then
			error("StdModule.learnSpell wywołane bez instancji npcHandler.")
		end

		if not npcHandler:isFocused(cid) then
			return false
		end

		local player = Player(cid)
		if player:hasLearnedSpell(parameters.spellName) then
			npcHandler:say("Już znasz to zaklęcie.", cid)
		elseif player:getLevel() < parameters.level then
			npcHandler:say("Musisz mieć poziom " .. parameters.level .. ", aby nauczyć się tego zaklęcia.", cid)
		elseif not player:removeMoney(parameters.price) then
			npcHandler:say("Wróć, gdy będziesz miał wystarczająco złota.", cid)
		else
			npcHandler:say("Proszę. Spójrz w swoją księgę zaklęć, aby zobaczyć wymowę tego zaklęcia.", cid)
			player:learnSpell(parameters.spellName)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		end

		npcHandler:resetNpc(cid)
		return true
	end

	function StdModule.bless(cid, message, keywords, parameters, node)
		local npcHandler = parameters.npcHandler
		if npcHandler == nil then
			error("StdModule.bless wywołane bez instancji npcHandler.")
		end

		if not npcHandler:isFocused(cid) then
			return false
		end

		local player = Player(cid)
		local parseInfo = {[TAG_BLESSCOST] = getBlessingsCost(player:getLevel()), [TAG_PVPBLESSCOST] = getPvpBlessingCost(player:getLevel())}
		if player:hasBlessing(parameters.bless) then
			npcHandler:say("Już posiadasz to błogosławieństwo.", cid)
		elseif parameters.bless == 4 and player:getStorageValue(Storage.KawillBlessing) ~= 1 then
			npcHandler:say("Najpierw potrzebujesz błogosławieństwa wielkiego geomanty.", cid)
		elseif parameters.bless == 6 and player:getBlessings() == 0 and not player:getItemById(2173, true) then
			npcHandler:say("Nie masz żadnych innych błogosławieństw ani amuletu utraty, więc nie miałoby sensu udzielać ci tej ochrony teraz. Pamiętaj, że może ona chronić cię tylko przed utratą tych!", cid)
		elseif not player:removeMoney(type(parameters.cost) == "string" and npcHandler:parseMessage(parameters.cost, parseInfo) or parameters.cost) then
			npcHandler:say("Och. Nie masz wystarczająco pieniędzy.", cid)
		else
			npcHandler:say(parameters.text or "Zostałeś pobłogosławiony przez jednego z pięciu bogów!", cid)
			if parameters.bless == 4 then
				player:setStorageValue(Storage.KawillBlessing, 0)
			end
			player:addBlessing(parameters.bless)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		end

		npcHandler:resetNpc(cid)
		return true
	end

	function StdModule.travel(cid, message, keywords, parameters, node)
		local npcHandler = parameters.npcHandler
		if npcHandler == nil then
			error("StdModule.travel wywołane bez instancji npcHandler.")
		end

		if not npcHandler:isFocused(cid) then
			return false
		end

		local player = Player(cid)
		local cost = parameters.cost
		if cost and cost > 0 then
			if parameters.discount then
				cost = cost - StdModule.travelDiscount(player, parameters.discount)

				if cost < 0 then
					cost = 0
				end
			end
		else
			cost = 0
		end

		if parameters.premium and not player:isPremium() then
			npcHandler:say("Przepraszam, ale musisz być VIPem!", cid)
		elseif parameters.level and player:getLevel() < parameters.level then
			npcHandler:say("Musisz osiągnąć poziom " .. parameters.level .. " zanim.", cid)
		elseif player:isPzLocked() then
			npcHandler:say("Najpierw pozbądź się tych plam krwi! Nie zrujnujesz mi pojazdu!", cid)
		elseif not player:removeMoney(cost) then
			npcHandler:say("Nie posiadasz wystarczająco pieniędzy.", cid)
		else
			npcHandler:releaseFocus(cid)
			npcHandler:say(parameters.text or "Miłej podróży!", cid)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

			local destination = parameters.destination
			if type(destination) == 'function' then
				destination = destination(player)
			end

			player:teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
		end

		npcHandler:resetNpc(cid)
		return true
	end

	FocusModule = {
		npcHandler = nil,
		greetWords = nil,
		farewellWords = nil,
		greetCallback = nil,
		farewellCallback = nil
	}

	-- Tworzy nową instancję FocusModule bez powiązanego NpcHandler.
	function FocusModule:new()
		local obj = {}
		setmetatable(obj, self)
		self.__index = self
		return obj
	end

	-- Inicjuje moduł i przypisuje do niego handler.
	function FocusModule:init(handler)
		self.npcHandler = handler

		local greetWords = self.greetWords or FOCUS_GREETWORDS
		for _, word in pairs(greetWords) do
			local obj = {}
			obj[#obj + 1] = word
			obj.callback = self.greetCallback or FocusModule.messageMatcherDefault
			handler.keywordHandler:addKeyword(obj, FocusModule.onGreet, {module = self})
		end

		local farewellWords = self.farewellWords or FOCUS_FAREWELLWORDS
		for _, word in pairs(farewellWords) do
			local obj = {}
			obj[#obj + 1] = word
			obj.callback = self.farewellCallback or FocusModule.messageMatcherDefault
			handler.keywordHandler:addKeyword(obj, FocusModule.onFarewell, {module = self})
		end

		return true
	end

	-- Ustawia niestandardowe komunikaty powitalne
	function FocusModule:addGreetMessage(message)
		if not self.greetWords then
			self.greetWords = {}
		end


		if type(message) == 'string' then
			table.insert(self.greetWords, message)
		else
			for i = 1, #message do
				table.insert(self.greetWords, message[i])
			end
		end
	end

	-- Ustawia niestandardowe komunikaty pożegnalne
	function FocusModule:addFarewellMessage(message)
		if not self.farewellWords then
			self.farewellWords = {}
		end

		if type(message) == 'string' then
			table.insert(self.farewellWords, message)
		else
			for i = 1, #message do
				table.insert(self.farewellWords, message[i])
			end
		end
	end

	-- Ustawia niestandardowy callback powitalny
	function FocusModule:setGreetCallback(callback)
		self.greetCallback = callback
	end

	-- Ustawia niestandardowy callback pożegnalny
	function FocusModule:setFarewellCallback(callback)
		self.farewellCallback = callback
	end

	-- Funkcja callback powitalna.
	function FocusModule.onGreet(cid, message, keywords, parameters)
		parameters.module.npcHandler:onGreet(cid, message)
		return true
	end

	-- Funkcja callback pożegnalna.
	function FocusModule.onFarewell(cid, message, keywords, parameters)
		if parameters.module.npcHandler:isFocused(cid) then
			parameters.module.npcHandler:onFarewell(cid)
			return true
		else
			return false
		end
	end

	-- Niestandardowa funkcja callback dopasowująca wiadomości powitalne.
	function FocusModule.messageMatcherDefault(keywords, message)
		for _, word in pairs(keywords) do
			if type(word) == "string" then
				if string.find(message, word) and not string.find(message, "[%w+]" .. word) and not string.find(message, word .. "[%w+]") then
					return true
				end
			end
		end
		return false
	end

	function FocusModule.messageMatcherStart(keywords, message)
		for _, word in pairs(keywords) do
			if type(word) == "string" then
				if string.starts(message, word) then
					return true
				end
			end
		end
		return false
	end

	KeywordModule = {
		npcHandler = nil
	}
	-- Dodaje go do listy parsowalnych modułów.
	Modules.parseableModules["module_keywords"] = KeywordModule

	function KeywordModule:new()
		local obj = {}
		setmetatable(obj, self)
		self.__index = self
		return obj
	end

	function KeywordModule:init(handler)
		self.npcHandler = handler
		return true
	end

	-- Parsuje wszystkie znane parametry.
	function KeywordModule:parseParameters()
		local ret = NpcSystem.getParameter("keywords")
		if ret ~= nil then
			self:parseKeywords(ret)
		end
	end

	function KeywordModule:parseKeywords(data)
		local n = 1
		for keys in string.gmatch(data, "[^;]+") do
			local i = 1

			local keywords = {}
			for temp in string.gmatch(keys, "[^,]+") do
				keywords[#keywords + 1] = temp
				i = i + 1
			end

			if i ~= 1 then
				local reply = NpcSystem.getParameter("keyword_reply" .. n)
				if reply ~= nil then
					self:addKeyword(keywords, reply)
				else
					print("[Ostrzeżenie : " .. Npc():getName() .. "] NpcSystem:", "Brakujący parametr '" .. "keyword_reply" .. n .. "'. Pomijanie...")
				end
			else
				print("[Ostrzeżenie : " .. Npc():getName() .. "] NpcSystem:", "Nie znaleziono słów kluczowych dla zestawu słów kluczowych #" .. n .. ". Pomijanie...")
			end

			n = n+1
		end
	end

	function KeywordModule:addKeyword(keywords, reply)
		self.npcHandler.keywordHandler:addKeyword(keywords, StdModule.say, {npcHandler = self.npcHandler, text = reply, reset = true})
	end

	TravelModule = {
		npcHandler = nil,
		destinations = nil,
		yesNode = nil,
		noNode = nil,
	}
	-- Dodaje go do listy parsowalnych modułów.
	Modules.parseableModules["module_travel"] = TravelModule

	function TravelModule:new()
		local obj = {}
		setmetatable(obj, self)
		self.__index = self
		return obj
	end

	function TravelModule:init(handler)
		self.npcHandler = handler
		self.yesNode = KeywordNode:new(SHOP_YESWORD, TravelModule.onConfirm, {module = self})
		self.noNode = KeywordNode:new(SHOP_NOWORD, TravelModule.onDecline, {module = self})
		self.destinations = {}
		return true
	end

	-- Parsuje wszystkie znane parametry.
	function TravelModule:parseParameters()
		local ret = NpcSystem.getParameter("travel_destinations")
		if ret ~= nil then
			self:parseDestinations(ret)

			self.npcHandler.keywordHandler:addKeyword({"cel"}, TravelModule.listDestinations, {module = self})
			self.npcHandler.keywordHandler:addKeyword({"gdzie"}, TravelModule.listDestinations, {module = self})
			self.npcHandler.keywordHandler:addKeyword({"podroz"}, TravelModule.listDestinations, {module = self})

		end
	end

	function TravelModule:parseDestinations(data)
		for destination in string.gmatch(data, "[^;]+") do
			local i = 1

			local name = nil
			local x = nil
			local y = nil
			local z = nil
			local cost = nil
			local premium = false

			for temp in string.gmatch(destination, "[^,]+") do
				if i == 1 then
					name = temp
				elseif i == 2 then
					x = tonumber(temp)
				elseif i == 3 then
					y = tonumber(temp)
				elseif i == 4 then
					z = tonumber(temp)
				elseif i == 5 then
					cost = tonumber(temp)
				elseif i == 6 then
					premium = temp == "true"
				else
					print("[Ostrzeżenie : " .. Npc():getName() .. "] NpcSystem:", "Nieznany parametr znaleziony w parametrze celu podróży.", temp, destination)
				end
				i = i + 1
			end

			if(name ~= nil and x ~= nil and y ~= nil and z ~= nil and cost ~= nil) then
				self:addDestination(name, {x=x, y=y, z=z}, cost, premium)
			else
				print("[Ostrzeżenie : " .. Npc():getName() .. "] NpcSystem:", "Brakujące parametry dla celu podróży:", name, x, y, z, cost, premium)
			end
		end
	end

	function TravelModule:addDestination(name, position, price, premium)
		self.destinations[#self.destinations + 1] = name

		local parameters = {
			cost = price,
			destination = position,
			premium = premium,
			module = self
		}
		local keywords = {}
		keywords[#keywords + 1] = name

		local keywords2 = {}
		keywords2[#keywords2 + 1] = "zabierz mnie do " .. name
		local node = self.npcHandler.keywordHandler:addKeyword(keywords, TravelModule.travel, parameters)
		self.npcHandler.keywordHandler:addKeyword(keywords2, TravelModule.bringMeTo, parameters)
		node:addChildKeywordNode(self.yesNode)
		node:addChildKeywordNode(self.noNode)

		if npcs_loaded_travel[getNpcCid()] == nil then
			npcs_loaded_travel[getNpcCid()] = getNpcCid()
			self.npcHandler.keywordHandler:addKeyword({'tak'}, TravelModule.onConfirm, {module = self})
			self.npcHandler.keywordHandler:addKeyword({'nie'}, TravelModule.onDecline, {module = self})
		end
	end

	function TravelModule.travel(cid, message, keywords, parameters, node)
		local module = parameters.module
		if(not module.npcHandler:isFocused(cid)) then
			return false
		end

		local npcHandler = module.npcHandler

		shop_destination[cid] = parameters.destination
		shop_cost[cid] = parameters.cost
		shop_premium[cid] = parameters.premium
		shop_npcuid[cid] = getNpcCid()

		local cost = parameters.cost
		local destination = parameters.destination
		local premium = parameters.premium

		module.npcHandler:say("Czy chcesz podróżować do " .. keywords[1] .. " za " .. cost .. " złotych monet?", cid)
		return true
	end

	function TravelModule.onConfirm(cid, message, keywords, parameters, node)
		local module = parameters.module
		if not module.npcHandler:isFocused(cid) or shop_npcuid[cid] ~= getNpcCid() then
			return false
		end
		shop_npcuid[cid] = 0

		local parentParameters = node:getParent():getParameters()
		local cost = shop_cost[cid]
		local destination = shop_destination[cid]
		local premium = shop_premium[cid]

		local player = Player(cid)
		if not isPlayerPremiumCallback or isPlayerPremiumCallback(player) or shop_premium[cid] ~= true then
			if not player:removeMoney(cost) then
				npcHandler:say("Nie masz wystarczająco pieniędzy!", cid)
			elseif player:isPzLocked() then
				npcHandler:say("Pozbądź się tej krwi! Nie zrujnujesz mi pojazdu!", cid)
			else
				npcHandler:say("Z przyjemnością prowadziłem z Tobą interesy.", cid)
				npcHandler:releaseFocus(cid)
				-- Do zrobienia: przekonwertować wszystkie parametry celu na Position(x, y, z) zamiast tabel lua
				player:teleportTo(destination)
				Position(destination):sendMagicEffect(CONST_ME_TELEPORT)
			end
		else
			npcHandler:say("Mogę pozwolić tylko graczom premium podróżować tam.", cid)
		end

		npcHandler:resetNpc(cid)
		return true
	end

	-- Funkcja callback słowa kluczowego onDecline(). Ogólnie wywoływana, gdy gracz powie "nie" po chęci zakupu przedmiotu.
	function TravelModule.onDecline(cid, message, keywords, parameters, node)
		local module = parameters.module
		if not module.npcHandler:isFocused(cid) or shop_npcuid[cid] ~= getNpcCid() then
			return false
		end
		shop_npcuid[cid] = 0

		local parentParameters = node:getParent():getParameters()
		local parseInfo = { [TAG_PLAYERNAME] = Player(cid):getName() }
		local msg = module.npcHandler:parseMessage(module.npcHandler:getMessage(MESSAGE_DECLINE), parseInfo)
		module.npcHandler:say(msg, cid)
		module.npcHandler:resetNpc(cid)
		return true
	end

	function TravelModule.bringMeTo(cid, message, keywords, parameters, node)
		local module = parameters.module
		if not module.npcHandler:isFocused(cid) then
			return false
		end

		local cost = parameters.cost
		local destination = parameters.destination
		local premium = parameters.premium

		if(not isPlayerPremiumCallback or isPlayerPremiumCallback(cid) or parameters.premium ~= true) then
			local player = Player(cid)
			if player:removeMoney(cost) then
				player:teleportTo(destination)
				Position(destination):sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
		return true
	end

	function TravelModule.listDestinations(cid, message, keywords, parameters, node)
		local module = parameters.module
		if not module.npcHandler:isFocused(cid) then
			return false
		end

		local msg = "Mogę cię zabrać do "
		--local i = 1
		local maxn = #module.destinations
		for i, destination in pairs(module.destinations) do
			msg = msg .. destination
			if i == maxn - 1 then
				msg = msg .. " i "
			elseif i == maxn then
				msg = msg .. "."
			else
				msg = msg .. ", "
			end
			i = i + 1
		end

		module.npcHandler:say(msg, cid)
		module.npcHandler:resetNpc(cid)
		return true
	end

	ShopModule = {
		npcHandler = nil,
		yesNode = nil,
		noNode = nil,
		noText = "",
		maxCount = 100,
		amount = 0
	}

	-- Dodaje go do listy parsowalnych modułów.
	Modules.parseableModules["module_shop"] = ShopModule

	-- Tworzy nową instancję ShopModule
	function ShopModule:new()
		local obj = {}
		setmetatable(obj, self)
		self.__index = self
		return obj
	end

	-- Parsuje wszystkie znane parametry.
	function ShopModule:parseParameters()
		local ret = NpcSystem.getParameter("shop_buyable")
		if ret ~= nil then
			self:parseBuyable(ret)
		end

		local ret = NpcSystem.getParameter("shop_sellable")
		if ret ~= nil then
			self:parseSellable(ret)
		end

		local ret = NpcSystem.getParameter("shop_buyable_containers")
		if ret ~= nil then
			self:parseBuyableContainers(ret)
		end
	end

	-- Parsuje ciąg zawierający zestaw przedmiotów do kupienia.
	function ShopModule:parseBuyable(data)
		for item in string.gmatch(data, "[^;]+") do
			local i = 1

			local name = nil
			local itemid = nil
			local cost = nil
			local subType = nil
			local realName = nil

			for temp in string.gmatch(item, "[^,]+") do
				if i == 1 then
					name = temp
				elseif i == 2 then
					itemid = tonumber(temp)
				elseif i == 3 then
					cost = tonumber(temp)
				elseif i == 4 then
					subType = tonumber(temp)
				elseif i == 5 then
					realName = temp
				else
					print("[Ostrzeżenie : " .. Npc():getName() .. "] NpcSystem:", "Nieznany parametr znaleziony w parametrze przedmiotów do kupienia.", temp, item)
				end
				i = i + 1
			end

			if SHOPMODULE_MODE == SHOPMODULE_MODE_TRADE then
				if itemid ~= nil and cost ~= nil then
					if subType == nil and ItemType(itemid):isFluidContainer() then
						print("[Ostrzeżenie : " .. Npc():getName() .. "] NpcSystem:", "Brakujący SubType dla parametru przedmiotu:", item)
					else
						self:addBuyableItem(nil, itemid, cost, subType, realName)
					end
				else
					print("[Ostrzeżenie : " .. Npc():getName() .. "] NpcSystem:", "Brakujące parametry dla przedmiotu:", itemid, cost)
				end
			else
				if name ~= nil and itemid ~= nil and cost ~= nil then
					if subType == nil and ItemType(itemid):isFluidContainer() then
						print("[Ostrzeżenie : " .. Npc():getName() .. "] NpcSystem:", "Brakujący SubType dla parametru przedmiotu:", item)
					else
						local names = {}
						names[#names + 1] = name
						self:addBuyableItem(names, itemid, cost, subType, realName)
					end
				else
					print("[Ostrzeżenie : " .. Npc():getName() .. "] NpcSystem:", "Brakujące parametry dla przedmiotu:", name, itemid, cost)
				end
			end
		end
	end

	-- Parsuje ciąg zawierający zestaw przedmiotów do sprzedania.
	function ShopModule:parseSellable(data)
		for item in string.gmatch(data, "[^;]+") do
			local i = 1

			local name = nil
			local itemid = nil
			local cost = nil
			local realName = nil
			local subType = nil

			for temp in string.gmatch(item, "[^,]+") do
				if i == 1 then
					name = temp
				elseif i == 2 then
					itemid = tonumber(temp)
				elseif i == 3 then
					cost = tonumber(temp)
				elseif i == 4 then
					realName = temp
				elseif i == 5 then
					subType = tonumber(temp)
				else
					print("[Ostrzeżenie : " .. Npc():getName() .. "] NpcSystem:", "Nieznany parametr znaleziony w parametrze przedmiotów do sprzedania.", temp, item)
				end
				i = i + 1
			end

			if SHOPMODULE_MODE == SHOPMODULE_MODE_TRADE then
				if itemid ~= nil and cost ~= nil then
					self:addSellableItem(nil, itemid, cost, realName, subType)
				else
					print("[Ostrzeżenie : " .. Npc():getName() .. "] NpcSystem:", "Brakujące parametry dla przedmiotu:", itemid, cost)
				end
			else
				if name ~= nil and itemid ~= nil and cost ~= nil then
					local names = {}
					names[#names + 1] = name
					self:addSellableItem(names, itemid, cost, realName, subType)
				else
					print("[Ostrzeżenie : " .. Npc():getName() .. "] NpcSystem:", "Brakujące parametry dla przedmiotu:", name, itemid, cost)
				end
			end
		end
	end

	-- Parsuje ciąg zawierający zestaw przedmiotów do kupienia (kontenerów).
	function ShopModule:parseBuyableContainers(data)
		for item in string.gmatch(data, "[^;]+") do
			local i = 1

			local name = nil
			local container = nil
			local itemid = nil
			local cost = nil
			local subType = nil
			local realName = nil

			for temp in string.gmatch(item, "[^,]+") do
				if i == 1 then
					name = temp
				elseif i == 2 then
					itemid = tonumber(temp)
				elseif i == 3 then
					itemid = tonumber(temp)
				elseif i == 4 then
					cost = tonumber(temp)
				elseif i == 5 then
					subType = tonumber(temp)
				elseif i == 6 then
					realName = temp
				else
					print("[Ostrzeżenie : " .. Npc():getName() .. "] NpcSystem:", "Nieznany parametr znaleziony w parametrze przedmiotów do kupienia.", temp, item)
				end
				i = i + 1
			end

			if name ~= nil and container ~= nil and itemid ~= nil and cost ~= nil then
				if subType == nil and ItemType(itemid):isFluidContainer() then
					print("[Ostrzeżenie : " .. Npc():getName() .. "] NpcSystem:", "Brakujący SubType dla parametru przedmiotu:", item)
				else
					local names = {}
					names[#names + 1] = name
					self:addBuyableItemContainer(names, container, itemid, cost, subType, realName)
				end
			else
				print("[Ostrzeżenie : " .. Npc():getName() .. "] NpcSystem:", "Brakujące parametry dla przedmiotu:", name, container, itemid, cost)
			end
		end
	end

	-- Inicjuje moduł i przypisuje do niego handler.
	function ShopModule:init(handler)
		self.npcHandler = handler
		self.yesNode = KeywordNode:new(SHOP_YESWORD, ShopModule.onConfirm, {module = self})
		self.noNode = KeywordNode:new(SHOP_NOWORD, ShopModule.onDecline, {module = self})
		self.noText = handler:getMessage(MESSAGE_DECLINE)

		if SHOPMODULE_MODE ~= SHOPMODULE_MODE_TALK then
			for _, word in pairs(SHOP_TRADEREQUEST) do
				local obj = {}
				obj[#obj + 1] = word
				obj.callback = SHOP_TRADEREQUEST.callback or ShopModule.messageMatcher
				handler.keywordHandler:addKeyword(obj, ShopModule.requestTrade, {module = self})
			end
		end

		return true
	end

	-- Niestandardowa funkcja callback dopasowująca komunikaty żądania handlu.
	function ShopModule.messageMatcher(keywords, message)
		for _, word in pairs(keywords) do
			if type(word) == "string" then
				if string.find(message, word) and not string.find(message, "[%w+]" .. word) and not string.find(message, word .. "[%w+]") then
					return true
				end
			end
		end

		return false
	end

	-- Resetuje zmienne specyficzne dla modułu.
	function ShopModule:reset()
		self.amount = 0
	end

	-- Funkcja używana do dopasowywania wartości liczbowej z ciągu.
	function ShopModule:getCount(message)
		local ret = 1
		local b, e = string.find(message, PATTERN_COUNT)
		if b ~= nil and e ~= nil then
			ret = tonumber(string.sub(message, b, e))
		end

		if ret <= 0 then
			ret = 1
		elseif ret > self.maxCount then
			ret = self.maxCount
		end

		return ret
	end

	-- Dodaje nowy przedmiot do kupienia.
	--	names = Tabela zawierająca jeden lub więcej ciągów alternatywnych nazw tego przedmiotu. Używana tylko dla starego systemu kupna/sprzedaży.
	--	itemid = ID przedmiotu do kupienia
	--	cost = Cena jednego przedmiotu
	--	subType - SubType każdej runy lub płynnego kontenera. Może być pominięty, jeśli nie jest runą/płynnym kontenerem. Domyślna wartość to 1.
	--	realName - Prawdziwa, pełna nazwa przedmiotu. Będzie używana jako ITEMNAME w MESSAGE_ONBUY i MESSAGE_ONSELL, jeśli zdefiniowana. Domyślna wartość to nil (zostanie użyta getName)
	function ShopModule:addBuyableItem(names, itemid, cost, itemSubType, realName)
		if SHOPMODULE_MODE ~= SHOPMODULE_MODE_TALK then
			if itemSubType == nil then
				itemSubType = 1
			end

			local shopItem = self:getShopItem(itemid, itemSubType)
			if shopItem == nil then
				self.npcHandler.shopItems[#self.npcHandler.shopItems + 1] = {id = itemid, buy = cost, sell = -1, subType = itemSubType, name = realName or ItemType(itemid):getName()}
			else
				shopItem.buy = cost
			end
		end

		if names ~= nil and SHOPMODULE_MODE ~= SHOPMODULE_MODE_TRADE then
			for _, name in pairs(names) do
				local parameters = {
						itemid = itemid,
						cost = cost,
						eventType = SHOPMODULE_BUY_ITEM,
						module = self,
						realName = realName or ItemType(itemid):getName(),
						subType = itemSubType or 1
					}

				keywords = {}
				keywords[#keywords + 1] = "kup"
				keywords[#keywords + 1] = name
				local node = self.npcHandler.keywordHandler:addKeyword(keywords, ShopModule.tradeItem, parameters)
				node:addChildKeywordNode(self.yesNode)
				node:addChildKeywordNode(self.noNode)
			end
		end

		if npcs_loaded_shop[getNpcCid()] == nil then
			npcs_loaded_shop[getNpcCid()] = getNpcCid()
			self.npcHandler.keywordHandler:addKeyword({'tak'}, ShopModule.onConfirm, {module = self})
			self.npcHandler.keywordHandler:addKeyword({'nie'}, ShopModule.onDecline, {module = self})
		end
	end

	function ShopModule:getShopItem(itemId, itemSubType)
		if ItemType(itemId):isFluidContainer() then
			for i = 1, #self.npcHandler.shopItems do
				local shopItem = self.npcHandler.shopItems[i]
				if shopItem.id == itemId and shopItem.subType == itemSubType then
					return shopItem
				end
			end
		else
			for i = 1, #self.npcHandler.shopItems do
				local shopItem = self.npcHandler.shopItems[i]
				if shopItem.id == itemId then
					return shopItem
				end
			end
		end
		return nil
	end

	-- Dodaje nowy kupowalny kontener przedmiotów.
	--	names = Tabela zawierająca jedną lub więcej alternatywnych nazw tego przedmiotu.
	--	container = Plecak, torba lub dowolne inne ID przedmiotu kontenera, w którym będą przechowywane kupione przedmioty.
	--	itemid = ID przedmiotu do kupienia.
	--	cost = Cena jednego przedmiotu.
	--	subType - SubType każdej runy lub płynnego kontenera. Może być pominięty, jeśli nie jest runą/płynnym kontenerem. Domyślna wartość to 1.
	--	realName - Prawdziwa, pełna nazwa przedmiotu. Będzie używana jako ITEMNAME w MESSAGE_ONBUY i MESSAGE_ONSELL, jeśli zdefiniowana. Domyślna wartość to nil (getName zostanie użyte).
	function ShopModule:addBuyableItemContainer(names, container, itemid, cost, subType, realName)
		if names ~= nil then
			for _, name in pairs(names) do
				local parameters = {
						container = container,
						itemid = itemid,
						cost = cost,
						eventType = SHOPMODULE_BUY_ITEM_CONTAINER,
						module = self,
						realName = realName or ItemType(itemid):getName(),
						subType = subType or 1
					}

				keywords = {}
				keywords[#keywords + 1] = "kup"
				keywords[#keywords + 1] = name
				local node = self.npcHandler.keywordHandler:addKeyword(keywords, ShopModule.tradeItem, parameters)
				node:addChildKeywordNode(self.yesNode)
				node:addChildKeywordNode(self.noNode)
			end
		end
	end

	-- Dodaje nowy przedmiot do sprzedania.
	--	names = Tabela zawierająca jedną lub więcej alternatywnych nazw tego przedmiotu. Używana tylko przez stary system kupna/sprzedaży.
	--	itemid = ID przedmiotu do sprzedania.
	--	cost = Cena jednego przedmiotu.
	--	realName - Prawdziwa, pełna nazwa przedmiotu. Będzie używana jako ITEMNAME w MESSAGE_ONBUY i MESSAGE_ONSELL, jeśli zdefiniowana. Domyślna wartość to nil (getName zostanie użyte).
	function ShopModule:addSellableItem(names, itemid, cost, realName, itemSubType)
		if SHOPMODULE_MODE ~= SHOPMODULE_MODE_TALK then
			if itemSubType == nil then
				itemSubType = 0
			end

			local shopItem = self:getShopItem(itemid, itemSubType)
			if shopItem == nil then
				table.insert(self.npcHandler.shopItems, {id = itemid, buy = -1, sell = cost, subType = itemSubType, name = realName or ItemType(itemid):getName()})
			else
				shopItem.sell = cost
			end
		end

		if (names ~= nil and SHOPMODULE_MODE ~= SHOPMODULE_MODE_TRADE) then
			for i = 1, #names do
				local parameters = {
					itemid = itemid,
					cost = cost,
					eventType = SHOPMODULE_SELL_ITEM,
					module = self,
					realName = realName or ItemType(itemid):getName()
				}

				keywords = {}
				table.insert(keywords, "sprzedaj")
				table.insert(keywords, name)
				local node = self.npcHandler.keywordHandler:addKeyword(keywords, ShopModule.tradeItem, parameters)
				node:addChildKeywordNode(self.yesNode)
				node:addChildKeywordNode(self.noNode)
			end
		end
	end

	-- Funkcja callback onModuleReset(). Wywołuje ShopModule:reset()
	function ShopModule:callbackOnModuleReset()
		self:reset()
		return true
	end

	-- Funkcja callback onBuy(). Jeśli chcesz, możesz zmienić niektóre NPC, aby używały Twojego onBuy().
	function ShopModule:callbackOnBuy(cid, itemid, subType, amount, ignoreCap, inBackpacks)
		local shopItem = self:getShopItem(itemid, subType)
		if shopItem == nil then
			error("[ShopModule.onBuy] shopItem == nil")
			return false
		end

		if shopItem.buy == -1 then
			error("[ShopModule.onSell] próba zakupu przedmiotu niemożliwego do kupienia")
			return false
		end

		local backpack = 23782
		local totalCost = amount * shopItem.buy
		if inBackpacks then
			totalCost = ItemType(itemid):isStackable() and totalCost + 20 or totalCost + (math.max(1, math.floor(amount / ItemType(backpack):getCapacity())) * 20)
		end

		local player = Player(cid)
		local parseInfo = {
			[TAG_PLAYERNAME] = player:getName(),
			[TAG_ITEMCOUNT] = amount,
			[TAG_TOTALCOST] = totalCost,
			[TAG_ITEMNAME] = shopItem.name
		}

		if player:getMoney() < totalCost then
			local msg = self.npcHandler:getMessage(MESSAGE_NEEDMONEY)
			msg = self.npcHandler:parseMessage(msg, parseInfo)
			player:sendCancelMessage(msg)
			return false
		end

		local subType = shopItem.subType or 1
		local a, b = doNpcSellItem(cid, itemid, amount, subType, ignoreCap, inBackpacks, backpack)
		if(a < amount) then
			local msgId = MESSAGE_NEEDMORESPACE
			if(a == 0) then
				msgId = MESSAGE_NEEDSPACE
			end

			local msg = self.npcHandler:getMessage(msgId)
			parseInfo[TAG_ITEMCOUNT] = a
			msg = self.npcHandler:parseMessage(msg, parseInfo)
			player:sendCancelMessage(msg)
			self.npcHandler.talkStart[cid] = os.time()

			if(a > 0) then
				player:removeMoney((a * shopItem.buy) + (b * 20))
				return true
			end

			return false
		else
			local msg = self.npcHandler:getMessage(MESSAGE_BOUGHT)
			msg = self.npcHandler:parseMessage(msg, parseInfo)
			player:sendTextMessage(MESSAGE_INFO_DESCR, msg)
			player:removeMoney(totalCost)
			self.npcHandler.talkStart[cid] = os.time()
			return true
		end
	end

	-- Funkcja callback onSell(). Jeśli chcesz, możesz zmienić niektóre NPC, aby używały Twojego onSell().
	function ShopModule:callbackOnSell(cid, itemid, subType, amount, ignoreEquipped, _)
		local shopItem = self:getShopItem(itemid, subType)
		if shopItem == nil then
			error("[ShopModule.onSell] items[itemid] == nil")
			return false
		end

		if shopItem.sell == -1 then
--			error("[ShopModule.onSell] próba sprzedaży przedmiotu niemożliwego do sprzedania")
			return false
		end

		local player = Player(cid)
		local parseInfo = {
			[TAG_PLAYERNAME] = player:getName(),
			[TAG_ITEMCOUNT] = amount,
			[TAG_TOTALCOST] = amount * shopItem.sell,
			[TAG_ITEMNAME] = shopItem.name
		}

		if not ItemType(itemid):isFluidContainer() then
			subType = -1
		end

		if player:removeItem(itemid, amount, subType, ignoreEquipped) then
			local msg = self.npcHandler:getMessage(MESSAGE_SOLD)
			msg = self.npcHandler:parseMessage(msg, parseInfo)
			player:sendTextMessage(MESSAGE_INFO_DESCR, msg)
			player:addMoney(amount * shopItem.sell)
			self.npcHandler.talkStart[cid] = os.time()
			return true
		else
			local msg = self.npcHandler:getMessage(MESSAGE_NEEDITEM)
			msg = self.npcHandler:parseMessage(msg, parseInfo)
			player:sendCancelMessage(msg)
			self.npcHandler.talkStart[cid] = os.time()
			return false
		end
	end

	-- Callback do żądania okna handlu z NPC.
	function ShopModule.requestTrade(cid, message, keywords, parameters, node)
		local module = parameters.module
		if(not module.npcHandler:isFocused(cid)) then
			return false
		end

		if(not module.npcHandler:onTradeRequest(cid)) then
			return false
		end

		local itemWindow = {}
		for i = 1, #module.npcHandler.shopItems do
			table.insert(itemWindow, module.npcHandler.shopItems[i])
		end

		if itemWindow[1] == nil then
			local parseInfo = { [TAG_PLAYERNAME] = Player(cid):getName() }
			local msg = module.npcHandler:parseMessage(module.npcHandler:getMessage(MESSAGE_NOSHOP), parseInfo)
			module.npcHandler:say(msg, cid)
			return true
		end

		local parseInfo = { [TAG_PLAYERNAME] = Player(cid):getName() }
		local msg = module.npcHandler:parseMessage(module.npcHandler:getMessage(MESSAGE_SENDTRADE), parseInfo)
		openShopWindow(cid, itemWindow,
			function(cid, itemid, subType, amount, ignoreCap, inBackpacks) module.npcHandler:onBuy(cid, itemid, subType, amount, ignoreCap, inBackpacks) end,
			function(cid, itemid, subType, amount, ignoreCap, inBackpacks) module.npcHandler:onSell(cid, itemid, subType, amount, ignoreCap, inBackpacks) end)
		module.npcHandler:say(msg, cid)
		return true
	end

	-- Funkcja callback słowa kluczowego onConfirm(). Sprzedaje/kupuje rzeczywisty przedmiot.
	function ShopModule.onConfirm(cid, message, keywords, parameters, node)
		local module = parameters.module
		if(not module.npcHandler:isFocused(cid)) or shop_npcuid[cid] ~= getNpcCid() then
			return false
		end
		shop_npcuid[cid] = 0

		local parentParameters = node:getParent():getParameters()
		local parseInfo = {
			[TAG_PLAYERNAME] = Player(cid):getName(),
			[TAG_ITEMCOUNT] = shop_amount[cid],
			[TAG_TOTALCOST] = shop_cost[cid] * shop_amount[cid],
			[TAG_ITEMNAME] = shop_rlname[cid]
		}

		if(shop_eventtype[cid] == SHOPMODULE_SELL_ITEM) then
			local ret = doPlayerSellItem(cid, shop_itemid[cid], shop_amount[cid], shop_cost[cid] * shop_amount[cid])
			if ret then
				local msg = module.npcHandler:getMessage(MESSAGE_ONSELL)
				msg = module.npcHandler:parseMessage(msg, parseInfo)
				module.npcHandler:say(msg, cid)
			else
				local msg = module.npcHandler:getMessage(MESSAGE_MISSINGITEM)
				msg = module.npcHandler:parseMessage(msg, parseInfo)
				module.npcHandler:say(msg, cid)
			end
		elseif(shop_eventtype[cid] == SHOPMODULE_BUY_ITEM) then
			local cost = shop_cost[cid] * shop_amount[cid]
			if Player(cid):getMoney() < cost then
				local msg = module.npcHandler:getMessage(MESSAGE_MISSINGMONEY)
				msg = module.npcHandler:parseMessage(msg, parseInfo)
				module.npcHandler:say(msg, cid)
				return false
			end

			local a, b = doNpcSellItem(cid, shop_itemid[cid], shop_amount[cid], shop_subtype[cid], false, false, 1988)
			if(a < shop_amount[cid]) then
				local msgId = MESSAGE_NEEDMORESPACE
				if(a == 0) then
					msgId = MESSAGE_NEEDSPACE
				end

				local msg = module.npcHandler:getMessage(msgId)
				msg = module.npcHandler:parseMessage(msg, parseInfo)
				module.npcHandler:say(msg, cid)
				if(a > 0) then
					Player(cid):removeMoney(a * shop_cost[cid])
					if shop_itemid[cid] == ITEM_PARCEL then
						doNpcSellItem(cid, ITEM_LABEL, shop_amount[cid], shop_subtype[cid], true, false, 1988)
					end
					return true
				end
				return false
			else
				local msg = module.npcHandler:getMessage(MESSAGE_ONBUY)
				msg = module.npcHandler:parseMessage(msg, parseInfo)
				module.npcHandler:say(msg, cid)
				Player(cid):removeMoney(cost)
				if shop_itemid[cid] == ITEM_PARCEL then
					doNpcSellItem(cid, ITEM_LABEL, shop_amount[cid], shop_subtype[cid], true, false, 1988)
				end
				return true
			end
		elseif(shop_eventtype[cid] == SHOPMODULE_BUY_ITEM_CONTAINER) then
			local ret = doPlayerBuyItemContainer(cid, shop_container[cid], shop_itemid[cid], shop_amount[cid], shop_cost[cid] * shop_amount[cid], shop_subtype[cid])
			if ret then
				local msg = module.npcHandler:getMessage(MESSAGE_ONBUY)
				msg = module.npcHandler:parseMessage(msg, parseInfo)
				module.npcHandler:say(msg, cid)
			else
				local msg = module.npcHandler:getMessage(MESSAGE_MISSINGMONEY)
				msg = module.npcHandler:parseMessage(msg, parseInfo)
				module.npcHandler:say(msg, cid)
			end
		end

		module.npcHandler:resetNpc(cid)
		return true
	end

	-- Funkcja callback słowa kluczowego onDecline(). Ogólnie wywoływana, gdy gracz powie "nie" po chęci zakupu przedmiotu.
	function ShopModule.onDecline(cid, message, keywords, parameters, node)
		local module = parameters.module
		if(not module.npcHandler:isFocused(cid)) or shop_npcuid[cid] ~= getNpcCid() then
			return false
		end
		shop_npcuid[cid] = 0

		local parentParameters = node:getParent():getParameters()
		local parseInfo = {
			[TAG_PLAYERNAME] = Player(cid):getName(),
			[TAG_ITEMCOUNT] = shop_amount[cid],
			[TAG_TOTALCOST] = shop_cost[cid] * shop_amount[cid],
			[TAG_ITEMNAME] = shop_rlname[cid]
		}

		local msg = module.npcHandler:parseMessage(module.noText, parseInfo)
		module.npcHandler:say(msg, cid)
		module.npcHandler:resetNpc(cid)
		return true
	end

	-- Funkcja callback tradeItem(). Sprawia, że NPC wypowiada wiadomość zdefiniowaną przez MESSAGE_BUY lub MESSAGE_SELL
	function ShopModule.tradeItem(cid, message, keywords, parameters, node)
		local module = parameters.module
		if(not module.npcHandler:isFocused(cid)) then
			return false
		end

		if(not module.npcHandler:onTradeRequest(cid)) then
			return true
		end

		local count = module:getCount(message)
		module.amount = count

		shop_amount[cid] = module.amount
		shop_cost[cid] = parameters.cost
		shop_rlname[cid] = parameters.realName
		shop_itemid[cid] = parameters.itemid
		shop_container[cid] = parameters.container
		shop_npcuid[cid] = getNpcCid()
		shop_eventtype[cid] = parameters.eventType
		shop_subtype[cid] = parameters.subType

		local parseInfo = {
			[TAG_PLAYERNAME] = Player(cid):getName(),
			[TAG_ITEMCOUNT] = shop_amount[cid],
			[TAG_TOTALCOST] = shop_cost[cid] * shop_amount[cid],
			[TAG_ITEMNAME] = shop_rlname[cid]
		}

		if(shop_eventtype[cid] == SHOPMODULE_SELL_ITEM) then
			local msg = module.npcHandler:getMessage(MESSAGE_SELL)
			msg = module.npcHandler:parseMessage(msg, parseInfo)
			module.npcHandler:say(msg, cid)
		elseif(shop_eventtype[cid] == SHOPMODULE_BUY_ITEM) then
			local msg = module.npcHandler:getMessage(MESSAGE_BUY)
			msg = module.npcHandler:parseMessage(msg, parseInfo)
			module.npcHandler:say(msg, cid)
		elseif(shop_eventtype[cid] == SHOPMODULE_BUY_ITEM_CONTAINER) then
			local msg = module.npcHandler:getMessage(MESSAGE_BUY)
			msg = module.npcHandler:parseMessage(msg, parseInfo)
			module.npcHandler:say(msg, cid)
		end
		return true
	end
end