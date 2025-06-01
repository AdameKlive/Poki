-- Zaawansowany System NPC by Jiddo

if NpcHandler == nil then
	-- Stałe zachowania opóźnienia mówienia.
	TALKDELAY_NONE = 0 -- Brak opóźnienia mówienia. NPC odpowie natychmiast.
	TALKDELAY_ONTHINK = 1 -- Opóźnienie mówienia obsługiwane przez funkcję zwrotną onThink. (Domyślnie)
	TALKDELAY_EVENT = 2 -- Jeszcze nie zaimplementowane

	-- Aktualnie zastosowane zachowanie opóźnienia mówienia. TALKDELAY_ONTHINK jest domyślne.
	NPCHANDLER_TALKDELAY = TALKDELAY_ONTHINK

	-- Stałe indeksy do definiowania domyślnych wiadomości.
	MESSAGE_GREET 			= 1 -- Gdy gracz wita NPC.
	MESSAGE_FAREWELL 		= 2 -- Gdy gracz żegna się z NPC.
	MESSAGE_BUY 			= 3 -- Gdy NPC pyta gracza, czy chce coś kupić.
	MESSAGE_ONBUY 			= 4 -- Gdy gracz pomyślnie coś kupuje poprzez rozmowę.
	MESSAGE_BOUGHT			= 5 -- Gdy gracz kupił coś przez okno sklepu.
	MESSAGE_SELL 			= 6 -- Gdy NPC pyta gracza, czy chce coś sprzedać.
	MESSAGE_ONSELL 			= 7 -- Gdy gracz pomyślnie coś sprzedaje poprzez rozmowę.
	MESSAGE_SOLD			= 8 -- Gdy gracz sprzedał coś przez okno sklepu.
	MESSAGE_MISSINGMONEY		= 9 -- Gdy gracz nie ma wystarczająco pieniędzy.
	MESSAGE_NEEDMONEY		= 10 -- To samo co powyżej, używane dla okna sklepu.
	MESSAGE_MISSINGITEM		= 11 -- Gdy gracz próbuje sprzedać przedmiot, którego nie posiada.
	MESSAGE_NEEDITEM		= 12 -- To samo co powyżej, używane dla okna sklepu.
	MESSAGE_NEEDSPACE 		= 13 -- Gdy gracz nie ma miejsca na zakup przedmiotu.
	MESSAGE_NEEDMORESPACE		= 14 -- Gdy gracz ma trochę miejsca na zakup przedmiotu, ale niewystarczająco.
	MESSAGE_IDLETIMEOUT		= 15 -- Gdy gracz był bezczynny dłużej niż pozwala idleTime.
	MESSAGE_WALKAWAY		= 16 -- Gdy gracz wychodzi poza promień rozmowy NPC.
	MESSAGE_DECLINE			= 17 -- Gdy gracz mówi "nie" na coś.
	MESSAGE_SENDTRADE		= 18 -- Gdy NPC wysyła okno handlu do gracza.
	MESSAGE_NOSHOP			= 19 -- Gdy żądany jest sklep NPC, ale on żadnego nie ma.
	MESSAGE_ONCLOSESHOP		= 20 -- Gdy gracz zamyka okno sklepu NPC.
	MESSAGE_ALREADYFOCUSED		= 21 -- Gdy gracz ma już fokus tego NPC.
	MESSAGE_WALKAWAY_MALE		= 22 -- Gdy gracz płci męskiej wychodzi poza promień rozmowy NPC.
	MESSAGE_WALKAWAY_FEMALE		= 23 -- Gdy gracz płci żeńskiej wychodzi poza promień rozmowy NPC.

	-- Stałe indeksy dla funkcji zwrotnych. Są one również używane dla identyfikatorów zwrotnych modułów.
	CALLBACK_CREATURE_APPEAR 	= 1
	CALLBACK_CREATURE_DISAPPEAR	= 2
	CALLBACK_CREATURE_SAY 		= 3
	CALLBACK_ONTHINK 		= 4
	CALLBACK_GREET 			= 5
	CALLBACK_FAREWELL 		= 6
	CALLBACK_MESSAGE_DEFAULT 	= 7
	CALLBACK_PLAYER_ENDTRADE 	= 8
	CALLBACK_PLAYER_CLOSECHANNEL	= 9
	CALLBACK_ONBUY			= 10
	CALLBACK_ONSELL			= 11
	CALLBACK_ONADDFOCUS		= 18
	CALLBACK_ONRELEASEFOCUS		= 19
	CALLBACK_ONTRADEREQUEST		= 20

	-- Dodatkowe identyfikatory zwrotne modułów
	CALLBACK_MODULE_INIT		= 12
	CALLBACK_MODULE_RESET		= 13

	-- Stałe łańcuchy znaków definiujące słowa kluczowe do zastąpienia w domyślnych wiadomościach.
	TAG_PLAYERNAME = "|PLAYERNAME|"
	TAG_ITEMCOUNT = "|ITEMCOUNT|"
	TAG_TOTALCOST = "|TOTALCOST|"
	TAG_ITEMNAME = "|ITEMNAME|"
	TAG_TIME = "|TIME|"
	TAG_BLESSCOST = "|BLESSCOST|"
	TAG_PVPBLESSCOST = "|PVPBLESSCOST|"
	TAG_TRAVELCOST = "|TRAVELCOST|"

	NpcHandler = {
		keywordHandler = nil,
		focuses = nil,
		talkStart = nil,
		idleTime = 120,
		talkRadius = 3,
		talkDelayTime = 1, -- Sekundy opóźnienia wychodzących wiadomości.
		talkDelay = nil,
		callbackFunctions = nil,
		modules = nil,
		shopItems = nil, -- Muszą tu być, ponieważ ShopModule używa 'statycznych' funkcji
		eventSay = nil,
		eventDelayedSay = nil,
		topic = nil,
		messages = {
			-- To są domyślne odpowiedzi wszystkich NPC. Mogą/powinny być zmieniane indywidualnie dla każdego NPC.
			[MESSAGE_GREET]		= "Witaj, |PLAYERNAME|.",
			[MESSAGE_FAREWELL] 	= "Do widzenia, |PLAYERNAME|.",
			[MESSAGE_BUY] 		= "Chcesz kupić |ITEMCOUNT| |ITEMNAME| za |TOTALCOST| złotych monet?",
			[MESSAGE_ONBUY]		= "Proszę bardzo.",
			[MESSAGE_BOUGHT] 	= "Kupiono |ITEMCOUNT|x |ITEMNAME| za |TOTALCOST| złota.",
			[MESSAGE_SELL] 		= "Chcesz sprzedać |ITEMCOUNT| |ITEMNAME| za |TOTALCOST| złotych monet?",
			[MESSAGE_ONSELL] 	= "Proszę bardzo, |TOTALCOST| złota.",
			[MESSAGE_SOLD]	 	= "Sprzedano |ITEMCOUNT|x |ITEMNAME| za |TOTALCOST| złota.",
			[MESSAGE_MISSINGMONEY]	= "Nie masz wystarczająco pieniędzy.",
			[MESSAGE_NEEDMONEY] 	= "Nie masz wystarczająco pieniędzy.",
			[MESSAGE_MISSINGITEM] 	= "Nie masz tylu.",
			[MESSAGE_NEEDITEM]	= "Nie posiadasz tego obiektu.",
			[MESSAGE_NEEDSPACE]	= "Nie masz wystarczającej pojemności.",
			[MESSAGE_NEEDMORESPACE]	= "Nie masz wystarczającej pojemności na wszystkie przedmioty.",
			[MESSAGE_IDLETIMEOUT] 	= "Do widzenia.",
			[MESSAGE_WALKAWAY] 	= "Do widzenia.",
			[MESSAGE_DECLINE]	= "W takim razie nie.",
			[MESSAGE_SENDTRADE]	= "Oczywiście, po prostu przejrzyj moje towary.",
			[MESSAGE_NOSHOP]	= "Przepraszam, niczego nie oferuję.",
			[MESSAGE_ONCLOSESHOP]	= "Dziękuję, wróć, kiedy tylko będziesz czegoś potrzebować.",
			[MESSAGE_ALREADYFOCUSED]= "|PLAYERNAME|, już z tobą rozmawiam.",
			[MESSAGE_WALKAWAY_MALE]	= "Do widzenia.",
			[MESSAGE_WALKAWAY_FEMALE] 	= "Do widzenia."
		}
	}

	-- Tworzy nowy NpcHandler z pustym stosem funkcji zwrotnych.
	function NpcHandler:new(keywordHandler)
		local obj = {}
		obj.callbackFunctions = {}
		obj.modules = {}
		obj.eventSay = {}
		obj.eventDelayedSay = {}
		obj.topic = {}
		obj.focuses = {}
		obj.talkStart = {}
		obj.talkDelay = {}
		obj.keywordHandler = keywordHandler
		obj.messages = {}
		obj.shopItems = {}

		setmetatable(obj.messages, self.messages)
		self.messages.__index = self.messages

		setmetatable(obj, self)
		self.__index = self
		return obj
	end

	-- Redefiniuje maksymalny czas bezczynności dozwolony dla gracza podczas rozmowy z tym NPC.
	function NpcHandler:setMaxIdleTime(newTime)
		self.idleTime = newTime
	end

	-- Przypisuje nowy handler słów kluczowych do tego npchandlera.
	function NpcHandler:setKeywordHandler(newHandler)
		self.keywordHandler = newHandler
	end

	-- Funkcja używana do zmiany fokusu tego NPC.
	function NpcHandler:addFocus(newFocus)
		if self:isFocused(newFocus) then
			return
		end

		self.focuses[#self.focuses + 1] = newFocus
		self.topic[newFocus] = 0
		local callback = self:getCallback(CALLBACK_ONADDFOCUS)
		if callback == nil or callback(newFocus) then
			self:processModuleCallback(CALLBACK_ONADDFOCUS, newFocus)
		end
		self:updateFocus()
	end

	-- Funkcja używana do weryfikacji, czy NPC jest sfokusowany na określonego gracza.
	function NpcHandler:isFocused(focus)
		for _, v in pairs(self.focuses) do
			if v == focus then
				return true
			end
		end
		return false
	end

	-- Funkcja używana do weryfikacji, czy NPC ma fokus.
	function NpcHandler:hasFocus()
		if #self.focuses >= 1 then
			return true
		end
		return false
	end

	-- Ta funkcja powinna być wywoływana przy każdym onThink i zapewnia, że NPC patrzy na gracza, z którym rozmawia.
	-- Powinna być również wywoływana za każdym razem, gdy nowy gracz jest fokusowany.
	function NpcHandler:updateFocus()
		for _, focus in pairs(self.focuses) do
			if focus ~= nil then
				doNpcSetCreatureFocus(focus)
				return
			end
		end
		doNpcSetCreatureFocus(0)
	end

	-- Używane, gdy NPC powinien przestać fokusować gracza.
	function NpcHandler:releaseFocus(focus)
		if shop_cost[focus] ~= nil then
			shop_amount[focus] = nil
			shop_cost[focus] = nil
			shop_rlname[focus] = nil
			shop_itemid[focus] = nil
			shop_container[focus] = nil
			shop_npcuid[focus] = nil
			shop_eventtype[focus] = nil
			shop_subtype[focus] = nil
			shop_destination[focus] = nil
			shop_premium[focus] = nil
		end

		if self.eventDelayedSay[focus] then
			self:cancelNPCTalk(self.eventDelayedSay[focus])
		end

		if not self:isFocused(focus) then
			return
		end

		local pos = nil
		for k, v in pairs(self.focuses) do
			if v == focus then
				pos = k
			end
		end

		self.focuses[pos] = nil

		self.eventSay[focus] = nil
		self.eventDelayedSay[focus] = nil
		self.talkStart[focus] = nil
		self.topic[focus] = nil

		local callback = self:getCallback(CALLBACK_ONRELEASEFOCUS)
		if callback == nil or callback(focus) then
			self:processModuleCallback(CALLBACK_ONRELEASEFOCUS, focus)
		end

		if Player(focus) ~= nil then
			closeShopWindow(focus) -- Nawet jeśli może nie istnieć, musimy temu zapobiec.
			self:updateFocus()
		end
	end

	-- Zwraca funkcję zwrotną o określonym identyfikatorze lub nil, jeśli taka funkcja zwrotna nie istnieje.
	function NpcHandler:getCallback(id)
		local ret = nil
		if self.callbackFunctions ~= nil then
			ret = self.callbackFunctions[id]
		end
		return ret
	end

	-- Zmienia funkcję zwrotną dla danego identyfikatora na callback.
	function NpcHandler:setCallback(id, callback)
		if self.callbackFunctions ~= nil then
			self.callbackFunctions[id] = callback
		end
	end

	-- Dodaje moduł do tego npchandlera i go inicjuje.
	function NpcHandler:addModule(module)
		if self.modules ~= nil then
			self.modules[#self.modules +1] = module
			module:init(self)
		end
	end

	-- Wywołuje funkcję zwrotną reprezentowaną przez id dla wszystkich modułów dodanych do tego npchandlera z podanymi argumentami.
	function NpcHandler:processModuleCallback(id, ...)
		local ret = true
		for _, module in pairs(self.modules) do
			local tmpRet = true
			if id == CALLBACK_CREATURE_APPEAR and module.callbackOnCreatureAppear ~= nil then
				tmpRet = module:callbackOnCreatureAppear(...)
			elseif id == CALLBACK_CREATURE_DISAPPEAR and module.callbackOnCreatureDisappear ~= nil then
				tmpRet = module:callbackOnCreatureDisappear(...)
			elseif id == CALLBACK_CREATURE_SAY and module.callbackOnCreatureSay ~= nil then
				tmpRet = module:callbackOnCreatureSay(...)
			elseif id == CALLBACK_PLAYER_ENDTRADE and module.callbackOnPlayerEndTrade ~= nil then
				tmpRet = module:callbackOnPlayerEndTrade(...)
			elseif id == CALLBACK_PLAYER_CLOSECHANNEL and module.callbackOnPlayerCloseChannel ~= nil then
				tmpRet = module:callbackOnPlayerCloseChannel(...)
			elseif id == CALLBACK_ONBUY and module.callbackOnBuy ~= nil then
				tmpRet = module:callbackOnBuy(...)
			elseif id == CALLBACK_ONSELL and module.callbackOnSell ~= nil then
				tmpRet = module:callbackOnSell(...)
			elseif id == CALLBACK_ONTRADEREQUEST and module.callbackOnTradeRequest ~= nil then
				tmpRet = module:callbackOnTradeRequest(...)
			elseif id == CALLBACK_ONADDFOCUS and module.callbackOnAddFocus ~= nil then
				tmpRet = module:callbackOnAddFocus(...)
			elseif id == CALLBACK_ONRELEASEFOCUS and module.callbackOnReleaseFocus ~= nil then
				tmpRet = module:callbackOnReleaseFocus(...)
			elseif id == CALLBACK_ONTHINK and module.callbackOnThink ~= nil then
				tmpRet = module:callbackOnThink(...)
			elseif id == CALLBACK_GREET and module.callbackOnGreet ~= nil then
				tmpRet = module:callbackOnGreet(...)
			elseif id == CALLBACK_FAREWELL and module.callbackOnFarewell ~= nil then
				tmpRet = module:callbackOnFarewell(...)
			elseif id == CALLBACK_MESSAGE_DEFAULT and module.callbackOnMessageDefault ~= nil then
				tmpRet = module:callbackOnMessageDefault(...)
			elseif id == CALLBACK_MODULE_RESET and module.callbackOnModuleReset ~= nil then
				tmpRet = module:callbackOnModuleReset(...)
			end
			if not tmpRet then
				ret = false
				break
			end
		end
		return ret
	end

	-- Zwraca wiadomość reprezentowaną przez id.
	function NpcHandler:getMessage(id)
		local ret = nil
		if self.messages ~= nil then
			ret = self.messages[id]
		end
		return ret
	end

	-- Zmienia domyślną wiadomość odpowiedzi o określonym identyfikatorze na newMessage.
	function NpcHandler:setMessage(id, newMessage)
		if self.messages ~= nil then
			self.messages[id] = newMessage
		end
	end

	-- Tłumaczy wszystkie tagi wiadomości znalezione w msg, używając parseInfo.
	function NpcHandler:parseMessage(msg, parseInfo)
		local ret = msg
		if type(ret) == 'string' then
			for search, replace in pairs(parseInfo) do
				ret = string.gsub(ret, search, replace)
			end
		else
			for i = 1, #ret do
				for search, replace in pairs(parseInfo) do
					ret[i] = string.gsub(ret[i], search, replace)
				end
			end
		end
		return ret
	end

	-- Zapewnia, że NPC przestaje fokusować aktualnie sfokusowanego gracza.
	function NpcHandler:unGreet(cid)
		if not self:isFocused(cid) then
			return
		end

		local callback = self:getCallback(CALLBACK_FAREWELL)
		if callback == nil or callback() then
			if self:processModuleCallback(CALLBACK_FAREWELL) then
				local msg = self:getMessage(MESSAGE_FAREWELL)
				local player = Player(cid)
				local playerName = player and player:getName() or -1
				local parseInfo = { [TAG_PLAYERNAME] = playerName }
				self:resetNpc(cid)
				msg = self:parseMessage(msg, parseInfo)
				self:say(msg, cid, true)
				self:releaseFocus(cid)
			end
		end
	end

	-- Wita nowego gracza.
	function NpcHandler:greet(cid, message)
		if cid ~= 0  then
			local callback = self:getCallback(CALLBACK_GREET)
			if callback == nil or callback(cid, message) then
				if self:processModuleCallback(CALLBACK_GREET, cid) then
					local msg = self:getMessage(MESSAGE_GREET)
					local player = Player(cid)
					local playerName = player and player:getName() or -1
					local parseInfo = { [TAG_PLAYERNAME] = playerName }
					msg = self:parseMessage(msg, parseInfo)
					self:say(msg, cid, true)
				else
					return
				end
			else
				return
			end
		end
		self:addFocus(cid)
	end

	-- Obsługuje zdarzenia onCreatureAppear. Jeśli chcesz to obsługiwać samodzielnie, użyj funkcji zwrotnej CALLBACK_CREATURE_APPEAR.
	function NpcHandler:onCreatureAppear(creature)
		local cid = creature.uid
		if cid == getNpcCid() then
			local npc = Npc()
			if next(self.shopItems) then
				local speechBubble = npc:getSpeechBubble()
				if speechBubble == 3 then
					npc:setSpeechBubble(4)
				else
					npc:setSpeechBubble(2)
				end
			else
				if self:getMessage(MESSAGE_GREET) then
					npc:setSpeechBubble(1)
				end
			end
		end

		local callback = self:getCallback(CALLBACK_CREATURE_APPEAR)
		if callback == nil or callback(cid) then
			if self:processModuleCallback(CALLBACK_CREATURE_APPEAR, cid) then
				--
			end
		end
	end

	-- Obsługuje zdarzenia onCreatureDisappear. Jeśli chcesz to obsługiwać samodzielnie, użyj funkcji zwrotnej CALLBACK_CREATURE_DISAPPEAR.
	function NpcHandler:onCreatureDisappear(creature)
		local cid = creature.uid
		if getNpcCid() == cid then
			return
		end

		local callback = self:getCallback(CALLBACK_CREATURE_DISAPPEAR)
		if callback == nil or callback(cid) then
			if self:processModuleCallback(CALLBACK_CREATURE_DISAPPEAR, cid) then
				if self:isFocused(cid) then
					self:unGreet(cid)
				end
			end
		end
	end

	-- Obsługuje zdarzenia onCreatureSay. Jeśli chcesz to obsługiwać samodzielnie, użyj funkcji zwrotnej CALLBACK_CREATURE_SAY.
	function NpcHandler:onCreatureSay(creature, msgtype, msg)
		local cid = creature.uid
		local callback = self:getCallback(CALLBACK_CREATURE_SAY)
		if callback == nil or callback(cid, msgtype, msg) then
			if self:processModuleCallback(CALLBACK_CREATURE_SAY, cid, msgtype, msg) then
				if not self:isInRange(cid) then
					return
				end

				if self.keywordHandler ~= nil then
					if self:isFocused(cid) and msgtype == TALKTYPE_PRIVATE_PN or not self:isFocused(cid) then
						local ret = self.keywordHandler:processMessage(cid, msg)
						if(not ret) then
							local callback = self:getCallback(CALLBACK_MESSAGE_DEFAULT)
							if callback ~= nil and callback(cid, msgtype, msg) then
								self.talkStart[cid] = os.time()
							end
						else
							self.talkStart[cid] = os.time()
						end
					end
				end
			end
		end
	end

	-- Obsługuje zdarzenia onPlayerEndTrade. Jeśli chcesz to obsługiwać samodzielnie, użyj funkcji zwrotnej CALLBACK_PLAYER_ENDTRADE.
	function NpcHandler:onPlayerEndTrade(creature)
		local cid = creature.uid
		local callback = self:getCallback(CALLBACK_PLAYER_ENDTRADE)
		if callback == nil or callback(cid) then
			if self:processModuleCallback(CALLBACK_PLAYER_ENDTRADE, cid, msgtype, msg) then
				if self:isFocused(cid) then
					local player = Player(cid)
					local playerName = player and player:getName() or -1
					local parseInfo = { [TAG_PLAYERNAME] = playerName }
					local msg = self:parseMessage(self:getMessage(MESSAGE_ONCLOSESHOP), parseInfo)
					self:say(msg, cid)
				end
			end
		end
	end

	-- Obsługuje zdarzenia onPlayerCloseChannel. Jeśli chcesz to obsługiwać samodzielnie, użyj funkcji zwrotnej CALLBACK_PLAYER_CLOSECHANNEL.
	function NpcHandler:onPlayerCloseChannel(creature)
		local cid = creature.uid
		local callback = self:getCallback(CALLBACK_PLAYER_CLOSECHANNEL)
		if callback == nil or callback(cid) then
			if self:processModuleCallback(CALLBACK_PLAYER_CLOSECHANNEL, cid, msgtype, msg) then
				if self:isFocused(cid) then
					self:unGreet(cid)
				end
			end
		end
	end

	-- Obsługuje zdarzenia onBuy. Jeśli chcesz to obsługiwać samodzielnie, użyj funkcji zwrotnej CALLBACK_ONBUY.
	function NpcHandler:onBuy(creature, itemid, subType, amount, ignoreCap, inBackpacks)
		local cid = creature.uid
		local callback = self:getCallback(CALLBACK_ONBUY)
		if callback == nil or callback(cid, itemid, subType, amount, ignoreCap, inBackpacks) then
			if self:processModuleCallback(CALLBACK_ONBUY, cid, itemid, subType, amount, ignoreCap, inBackpacks) then
				--
			end
		end
	end

	-- Obsługuje zdarzenia onSell. Jeśli chcesz to obsługiwać samodzielnie, użyj funkcji zwrotnej CALLBACK_ONSELL.
	function NpcHandler:onSell(creature, itemid, subType, amount, ignoreCap, inBackpacks)
		local cid = creature.uid
		local callback = self:getCallback(CALLBACK_ONSELL)
		if callback == nil or callback(cid, itemid, subType, amount, ignoreCap, inBackpacks) then
			if self:processModuleCallback(CALLBACK_ONSELL, cid, itemid, subType, amount, ignoreCap, inBackpacks) then
				--
			end
		end
	end

	-- Obsługuje zdarzenia onTradeRequest. Jeśli chcesz to obsługiwać samodzielnie, użyj funkcji zwrotnej CALLBACK_ONTRADEREQUEST.
	function NpcHandler:onTradeRequest(cid)
		local callback = self:getCallback(CALLBACK_ONTRADEREQUEST)
		if callback == nil or callback(cid) then
			if self:processModuleCallback(CALLBACK_ONTRADEREQUEST, cid) then
				return true
			end
		end
		return false
	end

	-- Obsługuje zdarzenia onThink. Jeśli chcesz to obsługiwać samodzielnie, użyj funkcji zwrotnej CALLBACK_ONTHINK.
	function NpcHandler:onThink()
		local callback = self:getCallback(CALLBACK_ONTHINK)
		if callback == nil or callback() then
			if NPCHANDLER_TALKDELAY == TALKDELAY_ONTHINK then
				for cid, talkDelay in pairs(self.talkDelay) do
					if talkDelay.time ~= nil and talkDelay.message ~= nil and os.time() >= talkDelay.time then
						selfSay(talkDelay.message, cid, talkDelay.publicize and true or false)
						self.talkDelay[cid] = nil
					end
				end
			end

			if self:processModuleCallback(CALLBACK_ONTHINK) then
				for _, focus in pairs(self.focuses) do
					if focus ~= nil then
						if not self:isInRange(focus) then
							self:onWalkAway(focus)
						elseif self.talkStart[focus] ~= nil and (os.time() - self.talkStart[focus]) > self.idleTime then
							self:unGreet(focus)
						else
							self:updateFocus()
						end
					end
				end
			end
		end
	end

	-- Próbuje przywitać gracza o podanym cid.
	function NpcHandler:onGreet(cid, message)
		if self:isInRange(cid) then
			if not self:isFocused(cid) then
				self:greet(cid, message)
				return
			end
		end
	end

	-- Po prostu wywołuje podstawową funkcję unGreet.
	function NpcHandler:onFarewell(cid)
		self:unGreet(cid)
	end

	-- Powinno być wywołane na fokusie tego NPC, jeśli odległość do fokusu jest większa niż talkRadius.
	function NpcHandler:onWalkAway(cid)
		if self:isFocused(cid) then
			local callback = self:getCallback(CALLBACK_CREATURE_DISAPPEAR)
			if callback == nil or callback(cid) then
				if self:processModuleCallback(CALLBACK_CREATURE_DISAPPEAR, cid) then
					local msg = self:getMessage(MESSAGE_WALKAWAY)

					local player = Player(cid)
					local playerName = player and player:getName() or -1
					local playerSex = player and player:getSex() or 0

					local parseInfo = { [TAG_PLAYERNAME] = playerName }
					local message = self:parseMessage(msg, parseInfo)

					local msg_male = self:getMessage(MESSAGE_WALKAWAY_MALE)
					local message_male = self:parseMessage(msg_male, parseInfo)
					local msg_female = self:getMessage(MESSAGE_WALKAWAY_FEMALE)
					local message_female = self:parseMessage(msg_female, parseInfo)
					if message_female ~= message_male then
						if playerSex == PLAYERSEX_FEMALE then
							selfSay(message_female)
						else
							selfSay(message_male)
						end
					elseif message ~= "" then
						selfSay(message)
					end
					self:resetNpc(cid)
					self:releaseFocus(cid)
				end
			end
		end
	end

	-- Zwraca true, jeśli cid znajduje się w promieniu rozmowy tego NPC.
	function NpcHandler:isInRange(cid)
		local distance = Player(cid) ~= nil and getDistanceTo(cid) or -1
		if distance == -1 then
			return false
		end

		return distance <= self.talkRadius
	end

	-- Resetuje NPC do jego początkowego stanu (w odniesieniu do handlera słów kluczowych).
	-- Wszystkie moduły również otrzymują wywołanie resetujące poprzez ich funkcję callbackOnModuleReset.
	function NpcHandler:resetNpc(cid)
		if self:processModuleCallback(CALLBACK_MODULE_RESET) then
			self.keywordHandler:reset(cid)
		end
	end

	function NpcHandler:cancelNPCTalk(events)
		for aux = 1, #events do
			stopEvent(events[aux].event)
		end
		events = nil
	end

	function NpcHandler:doNPCTalkALot(msgs, interval, pcid)
		if self.eventDelayedSay[pcid] then
			self:cancelNPCTalk(self.eventDelayedSay[pcid])
		end

		self.eventDelayedSay[pcid] = {}
		local ret = {}
		for aux = 1, #msgs do
			self.eventDelayedSay[pcid][aux] = {}
			doCreatureSayWithDelay(getNpcCid(), msgs[aux], TALKTYPE_PRIVATE_NP, ((aux-1) * (interval or 4000)) + 700, self.eventDelayedSay[pcid][aux], pcid)
			ret[#ret +1] = self.eventDelayedSay[pcid][aux]
		end
		return(ret)
	end

	-- Powoduje, że NPC reprezentowany przez tę instancję NpcHandler coś mówi.
	-- Implementuje aktualnie ustawiony typ opóźnienia mówienia.
	-- shallDelay to wartość logiczna. Jeśli jest fałszywa, wiadomość nie jest opóźniona. Wartość domyślna to true.
	function NpcHandler:say(message, focus, publicize, shallDelay, delay)
		if type(message) == "table" then
			return self:doNPCTalkALot(message, delay or 6000, focus)
		end

		if self.eventDelayedSay[focus] then
			self:cancelNPCTalk(self.eventDelayedSay[focus])
		end

		local shallDelay = not shallDelay and true or shallDelay
		if NPCHANDLER_TALKDELAY == TALKDELAY_NONE or shallDelay == false then
			selfSay(message, focus, publicize and true or false)
			return
		end

		stopEvent(self.eventSay[focus])
		self.eventSay[focus] = addEvent(function(npcId, message, focusId)
			local npc = Npc(npcId)
			if npc == nil then
				return
			end

			local player = Player(focusId)
			if player then
				local parseInfo = {[TAG_PLAYERNAME] = player:getName(), [TAG_TIME] = getTibianTime(), [TAG_BLESSCOST] = getBlessingsCost(player:getLevel()), [TAG_PVPBLESSCOST] = getPvpBlessingCost(player:getLevel())}
				npc:say(self:parseMessage(message, parseInfo), TALKTYPE_PRIVATE_NP, false, player, npc:getPosition())
			end
		end, self.talkDelayTime * 1000, Npc().uid, message, focus)
	end
end