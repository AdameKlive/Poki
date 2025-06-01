local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)
combat:setArea(createCombatArea(AREA_CIRCLE5X5))

local condition = Condition(CONDITION_ATTRIBUTES)
condition:setParameter(CONDITION_PARAM_SUBID, 3)
condition:setParameter(CONDITION_PARAM_TICKS, 2 * 60 * 1000) -- Czas trwania warunku: 2 minuty
condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 1) -- Zwiększa punkty magii o 1
condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true) -- Oznacza jako zaklęcie wzmacniające

local baseMana = 120 -- Bazowy koszt many

function onCastSpell(creature, variant, isHotkey)
	local position = creature:getPosition()
	local party = creature:getParty()
	if not party then
		creature:sendCancelMessage("Brak członków drużyny w zasięgu.")
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local membersList = party:getMembers()
	membersList[#membersList + 1] = party:getLeader() -- Dodaje lidera partii do listy, jeśli nie był już uwzględniony

	-- Sprawdza, czy lista członków partii jest pusta lub zawiera tylko rzucającego zaklęcie
	if membersList == nil or type(membersList) ~= 'table' or #membersList <= 1 then
		creature:sendCancelMessage("Brak członków drużyny w zasięgu.")
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local affectedList = {}
	for _, targetPlayer in ipairs(membersList) do
		-- Sprawdza, czy członek partii znajduje się w zasięgu 36 kratek
		if targetPlayer:getPosition():getDistance(position) <= 36 then
			affectedList[#affectedList + 1] = targetPlayer
		end
	end

	local count = #affectedList
	-- Jeśli dotkniętych graczy jest mniej niż dwóch (czyli tylko rzucający zaklęcie)
	if count <= 1 then
		creature:sendCancelMessage("Brak członków drużyny w zasięgu.")
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	-- Oblicza koszt many, który rośnie wraz z liczbą członków drużyny
	local mana = math.ceil((0.9 ^ (count - 1) * baseMana) * count)
	if creature:getMana() < mana then
		creature:sendCancelMessage(RETURNVALUE_NOTENOUGHMANA) -- Wiadomość o niewystarczającej ilości many
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	-- Wykonuje działanie bojowe (rzuca zaklęcie obszarowe)
	elseif not combat:execute(creature, variant) then
		creature:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE) -- Wiadomość o niemożności wykonania
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	-- Odlicza manę od rzucającego zaklęcie
	creature:addMana(baseMana - mana, false) -- Dodaje manę (w rzeczywistości odejmuje, jeśli mana > baseMana)
	creature:addManaSpent(mana - baseMana) -- Dodaje zużytą manę do statystyk

	-- Nakłada warunek (buff) na wszystkich dotkniętych członków drużyny
	for _, targetPlayer in ipairs(affectedList) do
		targetPlayer:addCondition(condition)
	end
	return true
end