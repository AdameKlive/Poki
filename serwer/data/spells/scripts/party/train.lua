local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)
combat:setArea(createCombatArea(AREA_CIRCLE5X5))

local condition = Condition(CONDITION_ATTRIBUTES)
condition:setParameter(CONDITION_PARAM_SUBID, 1)
condition:setParameter(CONDITION_PARAM_TICKS, 2 * 60 * 1000) -- Czas trwania: 2 minuty
condition:setParameter(CONDITION_PARAM_SKILL_FIST, 3)
condition:setParameter(CONDITION_PARAM_SKILL_MELEE, 3)
condition:setParameter(CONDITION_PARAM_SKILL_DISTANCE, 3)
condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true) -- Oznacza, że to zaklęcie wzmacniające

local baseMana = 60 -- Bazowa ilość many

function onCastSpell(creature, variant, isHotkey)
	local position = creature:getPosition()
	local party = creature:getParty()
	if not party then
		creature:sendCancelMessage("Brak członków drużyny w zasięgu.")
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local membersList = party:getMembers()
	membersList[#membersList + 1] = party:getLeader() -- Dodaje lidera drużyny do listy

	if membersList == nil or type(membersList) ~= 'table' or #membersList <= 1 then
		creature:sendCancelMessage("Brak członków drużyny w zasięgu.")
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local affectedList = {}
	-- Filtruje członków drużyny, którzy są w zasięgu 36 kratek
	for _, targetPlayer in ipairs(membersList) do
		if targetPlayer:getPosition():getDistance(position) <= 36 then
			affectedList[#affectedList + 1] = targetPlayer
		end
	end

	local count = #affectedList
	if count <= 1 then
		creature:sendCancelMessage("Brak członków drużyny w zasięgu.")
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	-- Oblicza koszt many na podstawie liczby dotkniętych graczy
	local mana = math.ceil((0.9 ^ (count - 1) * baseMana) * count)
	if creature:getMana() < mana then
		creature:sendCancelMessage(RETURNVALUE_NOTENOUGHMANA) -- Komunikat o niewystarczającej ilości many
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	elseif not combat:execute(creature, variant) then
		creature:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE) -- Komunikat o niemożności wykonania
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end
	creature:addMana(baseMana - mana, false) -- Dodaje lub odejmuje manę od stwora
	creature:addManaSpent(mana - baseMana) -- Dodaje zużytą manę do statystyk

	-- Nakłada warunek (buff) na wszystkich dotkniętych graczy
	for _, targetPlayer in ipairs(affectedList) do
		targetPlayer:addCondition(condition)
	end
	return true
end