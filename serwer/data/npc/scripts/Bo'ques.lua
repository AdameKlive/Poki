local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = { {text = 'No dobra, na czym to ja skończyłem...'} }
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	local missionProgress = player:getStorageValue(Storage.DjinnWar.MaridFaction.Mission01)
	if msgcontains(msg, 'przepis') or msgcontains(msg, 'misja') then
		if missionProgress < 1 then
			npcHandler:say({
				'Moja kolekcja przepisów jest prawie kompletna. Brakuje tylko kilku. ...',
				'Hmm... skoro już o tym mowa. Jest coś, w czym mógłbyś mi pomóc. Jesteś zainteresowany?'
			}, cid)
			npcHandler.topic[cid] = 1
		else
			npcHandler:say('Już ci mówiłem o brakujących przepisach, teraz proszę, spróbuj znaleźć książkę kucharską krasnoludzkiej kuchni.', cid)
		end

	elseif msgcontains(msg, 'książka kucharska') then
		if missionProgress == -1 then
			npcHandler:say({
				'Przygotowuję jedzenie dla wszystkich djinnów w Ashta\'daramai. ...',
				'Dlatego jestem tym, co powszechnie nazywa się kucharzem, chociaż nie lubię zbytnio tego słowa. Jest wulgarne. Wolę nazywać się \'szefem kuchni\'.'
			}, cid)
		elseif missionProgress == 1 then
			npcHandler:say('Czy masz ze sobą książkę kucharską krasnoludzkiej kuchni? Mogę ją mieć?', cid)
			npcHandler.topic[cid] = 2
		else
			npcHandler:say('Jeszcze raz dziękuję za przyniesienie mi tej książki!', cid)
		end

	elseif npcHandler.topic[cid] == 1 then
		if msgcontains(msg, 'tak') then
			npcHandler:say({
				'Świetnie! Mimo że znam tak wiele przepisów, szukam opisu kilku krasnoludzkich dań. ...',
				'Więc jeśli mógłbyś przynieść mi książkę kucharską krasnoludzkiej kuchni, dobrze cię wynagrodzę.'
			}, cid)
			player:setStorageValue(Storage.DjinnWar.MaridFaction.Mission01, 1)

		elseif msgcontains(msg, 'nie') then
			npcHandler:say('Cóż, szkoda.', cid)
		end
		npcHandler.topic[cid] = 0

	elseif npcHandler.topic[cid] == 2 then
		if msgcontains(msg, 'tak') then
			if not player:removeItem(2347, 1) then
				npcHandler:say('Szkoda. Muszę mieć tę książkę.', cid)
				return true
			end

			npcHandler:say({
				'Książka! Masz ją! Daj mi zobaczyć! <przegląda książkę> ...',
				'Omlet z jaj smoka, sos z krasnoludzkiego piwa... wszystko tam jest. To wspaniale! Oto twoja zasłużona nagroda. ...',
				'Przy okazji, rozmawiałem z Fa\'hradinem o tobie podczas kolacji. Myślę, że może mieć dla ciebie jakąś pracę. Dlaczego byś z nim o tym nie porozmawiał?'
			}, cid)
			player:setStorageValue(Storage.DjinnWar.MaridFaction.Mission01, 2)
			player:addItem(2146, 3)

		elseif msgcontains(msg, 'nie') then
			npcHandler:say('Szkoda. Muszę mieć tę książkę.', cid)
		end
		npcHandler.topic[cid] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Hej! Człowiek! Co robisz w mojej kuchni, |PLAYERNAME|?')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Do widzenia. Jestem pewien, że wrócisz po więcej. Wszyscy wracają.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Do widzenia. Jestem pewien, że wrócisz po więcej. Wszyscy wracają.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

local focusModule = FocusModule:new()
focusModule:addGreetMessage('hi')
focusModule:addGreetMessage('hello')
focusModule:addGreetMessage('djanni\'hah')
npcHandler:addModule(focusModule)