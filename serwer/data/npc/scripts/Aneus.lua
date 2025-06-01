local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

keywordHandler:addKeyword({'soldiers'}, StdModule.say, {npcHandler = npcHandler, text = "To była elita całej armii. Nazywano ich Czerwoną Legią (znaną również jako Krwawa Legia)."})
keywordHandler:addKeyword({'orcs'}, StdModule.say, {npcHandler = npcHandler, text = "Orkowie od czasu do czasu atakowali robotników, zakłócając w ten sposób PRACE nad miastem."})
keywordHandler:addKeyword({'cruelty'}, StdModule.say, {npcHandler = npcHandler, text = "Żołnierze traktowali robotników jak niewolników."})
keywordHandler:addKeyword({'island'}, StdModule.say, {npcHandler = npcHandler, text = "Generał Czerwonej Legii bardzo rozgniewał się na te ataki i po kilku miesiącach ODPOWIEDZIAŁ!"})

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	elseif msgcontains(msg, "story") then
		npcHandler:say({
			'Dobrze, usiądź i posłuchaj. Dawno temu, jeden z przodków ... <naciśnij m, aby więcej>',
			'... naszego króla Tibianusa III chciał zbudować najlepsze MIASTO w całej Tibii.'
		}, cid)
	elseif msgcontains(msg, "city") then
		npcHandler:say({
			'Prace nad tym nowym miastem rozpoczęły się, a król wysłał swoich najlepszych ... <m>',
			'... ŻOŁNIERZY, aby chronili robotników przed ORKAMI i zmuszali ich do CIĘŻSZEJ PRACY.'
		}, cid)
	elseif msgcontains(msg, "works") then
		npcHandler:say({
			'Rozwój miasta szedł dobrze. Zbudowano również gigantyczny zamek ... <m>',
			'... na północny wschód od miasta. Ale coraz więcej robotników zaczęło SIĘ BUNTOWAĆ z powodu złych warunków.'
		}, cid)
	elseif msgcontains(msg, "rebel") then
		npcHandler:say({
			'Wszyscy buntownicy zostali zabrani do gigantycznego zamku. Strzeżeni przez Czerwoną Legię, ... <m>',
			'... musieli pracować i żyć w jeszcze gorszych warunkach. Trafili tam również niektórzy PRZYJACIELE siostry króla.'
		}, cid)
	elseif msgcontains(msg, "friends") then
		npcHandler:say({
			'Siostra króla była dość zaniepokojona tą sytuacją, ale jej brat ... <m>',
			'... nie chciał nic z tym zrobić. Postanowiła więc ułożyć PLAN, aby na zawsze zniszczyć Czerwoną Legię za ich OKRUCIEŃSTWO.'
		}, cid)
	elseif msgcontains(msg, "plan") then
		npcHandler:say({
			'Rozkazała swoim lojalnym druidom i łowcom, aby przebrali się ... <m>',
			'... za orków z pobliskiej WYSPY i noc w noc ATAKOWALI Czerwoną Legię.'
		}, cid)
	elseif msgcontains(msg, "stroke") then
		npcHandler:say({
			'Większość Czerwonej Legii udała się nocą na wyspę. Orkowie ... <m>',
			'... nie byli przygotowani, a Czerwona Legia zabiła setki orków ... <m>',
			'... prawie bez strat. Kiedy byli usatysfakcjonowani, WRÓCILI do zamku.'
		}, cid)
	elseif msgcontains(msg, "walked back") then
		npcHandler:say({
			'Mówi się, że orkowie szamani przeklęli Czerwoną Legię. <m>',
			'Nikt nie wie. Ale jedna trzecia żołnierzy zginęła z powodu choroby w drodze powrotnej. <m>',
			'A orkowie chcieli się zemścić i po kilku dniach uderzyli ponownie! <m>',
			'Orkowie i wielu sprzymierzonych cyklopów i minotaurów z całej ...<m>',
			'... Tibii przybyło, aby pomścić swoich przyjaciół, i zabili prawie wszystkich ... <m>',
			'... robotników i żołnierzy w zamku. POMOC siostry króla nadeszła za późno.'
		}, cid)
	elseif msgcontains(msg, "help") then
		npcHandler:say({
			'Próbowała ratować robotników, ale było już za późno. Orkowie ... <m>',
			'... natychmiast zaczęli atakować również jej oddziały. Jej królewskie wojska ... <m>',
			'... wróciły do miasta. SZTUCZKA uratowała miasto przed ZNISZCZENIEM.'
		}, cid)
	elseif msgcontains(msg, "destruction") then
		npcHandler:say({
			'Użyli tej samej sztuczki co przeciwko Czerwonej Legii, a orkowie ... <m>',
			'... zaczęli walczyć ze swoimi nieorkowymi sojusznikami. Po krwawej, długiej walce ... <m>',
			'... orkowie wrócili do swoich miast. Miasto Carlin zostało uratowane. <m>',
			'Od tamtej pory Carlin zawsze rządzi kobieta, a ten posąg ... <m>',
			'... został wykonany, aby przypominać nam o ich wspaniałych taktykach przeciwko orkom ... <m>',
			'... i Czerwonej Legii. To była historia Carlin i tych Pól Chwały. Mam nadzieję, że Ci się spodobało. *Uśmiecha się*'
		}, cid)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Witaj, podróżniku |PLAYERNAME|. Co cię do mnie sprowadza?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Do widzenia i uważaj na siebie!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())