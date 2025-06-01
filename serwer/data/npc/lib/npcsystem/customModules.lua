-- Moduły niestandardowe, stworzone w celu wsparcia tego datapacka
local travelDiscounts = {
--	['postman'] = {price = 10, storage = Storage.postman.Rank, value = 3},
--	['new frontier'] = {price = 50, storage = Storage.TheNewFrontier.Mission03, value = 1}
}

function StdModule.travelDiscount(player, discounts)
	local discountPrice, discount = 0
	if type(discounts) == 'string' then
		discount = travelDiscounts[discounts]
		if discount and player:getStorageValue(discount.storage) >= discount.value then
			return discount.price
		end
	else
		for i = 1, #discounts do
			discount = travelDiscounts[discounts[i]]
			if discount and player:getStorageValue(discount.storage) >= discount.value then
				discountPrice = discountPrice + discount.price
			end
		end
	end

	return discountPrice
end

function StdModule.kick(cid, message, keywords, parameters, node)
	local npcHandler = parameters.npcHandler
	if npcHandler == nil then
		error("StdModule.travel wywołane bez instancji npcHandler.")
	end

	if not npcHandler:isFocused(cid) then
		return false
	end

	npcHandler:releaseFocus(cid)
	npcHandler:say(parameters.text or "Zmykaj stąd!", cid)

	local destination = parameters.destination
	if type(destination) == 'table' then
		destination = destination[math.random(#destination)]
	end

	Player(cid):teleportTo(destination, true)

	npcHandler:resetNpc(cid)
	return true
end

local GreetModule = {}
function GreetModule.greet(cid, message, keywords, parameters)
	if not parameters.npcHandler:isInRange(cid) then
		return true
	end

	if parameters.npcHandler:isFocused(cid) then
		return true
	end

	local parseInfo = { [TAG_PLAYERNAME] = Player(cid):getName() }
	parameters.npcHandler:say(parameters.npcHandler:parseMessage(parameters.text, parseInfo), cid, true)
	parameters.npcHandler:addFocus(cid)
	return true
end

function GreetModule.farewell(cid, message, keywords, parameters)
	if not parameters.npcHandler:isFocused(cid) then
		return false
	end

	local parseInfo = { [TAG_PLAYERNAME] = Player(cid):getName() }
	parameters.npcHandler:say(parameters.npcHandler:parseMessage(parameters.text, parseInfo), cid, true)
	parameters.npcHandler:resetNpc(cid)
	parameters.npcHandler:releaseFocus(cid)
	return true
end

-- Dodaje słowo kluczowe, które działa jako słowo powitalne
function KeywordHandler:addGreetKeyword(keys, parameters, condition, action)
	local keys = keys
	keys.callback = FocusModule.messageMatcherDefault
	return self:addKeyword(keys, GreetModule.greet, parameters, condition, action)
end

-- Dodaje słowo kluczowe, które działa jako słowo pożegnalne
function KeywordHandler:addFarewellKeyword(keys, parameters, condition, action)
	local keys = keys
	keys.callback = FocusModule.messageMatcherDefault
	return self:addKeyword(keys, GreetModule.farewell, parameters, condition, action)
end

-- Dodaje słowo kluczowe, które działa jako słowo zaklęcia
function KeywordHandler:addSpellKeyword(keys, parameters)
	local keys = keys
	keys.callback = FocusModule.messageMatcherDefault

	local npcHandler, spellName, price, vocationId = parameters.npcHandler, parameters.spellName, parameters.price, parameters.vocation
	local spellKeyword = self:addKeyword(keys, StdModule.say, {npcHandler = npcHandler, text = string.format("Chcesz nauczyć się zaklęcia '%s' za %s?", spellName, price > 0 and price .. ' złota' or 'darmo')},
		function(player)
			local baseVocationId = player:getVocation():getBase():getId()
			if type(vocationId) == 'table' then
				return isInArray(vocationId, baseVocationId)
			else
				return vocationId == baseVocationId
			end
		end
	)

	spellKeyword:addChildKeyword({'tak'}, StdModule.learnSpell, {npcHandler = npcHandler, spellName = spellName, level = parameters.level, price = price})
	spellKeyword:addChildKeyword({'nie'}, StdModule.say, {npcHandler = npcHandler, text = 'Może następnym razem.', reset = true})
end

local hints = {
	[-1] = 'Jeśli nie znasz znaczenia ikony po prawej stronie, najedź na nią kursorem myszy i poczekaj chwilę.',
	[0] = 'Wysyłaj prywatne wiadomości do innych graczy, klikając prawym przyciskiem myszy na gracza lub jego nazwę i wybierając \'Wiadomość do ....\'. Możesz również otworzyć \'prywatny kanał wiadomości\' i wpisać nazwę gracza.',
	[1] = 'Użyj skrótów \'SHIFT\' do oglądania, \'CTRL\' do używania i \'ALT\' do atakowania, klikając na obiekt lub gracza.',
	[2] = 'Jeśli wiesz już, dokąd chcesz iść, kliknij na automapę, a Twoja postać automatycznie tam pójdzie, jeśli lokalizacja jest osiągalna i niezbyt daleko.',
	[3] = 'Aby otworzyć lub zamknąć listę umiejętności, bitwy lub VIP, kliknij odpowiedni przycisk po prawej stronie.',
	[4] = '\'Pojemność\' ogranicza ilość rzeczy, które możesz ze sobą nosić. Rośnie z każdym poziomem.',
	[5] = 'Zawsze obserwuj swój pasek zdrowia. Jeśli zauważysz, że nie regenerujesz już punktów zdrowia, zjedz coś.',
	[6] = 'Zawsze jedz tyle jedzenia, ile to możliwe. W ten sposób będziesz regenerować punkty zdrowia przez dłuższy czas.',
	[7] = 'Po zabiciu potwora masz 10 sekund, podczas których zwłoki są nieruchome i nikt inny oprócz Ciebie nie może ich zrabować.',
	[8] = 'Zachowaj ostrożność, gdy zbliżasz się do trzech lub więcej potworów, ponieważ możesz blokować ataki tylko dwóch. W takiej sytuacji nawet kilka szczurów może zadać poważne obrażenia lub nawet Cię zabić.',
	[9] = 'Istnieje wiele sposobów na zdobycie jedzenia. Wiele stworzeń upuszcza jedzenie, ale możesz też zbierać jagody lub piec własny chleb. Jeśli masz wędkę i robaki w ekwipunku, możesz również spróbować złowić rybę.',
	[10] = {'Pieczenie chleba jest dość skomplikowane. Przede wszystkim potrzebujesz kosy do zbioru pszenicy. Następnie użyj pszenicy z kamieniem młyńskim, aby uzyskać mąkę. ...', 'Może być użyta z wodą, aby uzyskać ciasto, które można użyć w piecu do upieczenia chleba. Użyj mleka zamiast wody, aby uzyskać ciasto na ciasto.'},
	[11] = 'Śmierć boli! Lepiej uciekać, niż ryzykować życie. Stracisz doświadczenie i punkty umiejętności, gdy umrzesz.',
	[12] = 'Kiedy przełączysz się na \'Ofensywną Walkę\', zadajesz więcej obrażeń, ale też łatwiej Cię zranić.',
	[13] = 'Gdy masz mało zdrowia i musisz uciekać przed potworem, przełącz się na \'Defensywną Walkę\', a potwór zada Ci mniej poważne obrażenia.',
	[14] = 'Wiele stworzeń próbuje od Ciebie uciekać. Wybierz \'Ścigaj Przeciwnika\', aby za nimi podążać.',
	[15] = 'Im głębiej wejdziesz do lochu, tym będzie bardziej niebezpiecznie. Podchodź do każdego lochu z najwyższą ostrożnością, bo nieoczekiwane stworzenie może Cię zabić. Spowoduje to utratę doświadczenia i punktów umiejętności.',
	[16] = 'Ze względu na perspektywę, niektóre obiekty w Tibii nie znajdują się w miejscu, w którym wydają się pojawiać (drabiny, okna, lampy). Spróbuj kliknąć na kafelek podłogi, na którym obiekt powinien leżeć.',
	[17] = 'Jeśli chcesz wymienić przedmiot z innym graczem, kliknij prawym przyciskiem myszy na przedmiot i wybierz \'Handluj z ...\', a następnie kliknij na gracza, z którym chcesz handlować.',
	[18] = 'Schody, drabiny i wejścia do lochów są oznaczone żółtymi kropkami na automapie.',
	[19] = 'Jedzenie można zdobyć, zabijając zwierzęta lub potwory. Można też zbierać jagody lub piec własny chleb. Jeśli jesteś zbyt leniwy lub masz za dużo pieniędzy, możesz również kupić jedzenie.',
	[20] = 'Kontenery questowe łatwo rozpoznać. Nie otwierają się regularnie, ale wyświetlają wiadomość \'Znalazłeś ....\'. Można je otworzyć tylko raz.',
	[21] = 'Lepiej uciekać, niż ryzykować śmierć. Stracisz doświadczenie i punkty umiejętności za każdym razem, gdy umrzesz.',
	[22] = 'Możesz utworzyć grupę, klikając prawym przyciskiem myszy na gracza i wybierając \'Zaproś do Grupy\'. Lider grupy może również włączyć \'Wspólne Doświadczenie\', klikając prawym przyciskiem myszy na sobie.',
	[23] = 'Możesz przypisać zaklęcia, użycie przedmiotów lub losowy tekst do \'hotkeyów\'. Znajdziesz je w \'Opcjach\'.',
	[24] = 'Możesz również podążać za innymi graczami. Po prostu kliknij prawym przyciskiem myszy na gracza i wybierz \'Podążaj\'.',
	[25] = 'Możesz założyć grupę ze swoimi przyjaciółmi, klikając prawym przyciskiem myszy na gracza i wybierając \'Zaproś do Grupy\'. Jeśli zostałeś zaproszony do grupy, kliknij prawym przyciskiem myszy na sobie i wybierz \'Dołącz do Grupy\'.',
	[26] = 'Zakładaj grupy tylko z ludźmi, którym ufasz. Możesz atakować ludzi w swojej grupie bez otrzymywania czaszki. Jest to pomocne w trenowaniu umiejętności, ale może być nadużywane do zabijania ludzi bez obawy o negatywne konsekwencje.',
	[27] = 'Lider grupy ma możliwość rozdzielania zdobytego doświadczenia wśród wszystkich graczy w grupie. Jeśli jesteś liderem, kliknij prawym przyciskiem myszy na sobie i wybierz \'Włącz Wspólne Doświadczenie\'.',
	[28] = 'Nic więcej nie mogę Ci powiedzieć. Jeśli nadal potrzebujesz {wskazówek}, mogę je powtórzyć.'
}

function StdModule.rookgaardHints(cid, message, keywords, parameters, node)
	local npcHandler = parameters.npcHandler
	if npcHandler == nil then
		error("StdModule.say wywołane bez instancji npcHandler.")
	end

	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	local hintId = player:getStorageValue(Storage.RookgaardHints)
	npcHandler:say(hints[hintId], cid)
	if hintId >= #hints then
		player:setStorageValue(Storage.RookgaardHints, -1)
	else
		player:setStorageValue(Storage.RookgaardHints, hintId + 1)
	end
	return true
end

-- VoiceModule
VoiceModule = {
	voices = nil,
	voiceCount = 0,
	lastVoice = 0,
	timeout = nil,
	chance = nil,
	npcHandler = nil
}

-- Tworzy nową instancję VoiceModule
function VoiceModule:new(voices, timeout, chance)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	obj.voices = voices
	for i = 1, #obj.voices do
		local voice = obj.voices[i]
		if voice.yell then
			voice.yell = nil
			voice.talktype = TALKTYPE_YELL
		else
			voice.talktype = TALKTYPE_SAY
		end
	end

	obj.voiceCount = #voices
	obj.timeout = timeout or 10
	obj.chance = chance or 25
	return obj
end

function VoiceModule:init(handler)
	return true
end

function VoiceModule:callbackOnThink()
	if self.lastVoice < os.time() then
		self.lastVoice = os.time() + self.timeout
		if math.random(100) < self.chance  then
			local voice = self.voices[math.random(self.voiceCount)]
			Npc():say(voice.text, voice.talktype)
		end
	end
	return true
end